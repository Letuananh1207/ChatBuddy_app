import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/statistic_repository.dart';

final recommendedLessonsProvider =
    FutureProvider.family<List<String>, String>((ref, dateKey) async {
  final repository = ref.watch(statisticRepositoryProvider);
  return repository.fetchRecommendedLessons(DateTime.parse(dateKey));
});
