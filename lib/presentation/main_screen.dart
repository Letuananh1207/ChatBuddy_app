import 'package:flutter/material.dart';

// Import các màn hình thực tế
import 'statistic/statistic_screen.dart';
import 'learning/learning_screen.dart';
import 'settings/settings_screen.dart';
import 'profile/profile_screen.dart';

// Core
import '../core/constants/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const StatisticScreen(),
    LearningScreen(),
    const SettingsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header chung cho toàn ứng dụng
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'ChatBuddy JP',
          style: TextStyle(
            color: AppColors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('🐼', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),

      // Giữ trạng thái tab bằng IndexedStack
      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            // overlayColor kiểm soát hiệu ứng nhấp nháy khi tap
            navigationBarTheme: const NavigationBarThemeData(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.background,
            selectedItemColor: AppColors.indigo,
            unselectedItemColor: Colors.grey.shade400,
            enableFeedback: false, // tắt rung/âm thanh khi click
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.bar_chart_rounded),
                ),
                label: 'SỐ LIỆU',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.menu_book_rounded),
                ),
                label: 'HỌC TẬP',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.settings_outlined),
                ),
                label: 'CÀI ĐẶT',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person_outline_rounded),
                ),
                label: 'TÔI',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
