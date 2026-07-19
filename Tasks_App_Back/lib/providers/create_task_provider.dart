import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/api.dart';

class CreateTaskProvider extends ChangeNotifier {
  
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final notesController = TextEditingController();
  String selectedCategory = '';
  String selectedPriority = 'Low';
  String selectedStatus = 'To Do';
  DateTime? selectedDate;
  bool submitted = false;

  List<String> categories = []; //storage it
  bool isLoading = false;

  List<String> get categoriesList => categories;

  Future<void> loadCategories() async {
    try {
      final cats = await ApiService.getCategories();
      categories = cats.map((e) => e.name).toSet().toList();
      notifyListeners();
    } catch (_) {}
  }
  
//Encapsulation
  void setCategory(String value) {
    selectedCategory = value;
    notifyListeners();
  }

  void setPriority(String value) {
    selectedPriority = value;
    notifyListeners();
  }

  void setStatus(String value) {
    selectedStatus = value;
    notifyListeners();
  }

  void setDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }

Future<bool> saveTask() async {
    submitted = true;
    notifyListeners();

    if (!formKey.currentState!.validate() || selectedDate == null) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final task = TaskModel(
        id: 0,
        title: titleController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        category: selectedCategory,
        priority: selectedPriority,
        status: selectedStatus,
        dueDate: selectedDate,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
      );

      await ApiService.createTask(task);
      return true;
    } catch (_) {
      return false; 
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearAll() {
    titleController.clear();
    descriptionController.clear();
    notesController.clear();
    selectedCategory = '';
    selectedPriority = 'Low';
    selectedStatus = 'To Do';
    selectedDate = null;
    submitted = false;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    super.dispose();
  }
}