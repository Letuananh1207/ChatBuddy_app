import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class LanguageSettingItem extends StatelessWidget {
  final String currentLanguage;
  final VoidCallback onTap;

  const LanguageSettingItem({
    super.key,
    required this.currentLanguage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      onTap: onTap,
      leading: Icon(
        Icons.language_rounded,
        size: 20,
        color: AppColors.darkText.withOpacity(0.7),
      ),
      title: const Text(
        'Ngôn ngữ',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
          fontSize: 14,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currentLanguage.toUpperCase(),
            style: TextStyle(
              color: AppColors.indigo.withOpacity(0.8),
              fontSize: 11, // Nhỏ hơn một chút để tinh tế
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
