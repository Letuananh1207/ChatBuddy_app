import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/section_title.dart';
import 'widgets/lesson_card.dart';
import 'widgets/learning_filter.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  String viewMode = "day";

  final List<Map<String, dynamic>> lessons = [
    {
      'title': 'の方か',
      'desc': 'So sánh hơn trong tiếng Nhật',
      'errors': 12,
      'type': 'day',
    },
    {
      'title': 'は vs が',
      'desc': 'Phân biệt trợ từ chủ ngữ',
      'errors': 8,
      'type': 'day',
    },
    {
      'title': 'Thì Te',
      'desc': 'Cách chia và sử dụng thể Te',
      'errors': 5,
      'type': 'month',
    },
    {
      'title': 'Bị động',
      'desc': 'Cấu trúc bị động N3',
      'errors': 3,
      'type': 'month',
    },
    {
      'title': 'Kính ngữ',
      'desc': 'Sử dụng Keigo',
      'errors': 15,
      'type': 'month',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredLessons = lessons
        .where((l) => l['type'] == viewMode)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header với Title và Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitle(title: 'HỌC TỪ LỖI SAI'),
                LearningFilter(
                  viewMode: viewMode,
                  onModeChanged: (mode) => setState(() => viewMode = mode),
                ),
              ],
            ),
          ),
          // List content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredLessons.length,
              itemBuilder: (context, index) {
                return LessonCard(item: filteredLessons[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
