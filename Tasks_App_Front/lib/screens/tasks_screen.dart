import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks_provider.dart';
import '../services/api.dart';
import '../widgets/widgets.dart';
import 'task_details_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TasksProvider>();
      provider.loadCategories();
      provider.getTasks();
    });
  }

  void _showFilterSheet(
    BuildContext context,
    String title,
    String currentValue,
    List<String> items,
    ValueChanged<String> onSelected,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by $title',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: items.map((item) {
                  final isSelected = item == currentValue;
                  return ChoiceChip(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    label: Text(
                      item,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        onSelected(item);
                        Navigator.pop(context);
                      }
                    },
                    selectedColor: primaryColor,
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? primaryColor : Colors.transparent,
                      ),
                    ),
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    String title,
    String value,
    List<String> items,
    ValueChanged<String> onSelected,
  ) {
    final isActive = value != 'All';
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => _showFilterSheet(context, title, value, items, onSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? primaryColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Text(
              isActive ? value : title,
              style: TextStyle(
                color: isActive ? primaryColor : Colors.black87,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: isActive ? primaryColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TasksProvider>(); // عرض rebuild
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              controller: provider.searchController,
              onChanged: (_) => provider.getTasks(),
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: primaryColor),
                ),
                suffixIcon: provider.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          provider.searchController.clear();
                          provider.getTasks();
                        },
                      )
                    : null,
              ),
            ),
          ),

          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterButton(
                  context,
                  'Status',
                  provider.status,
                  ['All', 'To Do', 'In Progress', 'Done'],
                  (v) {
                    provider.status = v;
                    provider.getTasks();
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterButton(
                  context,
                  'Priority',
                  provider.priority,
                  ['All', 'Low', 'Medium', 'High'],
                  (v) {
                    provider.priority = v;
                    provider.getTasks();
                  },
                ),
                const SizedBox(width: 8),
                _buildFilterButton(
                  context,
                  'Category',
                  provider.category,
                  provider.categories,
                  (v) {
                    provider.category = v;
                    provider.getTasks();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: provider.tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks found',
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              onTaskDeletedOrUpdated: provider.getTasks,
                            ),
                          ),
                        ),
                        onStatusChanged: (newStatus) async {
                          try {
                            await ApiService.updateStatus(task.id, newStatus);
                            provider.getTasks();
                          } catch (_) {}
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
