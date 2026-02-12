class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  bool isCompleted;
  int? categoryId;
  bool isFavorite;
  bool isSynced;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.categoryId,
    this.isFavorite = false,
    this.isSynced = false,
  });
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: (map['isCompleted'] ?? 0) == 1,
      categoryId: map['categoryId'],
      isFavorite: (map['isFavorite'] ?? 0) == 1,
      isSynced: (map['isSynced'] ?? 0) == 1,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'categoryId': categoryId,
      'isFavorite': isFavorite ? 1 : 0,
      'isSynced': isSynced ? 1 : 0,
    };
  }
}
