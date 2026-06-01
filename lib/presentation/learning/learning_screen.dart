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
    final currentLessons = lessons.where((l) => l['type'] == viewMode).toList();

    final today = DateTime.now();
    final formattedDate =
        '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';
    final formattedMonth =
        '${today.month.toString().padLeft(2, '0')}/${today.year}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header với Title và Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(title: 'LESSONS FOR YOU'),
                      const SizedBox(height: 4),
                      Text(
                        viewMode == 'day'
                            ? 'Ngày $formattedDate'
                            : 'Tháng $formattedMonth',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
                LearningFilter(
                  viewMode: viewMode,
                  onModeChanged: (mode) {
                    setState(() {
                      viewMode = mode;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: currentLessons.isEmpty
                ? Center(
                    child: Text(
                      'Không có bài học cho chế độ này.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  )
                : _buildLessonList(currentLessons),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonList(List<Map<String, dynamic>> lessons) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        return LessonCard(item: lessons[index]);
      },
    );
  }
}
