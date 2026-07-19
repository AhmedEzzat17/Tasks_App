import 'dart:convert';
import 'package:http/http.dart' as http; //
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<Map<String, String>> _getHeaders() async {//تحويل البيانات الى json and return bearer 
    final token = (await SharedPreferences.getInstance()).getString('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token', //return bearer
    };
  }

  static Future<dynamic> _sendRequest(//ارسال طلب للسيرفر
    Future<http.Response> Function(Map<String, String> headers) requestAction,
  ) async {
    try {
      final response = await requestAction(await _getHeaders());
      return _handleResponse(response);
    } catch (e) {
      throw 'Server Error';
    }
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final data = await _sendRequest(
      (h) => http.post(
        Uri.parse('$baseUrl/register'),
        headers: h,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        }),
      ),
    );
    if (data['token'] != null)
      await (await SharedPreferences.getInstance()).setString(
        'token',
        data['token'],
      );
    return data;
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final data = await _sendRequest(
      (h) => http.post(
        Uri.parse('$baseUrl/login'),
        headers: h,
        body: jsonEncode({'email': email, 'password': password}),
      ),
    );
    if (data['token'] != null)
      await (await SharedPreferences.getInstance()).setString(
        'token',
        data['token'],
      );
    return data;
  }

  static Future<void> logout() async {
    await http.post(Uri.parse('$baseUrl/logout'), headers: await _getHeaders());
    await (await SharedPreferences.getInstance()).remove('token');
  }

  static Future<UserModel> profile() async {
    final data = await _sendRequest(
      (h) => http.get(Uri.parse('$baseUrl/profile'), headers: h),
    );
    return UserModel.fromJson(data['user'] ?? data);
  }

  static Future<Map<String, dynamic>> getDashboard() async =>
      await _sendRequest(
        (h) => http.get(Uri.parse('$baseUrl/dashboard'), headers: h),
      );

  static Future<List<TaskModel>> getTasks({
    String? search,
    String? status,
    String? priority,
    String? category,
    String endpoint = 'tasks',
  }) async {
    final query = <String, String>{
      if (search != null && search.isNotEmpty) 'search': search,
      if (status != null && status != 'All') 'status': status,
      if (priority != null && priority != 'All') 'priority': priority,
      if (category != null && category != 'All') 'category': category,
    };
    final data = await _sendRequest(
      (h) => http.get(
        Uri.parse('$baseUrl/$endpoint').replace(queryParameters: query),
        headers: h,
      ),
    );
    final List list = data is List
        ? data
        : (data is Map ? (data['tasks'] ?? data['data'] ?? []) : []);
    return list
        .map((json) => TaskModel.fromJson(json))
        .toList()
        .reversed
        .toList();
  }

  static Future<List<TaskModel>> todayTasks() async =>
      getTasks(endpoint: 'tasks/today');

  static Future<TaskModel> getTask(int id) async {
    final data = await _sendRequest(
      (h) => http.get(Uri.parse('$baseUrl/tasks/$id'), headers: h),
    );
    return TaskModel.fromJson(data['task'] ?? data);
  }

  static Future<TaskModel> createTask(TaskModel task) async {
    final data = await _sendRequest(
      (h) => http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: h,
        body: jsonEncode(task.toJson()),
      ),
    );
    return TaskModel.fromJson(data['task'] ?? data);
  }

  static Future<TaskModel> updateTask(TaskModel task) async {
    final data = await _sendRequest(
      (h) => http.put(
        Uri.parse('$baseUrl/tasks/${task.id}'),
        headers: h,
        body: jsonEncode(task.toJson()),
      ),
    );
    return TaskModel.fromJson(data['task'] ?? data);
  }

  static Future<void> deleteTask(int id) async => await _sendRequest(
    (h) => http.delete(Uri.parse('$baseUrl/tasks/$id'), headers: h),
  );

  static Future<List<TaskModel>> getDeletedTasks() async {
    final data = await _sendRequest(
      (h) => http.get(Uri.parse('$baseUrl/tasks?deleted=1'), headers: h),
    );
    final List list = data is List
        ? data
        : (data is Map ? (data['tasks'] ?? data['data'] ?? []) : []);
    return list
        .map((json) => TaskModel.fromJson(json))
        .toList()
        .reversed
        .toList();
  }

  static Future<void> restoreTask(int id) async => await _sendRequest(
    (h) => http.post(Uri.parse('$baseUrl/tasks/$id/restore'), headers: h),
  );

  static Future<TaskModel> updateStatus(int id, String status) async {
    try { // تحديث الحاله
      final task = await getTask(id);
      final updatedTask = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        category: task.category,
        priority: task.priority,
        status: status,
        dueDate: task.dueDate,
        reminder: task.reminder,
        notes: task.notes,
      );
      return await updateTask(updatedTask);
    } catch (e) {
      final data = await _sendRequest(
        (h) => http.patch(
          Uri.parse('$baseUrl/tasks/$id/status'),
          headers: h,
          body: jsonEncode({'status': status}),
        ),
      );
      return TaskModel.fromJson(data['task'] ?? data);
    }
  }

  static Future<List<CategoryModel>> getCategories() async {
    final data = await _sendRequest(
      (h) => http.get(Uri.parse('$baseUrl/categories'), headers: h),
    );
    final List list = data is List ? data : (data['categories'] ?? data['data'] ?? []);
    return list.map((json) => CategoryModel.fromJson(json)).toList();
  }

  static Future<void> deleteCategory(int id) async => await _sendRequest(
    (h) => http.delete(Uri.parse('$baseUrl/categories/$id'), headers: h),
  );

  static dynamic _handleResponse(http.Response response) {
    final code = response.statusCode;
    if (code >= 200 && code < 300) {
      return jsonDecode(response.body);
    }
    throw 'Request failed';
  }
}
