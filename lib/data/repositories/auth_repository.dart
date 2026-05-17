import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthRepository(apiService, const FlutterSecureStorage());
});

class AuthSession {
  final String token;
  final UserModel? user;

  const AuthSession({required this.token, this.user});
}

class AuthRepository {
  static const _tokenKey = 'jwt_token';
  static const _userKey = 'auth_user';

  final ApiService _apiService;
  final FlutterSecureStorage _storage;

  AuthRepository(this._apiService, this._storage);

  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      return await _handleAuthResponse(response, successStatusCode: 201);
    } on DioException catch (e) {
      return AuthResponse(success: false, message: _connectionErrorMessage(e));
    } catch (_) {
      return const AuthResponse(
        success: false,
        message: 'Đã xảy ra lỗi không mong muốn',
      );
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      return await _handleAuthResponse(response, successStatusCode: 200);
    } on DioException catch (e) {
      return AuthResponse(success: false, message: _connectionErrorMessage(e));
    } catch (_) {
      return const AuthResponse(
        success: false,
        message: 'Đã xảy ra lỗi không mong muốn',
      );
    }
  }

  Future<AuthSession?> loadSession() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) return null;

    _apiService.setAuthToken(token);

    final userJson = await _storage.read(key: _userKey);
    UserModel? user;
    if (userJson != null) {
      try {
        user = UserModel.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>,
        );
      } catch (_) {
        user = null;
      }
    }

    return AuthSession(token: token, user: user);
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
    _apiService.setAuthToken(null);
  }

  Future<AuthResponse> _handleAuthResponse(
    Response response, {
    required int successStatusCode,
  }) async {
    final data = _parseResponseData(response.data);
    if (data == null) {
      return AuthResponse(
        success: false,
        message: _defaultErrorMessage(response.statusCode),
      );
    }

    try {
      final authResponse = AuthResponse.fromJson(data);

      if (response.statusCode == successStatusCode &&
          authResponse.success &&
          authResponse.token != null) {
        return await _saveSessionAndReturn(authResponse);
      }

      return AuthResponse(
        success: false,
        message:
            authResponse.message ?? _defaultErrorMessage(response.statusCode),
      );
    } catch (_) {
      return AuthResponse(
        success: false,
        message: _defaultErrorMessage(response.statusCode),
      );
    }
  }

  Map<String, dynamic>? _parseResponseData(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return null;
  }

  String _connectionErrorMessage(DioException e) {
    final base = _apiService.baseUrl;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Kết nối quá thời gian chờ.\nKiểm tra server tại $base';
      case DioExceptionType.connectionError:
        return 'Không kết nối được server.\n'
            '• Backend đang chạy? (npm start / node)\n'
            '• URL: $base\n'
            '• Máy thật: flutter run --dart-define=API_HOST=<IP-máy-tính>';
      default:
        return 'Không thể kết nối tới server ($base)';
    }
  }

  String _defaultErrorMessage(int? statusCode) {
    return switch (statusCode) {
      400 => 'Thiếu hoặc sai dữ liệu đầu vào',
      401 => 'Email hoặc mật khẩu không đúng',
      429 => 'Quá nhiều yêu cầu, vui lòng thử lại sau',
      _ => 'Yêu cầu thất bại',
    };
  }

  Future<AuthResponse> _saveSessionAndReturn(AuthResponse response) async {
    final token = response.token;
    if (token == null) return response;

    await _storage.write(key: _tokenKey, value: token);
    _apiService.setAuthToken(token);

    final user = response.user;
    if (user != null) {
      await _storage.write(
        key: _userKey,
        value: jsonEncode(user.toJson()),
      );
    }
    return response;
  }
}
