import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_helper.dart';
import '../utils/constants.dart';

class TaskCreationScreen extends StatefulWidget {
  const TaskCreationScreen({super.key});

  @override
  _TaskCreationScreenState createState() => _TaskCreationScreenState();
}

class _TaskCreationScreenState extends State<TaskCreationScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedTag = 'College';
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0); // Default start time
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0); // Default end time
  final List<String> timeFrames = ['Today', 'Week', 'Month'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  void _createTask() async {
    if (_titleController.text.isNotEmpty) {
      final task = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: _selectedDate,
        tag: _selectedTag,
        isCompleted: false,
        startTime: _startTime,
        endTime: _endTime,
      );

      // Save task to database
      await DatabaseHelper.instance.insertTask(task);

      // Reset form and dismiss keyboard
      FocusScope.of(context).unfocus();
      setState(() {
        _titleController.clear();
        _descriptionController.clear();
        _selectedDate = DateTime.now();
        _selectedTag = 'College';
        _startTime = TimeOfDay(hour: 9, minute: 0);
        _endTime = TimeOfDay(hour: 17, minute: 0);
      });

      // Show success notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title for the task.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
        backgroundColor: AppColors.brightYellow,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Select Deadline
            Row(
              children: [
                const Text('Deadline: '),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    '${_selectedDate.toLocal()}'.split(' ')[0],
                    style: const TextStyle(color: AppColors.darkBlue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Select Start Time
            Row(
              children: [
                const Text('Start Time: '),
                TextButton(
                  onPressed: () => _selectStartTime(context),
                  child: Text(
                    _startTime.format(context),
                    style: const TextStyle(color: AppColors.darkBlue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Select End Time
            Row(
              children: [
                const Text('End Time: '),
                TextButton(
                  onPressed: () => _selectEndTime(context),
                  child: Text(
                    _endTime.format(context),
                    style: const TextStyle(color: AppColors.darkBlue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tag Dropdown
            DropdownButtonFormField<String>(
              value: _selectedTag,
              decoration: const InputDecoration(
                labelText: 'Tag',
                border: OutlineInputBorder(),
              ),
              items: TaskTags.tagColors.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: entry.value,
                      ),
                      const SizedBox(width: 8),
                      Text(entry.key),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedTag = newValue!;
                });
              },
            ),
            const SizedBox(height: 30),

            // Create Task Button
            ElevatedButton(
              onPressed: _createTask,
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.darkBlue,
                backgroundColor: AppColors.brightYellow,
              ),
              child: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
