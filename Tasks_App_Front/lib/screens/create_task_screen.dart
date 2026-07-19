import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:tasks_app/providers/create_task_provider.dart';
import '../widgets/widgets.dart';

class CreateTaskScreen extends StatefulWidget { //page
  const CreateTaskScreen({super.key});
  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> { //content
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateTaskProvider>().loadCategories();// وصول get
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateTaskProvider>();// عرض rebuild
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : Form(
              key: provider.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: provider.titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title *',
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Enter title' : null,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: provider.descriptionController,
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
                          final isSel = provider.selectedPriority == p;
                          final color = getPriorityColor(p);
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ChoiceChip( //like a radio button
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
                              onSelected: (_) => provider.setPriority(p),
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
                              text: provider.selectedCategory,
                            ),
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return provider.categoriesList;
                                  }
                                  return provider.categoriesList.where((
                                    String option,
                                  ) {
                                    return option.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase(),
                                    );
                                  });
                                },
                            onSelected: (String selection) {
                              provider.setCategory(selection);
                            },
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
                                        provider.setCategory(val),
                                    decoration: const InputDecoration(
                                      labelText: 'Category *',
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                      hintText: 'Select...',
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
                            initialValue: provider.selectedStatus,
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
                            onChanged: (val) => provider.setStatus(val!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: primaryColor,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) provider.setDate(picked);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                provider.submitted &&
                                    provider.selectedDate == null
                                ? Colors.redAccent
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provider.selectedDate == null
                                  ? 'Pick Due Date *'
                                  : DateFormat(
                                      'dd MMM yyyy',
                                    ).format(provider.selectedDate!),
                              style: TextStyle(
                                fontSize: 16,
                                color: provider.selectedDate == null
                                    ? Colors.grey.shade600
                                    : Colors.black87,
                              ),
                            ),
                            Icon(
                              Icons.calendar_month_outlined,
                              color: provider.selectedDate == null
                                  ? Colors.grey
                                  : primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (provider.submitted && provider.selectedDate == null)
                      const Padding(
                        padding: EdgeInsets.only(left: 12, top: 6),
                        child: Text(
                          'Please pick a due date',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),

                    TextFormField(
                      controller: provider.notesController,
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
                          final success = await provider.saveTask();
                          if (!context.mounted) return;

                          if (success) {
                            showCustomToast(
                              context,
                              'Task Created Successfully!',
                            );
                            Navigator.pop(context, true);
                          } else {
                            showCustomToast(
                              context,
                              'Failed to create task',
                              isError: true,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Save Task',
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
