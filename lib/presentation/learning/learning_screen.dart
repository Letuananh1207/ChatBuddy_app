import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../core/widgets/section_title.dart';
import 'providers/recommended_lessons_provider.dart';
import 'widgets/lesson_card.dart';
import 'widgets/learning_filter.dart';

class LearningScreen extends ConsumerStatefulWidget {
  const LearningScreen({super.key});

  @override
  ConsumerState<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends ConsumerState<LearningScreen> {
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
  ];

  Future<void> _refreshRecommendedLessons(String requestDateKey) async {
    try {
      final _ = ref.refresh(recommendedLessonsProvider(requestDateKey));
      return;
    } catch (_) {
      // Ignore refresh errors; UI will show current error state.
    }
  }

  @override
  Widget build(BuildContext context) {
    final vietnamNow = DateTime.now().toUtc().add(const Duration(hours: 7));
    final yesterday = vietnamNow.subtract(const Duration(days: 1));
    final previousMonth = DateTime(vietnamNow.year, vietnamNow.month - 1);

    final formattedDate =
        '${yesterday.day.toString().padLeft(2, '0')}/${yesterday.month.toString().padLeft(2, '0')}/${yesterday.year}';
    final formattedMonth =
        '${previousMonth.month.toString().padLeft(2, '0')}/${previousMonth.year}';
    final requestDateKey =
        '${vietnamNow.year}-${vietnamNow.month.toString().padLeft(2, '0')}-${vietnamNow.day.toString().padLeft(2, '0')}';

    final recommendedLessonsAsync =
        ref.watch(recommendedLessonsProvider(requestDateKey));
    final monthLessons = lessons.where((l) => l['type'] == viewMode).toList();

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
            child: viewMode == 'day'
                ? RefreshIndicator(
                    onRefresh: () => _refreshRecommendedLessons(requestDateKey),
                    child: recommendedLessonsAsync.when(
                      data: (lessonsData) {
                        if (lessonsData.isEmpty) {
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            children: [
                              Center(
                                child: Text(
                                  'Không có bài học đề xuất cho ngày này.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          );
                        }

                        return _buildLessonList(lessonsData);
                      },
                      loading: () => ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 24),
                          Center(child: CircularProgressIndicator()),
                        ],
                      ),
                      error: (error, stack) => ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        children: [
                          Center(
                            child: Text(
                              'Không tải được bài học đề xuất. Hãy thử lại sau.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : monthLessons.isEmpty
                    ? Center(
                        child: Text(
                          'Không có bài học cho chế độ này.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      )
                    : _buildLessonList(monthLessons),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonList(List<dynamic> lessons) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        return LessonCard(item: lessons[index]);
      },
    );
  }
}
