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
  String _selectedTimeFrame = 'Today';

  final List<String> _timeFrames = ['Today', 'Week', 'Month'];

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

  void _createTask() async {
    if (_titleController.text.isNotEmpty) {
      final task = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: _selectedDate,
        tag: _selectedTag,
      );

      await DatabaseHelper.instance.insertTask(task);

      // Clear the text fields after task creation
      setState(() {
        _titleController.clear();
        _descriptionController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
        backgroundColor: AppColors.brightYellow,
      ),
      body: Padding(
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
            DropdownButtonFormField<String>(
              value: _selectedTimeFrame,
              decoration: const InputDecoration(
                labelText: 'Time Frame',
                border: OutlineInputBorder(),
              ),
              items: _timeFrames.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedTimeFrame = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTag,
              decoration: const InputDecoration(
                labelText: 'Tag',
                border: OutlineInputBorder(),
              ),
              items: TaskTags.tagColors.keys.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedTag = newValue!;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _createTask,
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.darkBlue,
                backgroundColor: AppColors.brightYellow,
              ),
              child: Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
