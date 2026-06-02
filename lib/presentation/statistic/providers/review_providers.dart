import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/statistic_repository.dart';
import '../models/conversation_statistic.dart';

final reviewMessagesProvider =
    FutureProvider<List<ConversationStatistic>>((ref) async {
  final repository = ref.watch(statisticRepositoryProvider);

  // Use today's date in Vietnam timezone (UTC+7) to align with app records.
  final reviewDate = DateTime.now().toUtc().add(const Duration(hours: 7));

  return repository.fetchReviewMessages(reviewDate);
});
