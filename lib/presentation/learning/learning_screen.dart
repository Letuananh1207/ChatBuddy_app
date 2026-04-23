import 'package:flutter/material.dart';

// Core imports
import '../../core/constants/colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/section_title.dart';

class LearningScreen extends StatelessWidget {
  final List<Map<String, dynamic>> lessons = [
    {'title': 'の方か', 'desc': 'So sánh hơn trong tiếng Nhật', 'errors': 12},
    {'title': 'は vs が', 'desc': 'Phân biệt trợ từ chủ ngữ', 'errors': 8},
    {'title': 'Thì Te', 'desc': 'Cách chia và sử dụng thể Te', 'errors': 5},
    {'title': 'Bị động', 'desc': 'Cấu trúc bị động N3', 'errors': 3},
  ];

  LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          const SectionTitle(title: 'HỌC TỪ LỖI SAI'),
          const SizedBox(height: 20),
          ...lessons.map((item) => _buildLessonCard(item)),
        ],
      ),
    );
  }

  Widget _buildLessonCard(Map<String, dynamic> item) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      borderRadius: 28,
      child: Row(
        children: [
          // Thumbnail Video
          Container(
            width: 100,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.play_circle_fill_rounded,
              color: AppColors.indigo,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          // Nội dung bài học
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label số lỗi
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${item['errors']} LỖI SAI',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                Text(
                  item['desc'],
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
