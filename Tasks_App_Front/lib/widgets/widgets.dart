import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

const primaryColor = Color.fromARGB(255, 10, 93, 65);

Color getPriorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return const Color(0xFFFF4757);
    case 'medium':
      return const Color(0xFFFFA502);
    default:
      return const Color(0xFF2ED573);
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'done':
      return const Color(0xFF2ED573);
    case 'in progress':
      return primaryColor;
    default:
      return const Color(0xFF747D8C);
  }
}

void showCustomToast(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
      backgroundColor: isError ? Colors.redAccent : primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      elevation: 4,
    ),
  );
}

class StatCard extends StatelessWidget { //Dashboard
  final String title, value;
  final IconData icon;
  final Color color;
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget { //Tasks  
  final TaskModel task;
  final VoidCallback onTap;
  final Function(String) onStatusChanged;
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status.toLowerCase() == 'done';
    final pColor = getPriorityColor(task.priority);
    final sColor = getStatusColor(task.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: isDone,
                  onChanged: (val) => onStatusChanged(isDone ? 'To Do' : 'Done'),
                  activeColor: const Color(0xFF2ED573),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                          color: isDone ? Colors.grey : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.folder_outlined, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            task.category,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            task.dueDate != null ? DateFormat('dd MMM yyyy').format(task.dueDate!) : 'No Date',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: pColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        task.priority,
                        style: TextStyle(
                          color: pColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: sColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        task.status,
                        style: TextStyle(
                          color: sColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
