import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/widgets.dart';
import 'edit_task_screen.dart';
import 'package:provider/provider.dart';
import '../providers/details_provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final int taskId;
  final VoidCallback onTaskDeletedOrUpdated;
  const TaskDetailsScreen({
    super.key,
    required this.taskId,
    required this.onTaskDeletedOrUpdated,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailsProvider>().fetch(widget.taskId); // وصول get
    });
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete this task?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final success = await context.read<DetailsProvider>().delete(widget.taskId);

    if (!mounted) return;

    if (success) {
      widget.onTaskDeletedOrUpdated();

      showCustomToast(context, "Task deleted successfully");

      Navigator.pop(context);
    } else {
      showCustomToast(context, "Failed to delete task", isError: true);
    }
  }

  Future<void> _toggleStatus() async {
    final success = await context.read<DetailsProvider>().toggleStatus(
      widget.taskId,
    );

    if (!mounted) return;

    if (success) {
      widget.onTaskDeletedOrUpdated();

      showCustomToast(context, "Task updated successfully");
    } else {
      showCustomToast(context, "Failed", isError: true);
    }
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DetailsProvider>(); // عرض rebuild
    final t = provider.task;
    final pColor = t != null ? getPriorityColor(t.priority) : Colors.grey;
    final isDone = t != null ? t.status.toLowerCase() == 'done' : false;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Task Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () async {
              if (t != null &&
                  await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTaskScreen(task: t),
                        ),
                      ) ==
                      true) {
                await provider.fetch(widget.taskId);
                widget.onTaskDeletedOrUpdated();
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
            ),
            onPressed: _delete,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : t == null
          ? const Center(
              child: Text(
                'Task not found',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Column(
              children: [
                // Header Area
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flag_rounded,
                                  size: 14,
                                  color: pColor == Colors.grey
                                      ? Colors.white
                                      : pColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  t.priority,
                                  style: TextStyle(
                                    color: pColor == Colors.grey
                                        ? Colors.white
                                        : pColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isDone
                                      ? Icons.check_circle_outline
                                      : Icons.access_time_rounded,
                                  size: 14,
                                  color: isDone
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  t.status,
                                  style: TextStyle(
                                    color: isDone
                                        ? Colors.greenAccent
                                        : Colors.orangeAccent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        t.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                          color: isDone ? Colors.white70 : Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Sheet Area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  'Category',
                                  t.category,
                                  Icons.folder_outlined,
                                  primaryColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoCard(
                                  'Due Date',
                                  t.dueDate != null
                                      ? DateFormat(
                                          'dd MMM yyyy',
                                        ).format(t.dueDate!)
                                      : 'No date',
                                  Icons.calendar_today_outlined,
                                  Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              t.description?.isNotEmpty == true
                                  ? t.description!
                                  : 'No description provided for this task.',
                              style: TextStyle(
                                color: t.description?.isNotEmpty == true
                                    ? Colors.black87
                                    : Colors.grey.shade500,
                                height: 1.5,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          const Text(
                            'Notes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.amber.shade700,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    t.notes?.isNotEmpty == true
                                        ? t.notes!
                                        : 'No additional notes added.',
                                    style: TextStyle(
                                      color: t.notes?.isNotEmpty == true
                                          ? Colors.amber.shade900
                                          : Colors.amber.shade700,
                                      height: 1.5,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _toggleStatus,
                              icon: Icon(
                                isDone
                                    ? Icons.undo_rounded
                                    : Icons.check_circle_outline_rounded,
                              ),
                              label: Text(
                                isDone
                                    ? 'Mark as Incomplete'
                                    : 'Mark as Completed',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDone
                                    ? Colors.grey.shade300
                                    : const Color(0xFF2ED573),
                                foregroundColor: isDone
                                    ? Colors.black87
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: isDone ? 0 : 4,
                                shadowColor: isDone
                                    ? Colors.transparent
                                    : const Color(
                                        0xFF2ED573,
                                      ).withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
