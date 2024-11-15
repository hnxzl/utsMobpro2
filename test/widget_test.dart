import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yodo/main.dart';
import 'package:yodo/screens/login_screen.dart';
import 'package:yodo/screens/home_screen.dart';
import 'package:yodo/models/task_model.dart';
import 'package:yodo/screens/task_creation_screen.dart';

void main() {
  group('TODODO App Widget Tests', () {
    // Test the main app widget
    testWidgets('App launches and shows login screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TodoDoApp());

      // Verify that the login screen is displayed
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    // Test login screen widgets
    testWidgets('Login screen has required elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Check for email and password fields
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Don\'t have an account? Sign Up'), findsOneWidget);
    });

    // Test task model
    test('Task model creation and conversion', () {
      final DateTime now = DateTime.now();
      final task = Task(
        title: 'Test Task',
        description: 'Test Description',
        deadline: now,
        tag: 'Work',
      );

      // Test task creation
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.deadline, now);
      expect(task.tag, 'Work');
      expect(task.isCompleted, false);

      // Test task to map conversion
      final Map<String, dynamic> taskMap = task.toMap();
      expect(taskMap['title'], 'Test Task');
      expect(taskMap['tag'], 'Work');
    });

    // Test home screen
    testWidgets('Home screen displays username', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HomeScreen(username: 'TestUser'),
      ));

      // Verify username is displayed
      expect(find.text('Hey, TestUser!'), findsOneWidget);
    });

    // Test navigation between screens
    testWidgets('Can navigate between login and signup',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Find and tap signup link
      await tester.tap(find.text('Don\'t have an account? Sign Up'));
      await tester.pumpAndSettle();

      // Verify signup screen is shown
      expect(find.text('Sign Up'), findsOneWidget);
    });

    // Test task creation validation
    testWidgets('Task creation requires title', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TaskCreationScreen()));

      // Try to create task without title
      await tester.tap(find.text('Create Task'));
      await tester.pumpAndSettle();

      // Verify validation prevents task creation
      expect(find.text('Please enter a task title'), findsOneWidget);
    });
  });
}
