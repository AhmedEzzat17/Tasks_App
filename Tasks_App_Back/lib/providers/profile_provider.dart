import 'package:flutter/material.dart';
import 'package:tasks_app/models/category_model.dart';
import 'package:tasks_app/models/task_model.dart';
import '../services/api.dart';
import '../models/user_model.dart';


class ProfileProvider extends ChangeNotifier{
  UserModel? user; 
  List<CategoryModel> categories = [];
  List<TaskModel> deletedTasks = [];

   Future<void> getProfile() async {
    try {
      user = await ApiService.profile();
      notifyListeners();
    } catch (_) {} 
  }

  
  Future<void> getCategories() async {
    categories = await ApiService.getCategories();
    notifyListeners();
  }

  Future<void> getDeletedTasks() async {
    deletedTasks = await ApiService.getDeletedTasks();
    notifyListeners();
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      await ApiService.deleteCategory(categoryId);

      categories.removeWhere(
        (element) => element.id == categoryId,
      );

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  
 Future<void> restoreTask(int taskId) async {
    try {
      await ApiService.restoreTask(taskId);

      deletedTasks.removeWhere(
        (element) => element.id == taskId,
      );

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future<void> logout()async{
    await ApiService.logout();
    user = null;
    notifyListeners();
  }

@override
void dispose() {
  categories.clear();
  deletedTasks.clear();
  user = null;
  super.dispose();
}
}