import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Cấu hình API theo [API_DOCUMENTATION.md].
///
/// Ghi đè khi chạy trên **máy thật** (không phải emulator):
/// ```bash
/// flutter run --dart-define=API_HOST=192.168.1.10
/// ```
class ApiConstants {
  static const String apiPrefix = '/api';
  static const int port = 3000;

  /// Tuỳ chọn: `flutter run --dart-define=API_HOST=192.168.1.10`
  static const String _hostOverride = String.fromEnvironment('API_HOST');

  static String get baseUrl {
    if (_hostOverride.isNotEmpty) {
      return _normalizeHost(_hostOverride);
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:$port';
    }

    if (Platform.isAndroid) {
      // Emulator: 10.0.2.2 = localhost của máy host
      return 'http://192.168.100.46:$port';
    }

    // Windows, macOS, Linux, iOS simulator
    return 'http://127.0.0.1:$port';
  }

  static String _normalizeHost(String host) {
    final trimmed = host.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return 'http://$trimmed:$port';
  }

  static const String register = '$apiPrefix/auth/register';
  static const String login = '$apiPrefix/auth/login';
  static const String health = '/health';
}
