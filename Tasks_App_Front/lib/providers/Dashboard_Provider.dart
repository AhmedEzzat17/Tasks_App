import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../services/api.dart';

class DashboardProvider extends ChangeNotifier {
  UserModel? _user;

  int _total = 0;
  int _completed = 0;
  int _pending = 0;
  int _inProgress = 0;

  List<TaskModel> _recent = [];

  UserModel? get user => _user;
  int get total => _total;
  int get completed => _completed;
  int get pending => _pending;
  int get inProgress => _inProgress;
  
  List<TaskModel> get recent => _recent;

  Future<void> loadData() async {
    try {
      final results = await Future.wait([
        ApiService.profile(),
        ApiService.getDashboard(),
        ApiService.getTasks(),
      ]);
      _user = results[0] as UserModel;
      final stats = results[1] as Map<String, dynamic>;
      _total = int.tryParse(stats['total_tasks']?.toString() ?? '0') ?? 0;
      _completed =
          int.tryParse(stats['completed_tasks']?.toString() ?? '0') ?? 0;
      _pending = int.tryParse(stats['pending_tasks']?.toString() ?? '0') ?? 0;
      _inProgress =
          int.tryParse(stats['in_progress_tasks']?.toString() ?? '0') ?? 0;
      _recent = (results[2] as List<TaskModel>).take(3).toList();
      notifyListeners();
    } catch (_) {}
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
