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

  void _createTask() async {
    if (_titleController.text.isNotEmpty) {
      // Membuat objek task
      final task = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: _selectedDate,
        tag: _selectedTag,
        isCompleted: false,
      );

      // Simpan ke database
      await DatabaseHelper.instance.insertTask(task);

      // Reset form dan tutup keyboard
      FocusScope.of(context).unfocus();
      setState(() {
        _titleController.clear();
        _descriptionController.clear();
        _selectedDate = DateTime.now();
        _selectedTag = 'College';
      });

      // Notifikasi sukses
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
            // Input Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Input Description
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
                        backgroundColor: entry.value, // Warna tag
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

            // Tombol untuk membuat task
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
