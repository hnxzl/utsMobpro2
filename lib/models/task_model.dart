class Task {
  int? id;
  String title;
  String description;
  DateTime deadline;
  String tag;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.tag,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'tag': tag,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      deadline: DateTime.parse(map['deadline']),
      tag: map['tag'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
