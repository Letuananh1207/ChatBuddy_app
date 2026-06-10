import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'community/community_screen.dart';
import 'statistic/statistic_screen.dart';
import 'learning/learning_screen.dart';
import 'arena/arena_screen.dart';
import 'profile/profile_screen.dart';
import '../core/constants/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const _appTitle = 'ChatBuddy';

  final List<Widget> _screens = const [
    StatisticScreen(),
    LearningScreen(),
    ArenaScreen(),
    CommunityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset(
                'assets/logo_test.webp',
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) => const FaIcon(
                  FontAwesomeIcons.commentDots,
                  color: AppColors.indigo,
                  size: 32,
                ),
              ),
            ),
            const Text(
              _appTitle,
              style: TextStyle(
                color: AppColors.darkText,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Tài khoản',
            icon: FaIcon(
              FontAwesomeIcons.gear,
              color: Colors.grey.shade700,
              size: 18,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.indigo,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 13,
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4), // tăng khoảng cách
              child: FaIcon(FontAwesomeIcons.house, size: 20),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FaIcon(FontAwesomeIcons.houseChimney, size: 20),
            ),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FaIcon(FontAwesomeIcons.book, size: 20),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FaIcon(FontAwesomeIcons.bookOpen, size: 20),
            ),
            label: 'Bài học',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FaIcon(FontAwesomeIcons.shieldHalved, size: 20),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FaIcon(FontAwesomeIcons.shield, size: 20),
            ),
            label: 'Đấu trường',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FaIcon(FontAwesomeIcons.comments, size: 20),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FaIcon(FontAwesomeIcons.comments, size: 20),
            ),
            label: 'Cộng đồng',
          ),
        ],
      ),
    );
  }
}
