import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../models/task_model.dart';
import '../services/database_helper.dart';
import '../utils/constants.dart';
import 'task_creation_screen.dart';
import 'settings_screen.dart';

class BottomNavBar extends StatefulWidget {
  final String username;

  const BottomNavBar({super.key, required this.username});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(username: widget.username),
      const TaskCreationScreen(),
      SettingsScreen(username: widget.username),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.home,
          size: 22,
        ),
        title: 'Home',
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add, size: 22),
        title: 'Add Task',
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings, size: 22),
        title: 'Settings',
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        padding: const EdgeInsets.all(8),
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true,
        backgroundColor: AppColors.darkBlue,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: AppColors.darkBlue,
        ),
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  String _currentFilter = 'Today';
  final String _currentTag = 'All';

  Future<void> _loadTasks() async {
    final tasks = await DatabaseHelper.instance.getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  List<Task> _filterTasks() {
    return _tasks.where((task) {
      // Time filter logic
      bool timeCondition = _currentFilter == 'Today'
          ? task.deadline.day == DateTime.now().day
          : _currentFilter == 'Week'
              ? task.deadline.difference(DateTime.now()).inDays <= 7
              : _currentFilter == 'Month'
                  ? task.deadline.difference(DateTime.now()).inDays <= 30
                  : true;

      // Tag filter logic
      bool tagCondition = _currentTag == 'All' || task.tag == _currentTag;

      return timeCondition && tagCondition;
    }).toList();
  }

  void _toggleTaskCompletion(Task task) async {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });

    if (task.isCompleted) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _tasks.remove(task);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filterTasks();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadTasks,
          child: Column(
            children: [
              // Header Section
              Container(
                color: AppColors.darkBlue,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.brightYellow,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    Text(
                      'TODODO',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        // Search functionality
                      },
                    ),
                  ],
                ),
              ),

              // Greeting and Task Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Hey, ${widget.username}!',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: Text(
                        filteredTasks.length.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              // Time Frame Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Today', 'Week', 'Month'].map((filter) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChoiceChip(
                        selectedColor: AppColors.darkBlue,
                        label: Text(filter),
                        selected: _currentFilter == filter,
                        onSelected: (selected) {
                          setState(() {
                            _currentFilter = filter;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Task List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(task.description),
                      trailing: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggleTaskCompletion(task),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
