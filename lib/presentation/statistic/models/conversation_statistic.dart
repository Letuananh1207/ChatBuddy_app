// lib/models/conversation_statistic.dart
class ConversationStatistic {
  final String id;
  final String userMessage;
  final String? correction;
  final bool hasError;
  final List<String> improvements;
  final DateTime timestamp;
  bool isReviewed; // mới thêm

  ConversationStatistic({
    required this.id,
    required this.userMessage,
    this.correction,
    required this.hasError,
    required this.improvements,
    required this.timestamp,
    this.isReviewed = false,
  });
}
