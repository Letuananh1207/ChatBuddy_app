import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ArenaHistoryService {
  static const String _historyKey = 'arena_history';
  static const int _maxHistoryItems = 50;

  /// Lấy lịch sử đấu trường từ SharedPreferences
  static Future<List<Map<String, String>>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      return historyJson
          .map((json) => Map<String, String>.from(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Lỗi khi lấy lịch sử: $e');
      return [];
    }
  }

  /// Thêm mục mới vào lịch sử
  static Future<void> addToHistory(Map<String, String> item) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      // Thêm mục mới vào đầu danh sách
      historyJson.insert(0, jsonEncode(item));

      // Giữ chỉ _maxHistoryItems gần nhất
      if (historyJson.length > _maxHistoryItems) {
        historyJson.removeRange(_maxHistoryItems, historyJson.length);
      }

      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Lỗi khi lưu lịch sử: $e');
    }
  }

  /// Xóa toàn bộ lịch sử
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print('Lỗi khi xóa lịch sử: $e');
    }
  }

  /// Xóa một mục từ lịch sử
  static Future<void> removeFromHistory(String code) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_historyKey) ?? [];

      historyJson.removeWhere((json) {
        final item = Map<String, String>.from(jsonDecode(json));
        return item['code'] == code;
      });

      await prefs.setStringList(_historyKey, historyJson);
    } catch (e) {
      print('Lỗi khi xóa mục khỏi lịch sử: $e');
    }
  }
}
