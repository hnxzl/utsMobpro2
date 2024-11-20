import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String tag1;
  final String tag2;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    Key? key,
    required this.title,
    required this.time,
    required this.tag1,
    required this.tag2,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  // Fungsi untuk menentukan warna berdasarkan tag
  Color _getTagColor(String tag) {
    switch (tag) {
      case 'College':
        return Colors.purple.withOpacity(0.2);
      case 'Work':
        return Colors.blue.withOpacity(0.2);
      case 'Study':
        return Colors.green.withOpacity(0.2);
      case 'Sport':
        return Colors.orange.withOpacity(0.2);
      case 'Today':
        return Colors.red.withOpacity(0.2);
      case 'Week':
        return Colors.yellow.withOpacity(0.2);
      case 'Month':
        return Colors.teal.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2); // Default color for unknown tags
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul tugas
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Waktu tugas
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Tag Section
                  Row(
                    children: [
                      // Tag 1
                      Chip(
                        label: Text(tag1),
                        backgroundColor: _getTagColor(tag1),
                      ),
                      const SizedBox(width: 8.0),
                      // Tag 2
                      Chip(
                        label: Text(tag2),
                        backgroundColor: _getTagColor(tag2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // PopupMenu untuk opsi edit dan delete
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
