// lib/screens/statistic_screen.dart
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/section_title.dart';
import './models/conversation_statistic.dart';
import './widgets/expandable_message_card.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  late List<ConversationStatistic> messages;
  String selectedTab = 'unreviewed';
  String? expandedCardId;

  @override
  void initState() {
    super.initState();
    messages = _getFakeData();
  }

  List<ConversationStatistic> _getFakeData() {
    return [
      ConversationStatistic(
        id: '2',
        userMessage: 'きのうは映画を見ています',
        correction: 'きのうは映画を見ました',
        hasError: true,
        improvements: [
          'Bạn dùng "～ています" nhưng "きのう" là quá khứ xác định',
          'Dùng "～ました" để nói về hành động đã hoàn thành',
          '～ています = đang làm / ～ました = đã làm xong',
        ],
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
      ),
      ConversationStatistic(
        id: '4',
        userMessage: 'あなたは誰ですか',
        correction: 'あなたはだれですか',
        hasError: true,
        improvements: [
          '"誰" thường viết là "だれ" (hiragana)',
          'Cách viết chuẩn: あなたはだれですか',
          'Có thể bỏ "あなた" để tự nhiên hơn',
        ],
        timestamp: DateTime.now().subtract(Duration(days: 2)),
      ),
      ConversationStatistic(
        id: '6',
        userMessage: 'わたしが学校を行きました',
        correction: 'わたしは学校に行きました',
        hasError: true,
        improvements: [
          '助詞 sai: "が" và "を"',
          'Dùng "は" cho chủ ngữ, "に" cho nơi đến',
          'Mẫu: ～は + 場所 + に + 行きました',
        ],
        timestamp: DateTime.now().subtract(Duration(hours: 3)),
      ),
      ConversationStatistic(
        id: '7',
        userMessage: 'これは私の本です',
        correction: 'これはわたしの本です',
        hasError: true,
        improvements: [
          '"私" thường đọc là "わたし"',
          'Viết tự nhiên hơn: これはわたしの本です',
        ],
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final unreviewed = messages.where((m) => !m.isReviewed).toList();
    final reviewed = messages.where((m) => m.isReviewed).toList();
    final currentItems = selectedTab == 'unreviewed' ? unreviewed : reviewed;
    final emptyText = selectedTab == 'unreviewed'
        ? 'Không có mục chưa xem'
        : 'Không có mục đã xem';

    final today = DateTime.now();
    final formattedDate =
        '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                _buildTabFilter(context, unreviewed.length, reviewed.length),
              ],
            ),
          ),
          Expanded(
            child: currentItems.isEmpty
                ? Center(
                    child: Text(
                      emptyText,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: currentItems.length,
                    itemBuilder: (context, index) {
                      final item = currentItems[index];
                      return ExpandableMessageCard(
                        stat: item,
                        isExpanded: item.id == expandedCardId,
                        onToggle: () => setState(() {
                          expandedCardId = expandedCardId == item.id ? null : item.id;
                        }),
                        onReviewed: () => setState(() {}),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
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
                label: 'Chưa xem',
                count: unreviewedCount,
                isActive: selectedTab == 'unreviewed',
                onTap: () => setState(() => selectedTab = 'unreviewed'),
              ),
              _buildFilterButton(
                label: 'Đã xem',
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
    required String label,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            '$label ($count)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.indigo : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }
}
