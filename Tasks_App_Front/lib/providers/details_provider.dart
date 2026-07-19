import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/api.dart';

class DetailsProvider extends ChangeNotifier {
  TaskModel? task;
  bool isLoading = true;

  Future<void> fetch(int taskId) async {
    isLoading = true;
    notifyListeners();
    try {
      task = await ApiService.getTask(taskId);
    } catch (e) {
      task = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> delete(int taskId) async {
    try {
      await ApiService.deleteTask(taskId);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> toggleStatus(int taskId) async {
    if (task == null) return false;
    try {
      final newStatus = task!.status.toLowerCase() == 'done' ? 'To Do' : 'Done';
      task = await ApiService.updateStatus(taskId, newStatus);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}
