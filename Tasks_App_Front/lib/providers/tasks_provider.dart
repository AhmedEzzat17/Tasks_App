import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/task_model.dart';

class TasksProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  final TextEditingController searchController = TextEditingController();
  String _status = 'All';
  String _priority = 'All';
  String _category = 'All';
  List<String> _categories = ['All'];

  List<TaskModel> get tasks => _tasks;
  String get status => _status;
  String get priority => _priority;
  String get category => _category;
  List<String> get categories => _categories;

  set status(String value) {
    _status = value;
    getTasks();
  }

  set priority(String value) {
    _priority = value;
    getTasks();
  }

  set category(String value) {
    _category = value;
    getTasks();
  }

  Future<void> loadCategories() async {
    try {
      final cats = await ApiService.getCategories();
      final uniqueCats = {'All', ...cats.map((e) => e.name)};
      _categories = uniqueCats.toList();
      if (!_categories.contains(_category)) {
        _category = 'All';
      }
      notifyListeners();
    } catch (e) {
      _categories = ['All'];
      notifyListeners();
    }
  }

  Future<void> getTasks() async {
    try {
      final data = await ApiService.getTasks(
        search: searchController.text.trim(),
        status: _status,
        priority: _priority,
        category: _category,
      );
      _tasks = data;
    } catch (e) {
      _tasks = [];
    } finally {
      notifyListeners();
    }
  }

  void searchTasks(String query) {
    getTasks();
  }

  void clearSearch() {
    searchController.clear();
    getTasks();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}