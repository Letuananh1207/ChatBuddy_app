import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_constants.dart';
import '../models/arena_models.dart';
import '../services/api_service.dart';

final arenaRepositoryProvider = Provider<ArenaRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ArenaRepository(apiService);
});

class ArenaRepository {
  final ApiService _apiService;

  ArenaRepository(this._apiService);

  Future<ArenaRoom?> createRoom() async {
    try {
      final response = await _apiService.post(ApiConstants.arenaRooms);
      return _parseRoom(response, successStatusCodes: const [200, 201]);
    } on DioException {
      return null;
    }
  }

  Future<ArenaRoom?> joinRoom(String code) async {
    try {
      final response = await _apiService.post(
        '${ApiConstants.arenaRooms}/$code/join',
      );
      return _parseRoom(response, successStatusCodes: const [200, 201]);
    } on DioException {
      return null;
    }
  }

  Future<ArenaRoom?> getRoom(String code) async {
    try {
      final response =
          await _apiService.get('${ApiConstants.arenaRooms}/$code');
      return _parseRoom(response, successStatusCodes: const [200]);
    } on DioException {
      return null;
    }
  }

  Future<ArenaRoom?> setReady(String code, bool ready) async {
    try {
      final response = await _apiService.post(
        '${ApiConstants.arenaRooms}/$code/ready',
        data: {'ready': ready},
      );
      return _parseRoom(response, successStatusCodes: const [200]);
    } on DioException {
      return null;
    }
  }

  Future<ArenaRoom?> sendAnswer(
    String code, {
    int? questionIndex,
    String? answer,
    int? duration,
    int? score,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (score != null) {
        data['score'] = score;
        data['duration'] = duration ?? 0;
      } else if (questionIndex != null && answer != null) {
        data['questionIndex'] = questionIndex;
        data['answer'] = answer;
        data['duration'] = duration ?? 0;
      }

      final response = await _apiService.post(
        '${ApiConstants.arenaRooms}/$code/answer',
        data: data,
      );
      return _parseRoom(response, successStatusCodes: const [200]);
    } on DioException {
      return null;
    }
  }

  Future<List<ArenaParticipant>> getRanking(String code) async {
    try {
      final response =
          await _apiService.get('${ApiConstants.arenaRooms}/$code/ranking');
      if (response.statusCode != 200) return [];
      final raw = _parseResponseData(response.data);
      if (raw is List) {
        return raw
            .whereType<Map<String, dynamic>>()
            .map(ArenaParticipant.fromJson)
            .toList();
      }
      return [];
    } on DioException {
      return [];
    }
  }

  Future<bool> leaveRoom(String code) async {
    try {
      final response =
          await _apiService.post('${ApiConstants.arenaRooms}/$code/leave');
      return response.statusCode == 200;
    } on DioException {
      return false;
    }
  }

  ArenaRoom? _parseRoom(
    Response response, {
    required List<int> successStatusCodes,
  }) {
    if (!successStatusCodes.contains(response.statusCode)) {
      return null;
    }

    final data = _parseResponseData(response.data);
    if (data is Map<String, dynamic>) {
      return ArenaRoom.fromJson(data);
    }
    return null;
  }

  dynamic _parseResponseData(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is List) return data;
    if (data is String && data.isNotEmpty) {
      try {
        return jsonDecode(data);
      } catch (_) {
        return null;
      }
    }
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }
}
