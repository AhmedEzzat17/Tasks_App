import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/task_model.dart';

class TodayTasksProvider extends ChangeNotifier {//update
  List<TaskModel> tasks = [];

  Future<void> fetchTasks() async {
    try {//storge here
      tasks = await ApiService.todayTasks();
      notifyListeners();//show
    } catch (_) {}
  }
  //Status
  Future<void> updateTaskStatus(int id, String newStatus) async {
    try {
      await ApiService.updateStatus(id, newStatus);
      await fetchTasks();
    } catch (_) {}
  }
}
