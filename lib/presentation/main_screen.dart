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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'ChatBuddy JP',
          style: TextStyle(
            color: AppColors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
                padding: EdgeInsets.all(6.0),
                child: Text('🐼', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),

      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: Container(
        // Loại bỏ padding dọc để giảm chiều cao tối đa
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            // Tắt hoàn toàn các hiệu ứng phản hồi mặc định để giao diện sạch hơn
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
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
            elevation: 0,

            // Bỏ hoàn toàn Label
            showSelectedLabels: false,
            showUnselectedLabels: false,

            // Kích thước icon tiêu chuẩn, gọn gàng
            iconSize: 24,

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.insert_chart_rounded),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_library_rounded),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_suggest_rounded),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
