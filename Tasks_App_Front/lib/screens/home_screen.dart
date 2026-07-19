import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import 'create_task_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';
import 'tasks_screen.dart';
import 'today_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(onViewAllTasks: () => setState(() => _currentIndex = 1)),
      const TasksScreen(),
      const TodayTasksScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateTaskScreen()));
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.today_rounded), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}