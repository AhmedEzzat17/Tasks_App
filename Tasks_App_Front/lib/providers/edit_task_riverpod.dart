import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../services/api.dart';

final editTaskProvider = NotifierProvider<EditTaskNotifier, EditTaskState>(
  EditTaskNotifier.new,
);

class EditTaskState {
  bool isLoading;
  String selectedCategory;
  String selectedPriority;
  String selectedStatus;
  DateTime? selectedDate;
  List<String> categories;

  EditTaskState({
    this.isLoading = false,
    this.selectedCategory = '',
    this.selectedPriority = '',
    this.selectedStatus = '',
    this.selectedDate,
    this.categories = const [],
  });

  EditTaskState copyWith({
    bool? isLoading,
    String? selectedCategory,
    String? selectedPriority,
    String? selectedStatus,
    DateTime? selectedDate,
    List<String>? categories,
  }) {
    return EditTaskState(
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedPriority: selectedPriority ?? this.selectedPriority,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedDate: selectedDate ?? this.selectedDate,
      categories: categories ?? this.categories,
    );
  }
}

class EditTaskNotifier extends Notifier<EditTaskState> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final notesController = TextEditingController();

  @override
  EditTaskState build() => EditTaskState();

  void initialize(TaskModel task) {
    titleController.text = task.title;
    descriptionController.text = task.description ?? '';
    notesController.text = task.notes ?? '';
    state = state.copyWith(
      selectedCategory: task.category,
      selectedPriority: task.priority,
      selectedStatus: task.status,
      selectedDate: task.dueDate,
    );
  }

  Future<void> loadCategories() async {
    try {
      final cats = await ApiService.getCategories();
      final uniqueCats = {state.selectedCategory, ...cats.map((e) => e.name)};
      state = state.copyWith(categories: uniqueCats.toList());
    } catch (_) {}
  }

  void setPriority(String value) => state = state.copyWith(selectedPriority: value);
  void setCategory(String value) => state = state.copyWith(selectedCategory: value);
  void setStatus(String value) => state = state.copyWith(selectedStatus: value);
  void setDate(DateTime? value) => state = state.copyWith(selectedDate: value);

  Future<bool> save(TaskModel oldTask) async {
    if (!formKey.currentState!.validate()) return false;

    state = state.copyWith(isLoading: true);

    final task = TaskModel(
      id: oldTask.id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      category: state.selectedCategory,
      priority: state.selectedPriority,
      status: state.selectedStatus,
      dueDate: state.selectedDate,
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
    );

    try {
      await ApiService.updateTask(task);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  void disposeControllers() {
    titleController.dispose();
    descriptionController.dispose();
    notesController.dispose();
  }
}