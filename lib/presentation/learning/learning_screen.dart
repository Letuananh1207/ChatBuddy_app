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

  Future<void> _refreshRecommendedLessons(String requestDateKey) async {
    try {
      await ref.refresh(recommendedLessonsProvider(requestDateKey).future);
    } catch (_) {
      // Ignore refresh errors; UI will show current error state.
    }
  }

  @override
  Widget build(BuildContext context) {
    final vietnamNow = DateTime.now().toUtc().add(const Duration(hours: 7));
    final formattedDate =
        '${vietnamNow.day.toString().padLeft(2, '0')}/${vietnamNow.month.toString().padLeft(2, '0')}/${vietnamNow.year}';
    final formattedMonth =
        '${vietnamNow.month.toString().padLeft(2, '0')}/${vietnamNow.year}';
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
                      data: (links) {
                        if (links.isEmpty) {
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

                        final linkItems = links
                            .asMap()
                            .entries
                            .map(
                              (entry) => {
                                'title': 'Bài học ${entry.key + 1}',
                                'desc': entry.value,
                              },
                            )
                            .toList();
                        return _buildLessonList(linkItems);
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
