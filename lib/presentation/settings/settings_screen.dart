import 'package:flutter/material.dart';

// Core imports
import '../../core/constants/colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/section_title.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'CÀI ĐẶT'),
            const SizedBox(height: 12),

            // Group các cài đặt vào AppCard
            AppCard(
              borderRadius: 24,
              child: Column(
                children: [
                  _buildSettingItem('Thông báo', true),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade50,
                    indent: 20,
                    endIndent: 20,
                  ),
                  _buildSettingItem('Chế độ tối', false),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade50,
                    indent: 20,
                    endIndent: 20,
                  ),
                  _buildSettingItem('Ngôn ngữ', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, bool value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
          fontSize: 16,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: (val) {
          // TODO: Tích hợp Isar hoặc SharedPreferences của bạn ở đây
          debugPrint('Setting $title changed to $val');
        },
        activeThumbColor: AppColors.indigo,
        activeTrackColor: const Color(0xFFEEF2FF),
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey.shade200,
      ),
    );
  }
}
