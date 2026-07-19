import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; //
import '../providers/today_tasks_provider.dart';
import '../widgets/widgets.dart';
import 'task_details_screen.dart';

class TodayTasksScreen extends StatefulWidget {
  const TodayTasksScreen({super.key});
  @override
  State<TodayTasksScreen> createState() => _TodayTasksScreenState();
}

class _TodayTasksScreenState extends State<TodayTasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodayTasksProvider>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodayTasksProvider>();//update
    return Scaffold(
      appBar: AppBar(title: const Text("Today's Tasks")),
      body: provider.tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks for today!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: provider.tasks.length,
              itemBuilder: (context, index) {
                final task = provider.tasks[index];

                return TaskCard(
                  task: task,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailsScreen(
                        taskId: task.id,
                        onTaskDeletedOrUpdated: provider.fetchTasks,
                      ),
                    ),
                  ),
                  onStatusChanged: (newStatus) =>
                      provider.updateTaskStatus(task.id, newStatus),
                );
              },
            ),
    );
  }
}
