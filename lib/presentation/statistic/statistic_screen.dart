// lib/screens/statistic_screen.dart
import 'package:flutter/material.dart';
import './models/conversation_statistic.dart';
import './widgets/expandable_message_card.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  late List<ConversationStatistic> messages;

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

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          if (unreviewed.isNotEmpty) ...[
            Text('Chưa xem', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...unreviewed.map((msg) => ExpandableMessageCard(
                  stat: msg,
                  onReviewed: () => setState(() {}),
                )),
            const SizedBox(height: 16),
          ],
          if (reviewed.isNotEmpty) ...[
            Text('Đã xem', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...reviewed.map((msg) => ExpandableMessageCard(
                  stat: msg,
                  onReviewed: () => setState(() {}),
                )),
          ],
        ],
      ),
    );
  }
}
