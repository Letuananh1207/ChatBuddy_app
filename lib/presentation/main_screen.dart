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
              FontAwesomeIcons.userGear,
              color: Colors.grey.shade700,
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
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            activeIcon: FaIcon(FontAwesomeIcons.houseChimney),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.book),
            activeIcon: FaIcon(FontAwesomeIcons.bookOpen),
            label: 'Bài học',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.shieldHalved),
            activeIcon: FaIcon(FontAwesomeIcons.shield),
            label: 'Đấu trường',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.comments),
            activeIcon: FaIcon(FontAwesomeIcons.comments),
            label: 'Cộng đồng',
          ),
        ],
      ),
    );
  }
}
