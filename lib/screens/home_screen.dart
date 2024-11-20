import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:yodo/widgets/task_card.dart';
import '../models/task_model.dart';
import '../services/database_helper.dart';
import '../utils/constants.dart';
import 'task_creation_screen.dart';
import 'settings_screen.dart';

class BottomNavBar extends StatefulWidget {
  final String username;

  const BottomNavBar({super.key, required this.username});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
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
      HomeScreen(username: widget.username, onRefresh: _onHomeRefresh),
      const TaskCreationScreen(),
      SettingsScreen(username: widget.username),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        activeColorPrimary: AppColors.brightYellow,
        inactiveColorPrimary: Colors.grey,
        textStyle: const TextStyle(fontSize: 12), // Atur ukuran teks
        iconSize: 24, // Ukuran ikon
        onPressed: (context) => _onHomeRefresh(),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.add),
        activeColorPrimary: AppColors.brightYellow,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        activeColorPrimary: AppColors.brightYellow,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  void _onHomeRefresh() {
    if (_controller.index == 0) {
      HomeScreen.of(context)?.refreshTasks();
    } else {
      setState(() {
        _controller.jumpToTab(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: AppColors.darkBlue,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: AppColors.darkBlue,
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String username;
  final VoidCallback? onRefresh;

  const HomeScreen({super.key, required this.username, this.onRefresh});

  static _HomeScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomeScreenState>();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  List<Task> _searchResults = [];
  String _currentFilter = 'Today';
  String _currentTag = 'All';
  bool _isSearching = false;

  final List<String> _tags = ['All', 'Study', 'Work', 'College', 'Sport'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await DatabaseHelper.instance.getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void refreshTasks() async {
    final tasks = await DatabaseHelper.instance.getAllTasks();
    setState(() {
      _tasks = tasks;
      _searchResults = [];
      _isSearching = false;
    });
  }

  List<Task> _filterTasks() {
    final tasks = _isSearching ? _searchResults : _tasks;

    return tasks
        .where((task) {
          final now = DateTime.now();
          bool timeCondition = _currentFilter == 'Today'
              ? task.deadline.day == now.day && task.deadline.month == now.month
              : _currentFilter == 'Week'
                  ? task.deadline
                          .isAfter(now.subtract(Duration(days: now.weekday))) &&
                      task.deadline
                          .isBefore(now.add(Duration(days: 7 - now.weekday)))
                  : _currentFilter == 'Month'
                      ? task.deadline.month == now.month
                      : true;

          bool tagCondition = _currentTag == 'All' || task.tag == _currentTag;

          return timeCondition && tagCondition;
        })
        .toSet()
        .toList();
  }

  void _onSearch(String query) {
    setState(() {
      _searchResults = _tasks.where((task) {
        return task.title.toLowerCase().contains(query.toLowerCase()) ||
            task.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filterTasks();

    return SafeArea(
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
                const Text(
                  'TODODO',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) {
                        _searchController.clear();
                        _onSearch('');
                      }
                    });
                  },
                ),
              ],
            ),
          ),

          // Search Bar
          if (_isSearching)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search tasks...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _onSearch,
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
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Filters
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  labelColor: AppColors.darkBlue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.brightYellow,
                  tabs: [
                    Tab(text: 'Time Filter'),
                    Tab(text: 'Tag Filter'),
                  ],
                ),
                Container(
                  height: 50,
                  child: TabBarView(
                    children: [
                      Center(
                        child: Wrap(
                          spacing: 10,
                          children: ['Today', 'Week', 'Month']
                              .map((filter) => ChoiceChip(
                                    selectedColor: AppColors.darkBlue,
                                    label: Text(filter),
                                    selected: _currentFilter == filter,
                                    onSelected: (selected) {
                                      setState(() {
                                        _currentFilter = filter;
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                      Center(
                        child: Wrap(
                          spacing: 10,
                          children: _tags
                              .map((tag) => ChoiceChip(
                                    selectedColor: AppColors.brightYellow,
                                    label: Text(tag),
                                    selected: _currentTag == tag,
                                    onSelected: (selected) {
                                      setState(() {
                                        _currentTag = tag;
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks available!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return TaskCard(
                        title: task.title,
                        time:
                            '${task.startTime.format(context)} - ${task.endTime.format(context)}',
                        tag1: task.tag, // Tag pertama
                        tag2: 'Home', // Tambahkan tag lain jika ada
                        onEdit: () {
                          // Aksi untuk edit task
                        },
                        onDelete: () {
                          // Tampilkan dialog konfirmasi
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Task'),
                              content: const Text(
                                  'Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      // Logika hapus task
                                      filteredTasks.removeAt(index);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
