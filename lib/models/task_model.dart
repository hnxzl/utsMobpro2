import 'package:flutter/material.dart';

class Task {
  int? id;
  String title;
  String description;
  DateTime deadline;
  String tag;
  bool isCompleted;
  TimeOfDay startTime;
  TimeOfDay endTime;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.tag,
    this.isCompleted = false,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'tag': tag,
      'isCompleted': isCompleted ? 1 : 0,
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
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
      startTime: _parseTimeOfDay(map['startTime']),
      endTime: _parseTimeOfDay(map['endTime']),
    );
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}
