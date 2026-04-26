import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/section_title.dart';
import 'widgets/language_setting_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String language = "Tiếng Việt";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'CÀI ĐẶT'),
            const SizedBox(height: 12),
            AppCard(
              borderRadius: 20,
              child: Column(
                children: [
                  _buildSwitchItem(
                    Icons.notifications_none_rounded,
                    'Thông báo',
                    true,
                  ),
                  _buildDivider(),
                  _buildSwitchItem(
                    Icons.dark_mode_outlined,
                    'Chế độ tối',
                    false,
                  ),
                  _buildDivider(),
                  // Widget ngôn ngữ riêng biệt
                  LanguageSettingItem(
                    currentLanguage: language,
                    onTap: () => _showLanguagePicker(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() =>
      Divider(height: 1, color: Colors.grey.shade50, indent: 16, endIndent: 16);

  // Chỉ giữ lại hàm build cho Switch để đơn giản hóa
  Widget _buildSwitchItem(IconData icon, String title, bool value) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, size: 20, color: AppColors.darkText.withOpacity(0.7)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
          fontSize: 14,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.8,
        child: Switch(
          value: value,
          onChanged: (val) {},
          activeColor: AppColors.indigo,
          activeTrackColor: AppColors.indigo.withOpacity(0.1),
        ),
      ),
    );
  }

  // Hàm hiển thị lựa chọn ngôn ngữ
  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption("Tiếng Việt"),
              _buildLanguageOption("English"),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String lang) {
    bool isSelected = language == lang;
    return ListTile(
      title: Text(
        lang,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.indigo : AppColors.darkText,
        ),
      ),
      onTap: () {
        setState(() => language = lang);
        Navigator.pop(context);
      },
    );
  }
}
