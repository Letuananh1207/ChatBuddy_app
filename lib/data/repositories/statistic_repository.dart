import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/statistic/models/conversation_statistic.dart';
import '../services/api_service.dart';

final statisticRepositoryProvider = Provider<StatisticRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return StatisticRepository(apiService);
});

class StatisticRepository {
  final ApiService _apiService;

  StatisticRepository(this._apiService);

  Future<List<ConversationStatistic>> fetchReviewMessages(DateTime date) async {
    try {
      // Format date as YYYY-MM-DD
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final fullUrl = '${_apiService.baseUrl}/api/message-day/$dateStr/review';
      print('API Request URL: $fullUrl');

      final response = await _apiService.get(
        '/api/message-day/$dateStr/review',
      );

      print('API Response status: ${response.statusCode}');
      print('API Response data: ${response.data}');

      // Normalize possible response shapes:
      // - List of reviews directly
      // - { success: true, data: { ... , reviews: [...] } }
      // - { success: true, data: [ ... ] }
      final body = response.data;
      List<dynamic> listData = [];

      if (body is List) {
        listData = body;
      } else if (body is Map) {
        final dataField = body['data'];
        if (dataField is List) {
          listData = dataField;
        } else if (dataField is Map && dataField['reviews'] is List) {
          listData = List<dynamic>.from(dataField['reviews'] as List);
        } else if (body['reviews'] is List) {
          listData = List<dynamic>.from(body['reviews'] as List);
        }
      }

      if (response.statusCode == 200 && listData.isNotEmpty) {
        return listData
            .map((item) => _parseConversationStatistic(item))
            .toList();
      } else {
        print('No review items found after normalization.');
        return [];
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      return [];
    } catch (e) {
      print('Error fetching review messages: $e');
      return [];
    }
  }

  ConversationStatistic _parseConversationStatistic(dynamic data) {
    return ConversationStatistic(
      id: data['id']?.toString() ?? '',
      userMessage: data['userMessage'] as String? ?? '',
      correction: data['correction'] as String?,
      improvements: List<String>.from(data['improvements'] as List? ?? []),
      isReviewed: data['isReviewed'] as bool? ?? false,
    );
  }
}
