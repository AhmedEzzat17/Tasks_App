class TaskModel {
  final int id;
  final String title;
  final String? description;
  final String category;
  final String priority;
  final String status;
  final DateTime? dueDate;
  final String? reminder;
  final String? notes;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.priority,
    required this.status,
    this.dueDate,
    this.reminder,
    this.notes,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      category: json['category'] ?? 'Other',
      priority: json['priority'] ?? 'Low',
      status: json['status'] ?? 'To Do',
      dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'])
          : null,
      reminder: json['reminder'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'due_date': dueDate?.toIso8601String().split('T')[0],
      'reminder': reminder,
      'notes': notes,
    };
  }
}
