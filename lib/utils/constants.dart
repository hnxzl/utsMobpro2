import 'package:flutter/material.dart';

class AppColors {
  static const darkBlue = Color(0xFF0d3b66);
  static const brightYellow = Color(0xFFf4d35e);
  static const beige = Color(0xFFfaf0ca);
}

class AppStyles {
  static final TextStyle headerStyle = const TextStyle(
    color: AppColors.darkBlue,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
}

class TaskTags {
  static const Map<String, Color> tagColors = {
    'College': Color.fromARGB(255, 0, 132, 255),
    'Work': Color.fromARGB(255, 244, 94, 94),
    'Study': Color.fromARGB(255, 255, 247, 0),
    'Sport': Colors.green,
  };
}
