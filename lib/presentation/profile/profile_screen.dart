import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            _buildUserInfoCard(),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard(
                  '7 ngày',
                  'STREAK',
                  Icons.local_fire_department_rounded,
                  Colors.orange,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  '12.5 giờ',
                  'ĐÃ XEM',
                  Icons.play_circle_fill_rounded,
                  AppColors.indigo,
                ),
              ],
            ),
            // Bạn có thể thêm các mục như "Thành tựu" hoặc "Lịch sử" tại đây
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20, // Đồng bộ với Learning & Settings
      child: Row(
        children: [
          // Avatar với kích thước gọn hơn
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: AppColors.indigo.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('🐼', style: TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Học viên JP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 6),
                // Tag Level Mini
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.indigo.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'N3 LEVEL',
                    style: TextStyle(
                      color: AppColors.indigo,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.edit_note_rounded, color: Colors.grey.shade400, size: 22),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        borderRadius: 16,
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.darkText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
