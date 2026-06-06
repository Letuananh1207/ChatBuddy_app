import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/recommended_lesson.dart';
import '../../../data/repositories/statistic_repository.dart';

final recommendedLessonsProvider =
    FutureProvider.family<List<RecommendedLesson>, String>(
        (ref, dateKey) async {
  final repository = ref.watch(statisticRepositoryProvider);
  return repository.fetchRecommendedLessons(DateTime.parse(dateKey));
});
