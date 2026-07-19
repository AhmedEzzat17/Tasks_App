import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/edit_task_riverpod.dart';
import '../models/task_model.dart';
import '../widgets/widgets.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final TaskModel task;
  const EditTaskScreen({super.key, required this.task});

  @override
  ConsumerState<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(editTaskProvider.notifier);
      notifier.initialize(widget.task);
      notifier.loadCategories();
    });
  }

  // // @override
  // void autoDispose() {
  //   ref.invalidate(editTaskProvider);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editTaskProvider);
    final notifier = ref.read(editTaskProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : Form(
              key: notifier.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: notifier.titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title *',
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter title' : null,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: notifier.descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Priority *',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['Low', 'Medium', 'High'].map((p) {
                          final isSel = state.selectedPriority == p;
                          final color = getPriorityColor(p);
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ChoiceChip(
                              label: Text(
                                p,
                                style: TextStyle(
                                  color: isSel ? Colors.white : Colors.black87,
                                  fontWeight: isSel
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                              selected: isSel,
                              onSelected: (_) => notifier.setPriority(p),
                              selectedColor: color,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSel ? color : Colors.grey.shade300,
                                ),
                              ),
                              showCheckmark: false,
                              elevation: isSel ? 2 : 0,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Autocomplete<String>(
                            initialValue: TextEditingValue(
                              text: state.selectedCategory,
                            ),
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return state.categories;
                                  }
                                  return state.categories.where(
                                    (option) => option.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase(),
                                    ),
                                  );
                                },
                            onSelected: (String selection) =>
                                notifier.setCategory(selection),
                            fieldViewBuilder:
                                (
                                  context,
                                  controller,
                                  focusNode,
                                  onFieldSubmitted,
                                ) {
                                  return TextFormField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    onChanged: (val) =>
                                        notifier.setCategory(val),
                                    decoration: const InputDecoration(
                                      labelText: 'Category *',
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      hintText: 'Add Category',
                                    ),
                                    validator: (val) =>
                                        val == null || val.trim().isEmpty
                                        ? 'Required'
                                        : null,
                                  );
                                },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: state.selectedStatus.isNotEmpty
                                ? state.selectedStatus
                                : null, // ← التعديل المهم
                            decoration: const InputDecoration(
                              labelText: 'Status',
                            ),
                            items: ['To Do', 'In Progress', 'Done']
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) => notifier.setStatus(val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: state.selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 365),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null) {
                          notifier.setDate(picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.selectedDate == null
                                  ? 'Pick Due Date'
                                  : DateFormat(
                                      'dd MMM yyyy',
                                    ).format(state.selectedDate!),
                              style: TextStyle(
                                fontSize: 16,
                                color: state.selectedDate == null
                                    ? Colors.grey.shade600
                                    : Colors.black87,
                              ),
                            ),
                            Icon(
                              Icons.calendar_month_outlined,
                              color: state.selectedDate == null
                                  ? Colors.grey
                                  : primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: notifier.notesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                      ),
                    ),
                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          final success = await notifier.save(widget.task);
                          if (!mounted) return;
                          if (success) {
                            showCustomToast(
                              context,
                              'Task Updated Successfully!',
                            );
                            Navigator.pop(context, true);
                          } else {
                            showCustomToast(
                              context,
                              'Failed to update task',
                              isError: true,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
