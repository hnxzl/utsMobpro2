import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const TodoDoApp());
}

class TodoDoApp extends StatelessWidget {
  const TodoDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODODO',
      theme: ThemeData(
        primaryColor: AppColors.darkBlue,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: AppColors.brightYellow)
            .copyWith(surface: AppColors.beige),
      ),
      home: const LoginScreen(),
    );
  }
}
