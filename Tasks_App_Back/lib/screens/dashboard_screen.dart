import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Dashboard_Provider.dart';
import '../services/api.dart';
import '../widgets/widgets.dart';
import 'task_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onViewAllTasks;
  const DashboardScreen({super.key, required this.onViewAllTasks});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final percent = provider.total > 0
        ? (provider.completed / provider.total) * 100
        : 0.0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.getGreeting(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.user?.name}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: primaryColor.withValues(alpha: 0.1),
                      foregroundColor: primaryColor,
                      child: Text(
                        provider.user?.name.isNotEmpty == true
                            ? provider.user!.name[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryColor, Color(0xFF138A62)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Progress",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${percent.toStringAsFixed(0)}%",
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: provider.total > 0
                                ? provider.completed / provider.total
                                : 0.0,
                            backgroundColor: Colors.white24,
                            color: Colors.white,
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${provider.completed} of ${provider.total} tasks completed",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              const Text(
                'Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  StatCard(
                    title: 'Total Tasks',
                    value: provider.total.toString(),
                    icon: Icons.assignment_rounded,
                    color: primaryColor,
                  ),
                  StatCard(
                    title: 'Completed',
                    value: provider.completed.toString(),
                    icon: Icons.check_circle_rounded,
                    color: const Color(0xFF2ED573),
                  ),
                  StatCard(
                    title: 'Pending',
                    value: provider.pending.toString(),
                    icon: Icons.hourglass_empty_rounded,
                    color: const Color(0xFFFFA502),
                  ),
                  StatCard(
                    title: 'In Progress',
                    value: provider.inProgress.toString(),
                    icon: Icons.trending_up_rounded,
                    color: primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: widget.onViewAllTasks,
                    style: TextButton.styleFrom(foregroundColor: primaryColor),
                    child: const Text(
                      'View All',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              provider.recent.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_rounded,
                              size: 48,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No recent tasks',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.recent.length,
                      itemBuilder: (context, index) {
                        final task = provider.recent[index];
                        return TaskCard(
                          task: task,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailsScreen(
                                taskId: task.id,
                                onTaskDeletedOrUpdated: provider.loadData,
                              ),
                            ),
                          ),
                          onStatusChanged: (newStatus) async {
                            try {
                              await ApiService.updateStatus(task.id, newStatus);
                              provider.loadData();
                            } catch (_) {}
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
