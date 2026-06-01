import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/app_card.dart';
import '../../state/auth_notifier.dart';
import '../settings/widgets/language_setting_item.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _language = 'Tiếng Việt';
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất khỏi tài khoản?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Huỷ',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Đăng xuất',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await ref.read(authProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            _buildUserInfoCard(
              username: user?.username ?? 'Học viên JP',
              email: user?.email,
            ),
            const SizedBox(height: 12),

            // Settings integrated into profile
            AppCard(
              borderRadius: 18,
              child: Column(
                children: [
                  _buildSwitchItem(
                    Icons.notifications_none_rounded,
                    'Thông báo',
                    _notificationsEnabled,
                    (val) => setState(() => _notificationsEnabled = val),
                  ),
                  _buildDivider(),
                  _buildSwitchItem(
                    Icons.dark_mode_outlined,
                    'Chế độ tối',
                    _darkMode,
                    (val) => setState(() => _darkMode = val),
                  ),
                  _buildDivider(),
                  LanguageSettingItem(
                    currentLanguage: _language,
                    onTap: () => _showLanguagePicker(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _buildLogoutButton(context),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text(
          'Đăng xuất',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.grey.shade300),
          padding: const EdgeInsets.symmetric(vertical: AppSizes.p12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r16),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard({
    required String username,
    String? email,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                if (email != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.edit_note_rounded, color: Colors.grey.shade400, size: 20),
        ],
      ),
    );
  }

  Widget _buildDivider() =>
      Divider(height: 1, color: Colors.grey.shade50, indent: 14, endIndent: 14);

  Widget _buildSwitchItem(
      IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
          onChanged: onChanged,
          activeThumbColor: AppColors.indigo,
          activeTrackColor: AppColors.indigo.withOpacity(0.1),
        ),
      ),
    );
  }

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
    bool isSelected = _language == lang;
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
        setState(() => _language = lang);
        Navigator.pop(context);
      },
    );
  }
}
