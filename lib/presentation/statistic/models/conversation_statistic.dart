// lib/models/conversation_statistic.dart
class ConversationStatistic {
  final String id;
  final String userMessage;
  final String? correction;
  final List<String> improvements;
  bool isReviewed; // mới thêm

  ConversationStatistic({
    required this.id,
    required this.userMessage,
    this.correction,
    required this.improvements,
    this.isReviewed = false,
  });
}
