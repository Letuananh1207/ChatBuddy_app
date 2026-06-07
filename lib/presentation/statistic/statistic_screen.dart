// lib/screens/statistic_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/section_title.dart';
import './widgets/expandable_message_card.dart';
import './providers/review_providers.dart';

class StatisticScreen extends ConsumerStatefulWidget {
  const StatisticScreen({super.key});

  @override
  ConsumerState<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends ConsumerState<StatisticScreen> {
  String selectedTab = 'unreviewed';
  String? expandedCardId;

  @override
  Widget build(BuildContext context) {
    final reviewMessagesAsync = ref.watch(reviewMessagesProvider);
    final vietnamNow = DateTime.now().toUtc().add(const Duration(hours: 7));
    final yesterday = vietnamNow.subtract(const Duration(days: 1));
    final formattedDate =
        '${yesterday.day.toString().padLeft(2, '0')}/${yesterday.month.toString().padLeft(2, '0')}/${yesterday.year}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: 'REVIEW'),
                    const SizedBox(height: 4),
                    Text(
                      'Ngày $formattedDate',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
                reviewMessagesAsync.whenData((messages) {
                      final unreviewed =
                          messages.where((m) => !m.isReviewed).toList();
                      final reviewed =
                          messages.where((m) => m.isReviewed).toList();
                      return _buildTabFilter(
                          context, unreviewed.length, reviewed.length);
                    }).value ??
                    const SizedBox.shrink(),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // ignore: unused_result
                ref.refresh(reviewMessagesProvider);
              },
              child: reviewMessagesAsync.when(
                data: (messages) {
                  final unreviewed =
                      messages.where((m) => !m.isReviewed).toList();
                  final reviewed = messages.where((m) => m.isReviewed).toList();
                  final currentItems =
                      selectedTab == 'unreviewed' ? unreviewed : reviewed;
                  final emptyText = selectedTab == 'unreviewed'
                      ? 'Yeah! Bạn đã làm rất tốt rồi'
                      : 'Bạn chưa xem phản hồi nào. Hãy xem lại để cải thiện nhé!';

                  if (currentItems.isEmpty) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  emptyText,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Colors.grey[600], height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: currentItems.length,
                    itemBuilder: (context, index) {
                      final item = currentItems[index];
                      return ExpandableMessageCard(
                        stat: item,
                        isExpanded: item.id == expandedCardId,
                        onToggle: () => setState(() {
                          expandedCardId =
                              expandedCardId == item.id ? null : item.id;
                        }),
                        onReviewed: () => setState(() {}),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                  );
                },
                loading: () => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                error: (error, stackTrace) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Có lỗi khi tải dữ liệu: $error',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.red[600], height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabFilter(
      BuildContext context, int unreviewedCount, int reviewedCount) {
    return Container(
      height: 32,
      width: 170,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: selectedTab == 'unreviewed'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: 82,
              height: 28,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              _buildFilterButton(
                icon: Icons.visibility_off,
                tooltip: 'Chưa xem',
                count: unreviewedCount,
                isActive: selectedTab == 'unreviewed',
                onTap: () => setState(() => selectedTab = 'unreviewed'),
              ),
              _buildFilterButton(
                icon: Icons.visibility,
                tooltip: 'Đã xem',
                count: reviewedCount,
                isActive: selectedTab == 'reviewed',
                onTap: () => setState(() => selectedTab = 'reviewed'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required IconData icon,
    required String tooltip,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Tooltip(
          message: tooltip,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isActive ? AppColors.indigo : Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppColors.indigo : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
