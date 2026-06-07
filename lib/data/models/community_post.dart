class CommunityPost {
  final String id;
  final String authorId;
  final String authorUsername;
  final String? authorEmail;
  final String text;
  final List<String> images;
  final List<String> audio;
  final List<String> likes;
  final List<Map<String, dynamic>> comments;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorUsername,
    this.authorEmail,
    required this.text,
    required this.images,
    required this.audio,
    required this.likes,
    required this.comments,
    this.createdAt,
    this.updatedAt,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    String authorId = '';
    String authorUsername = 'Người dùng';
    String? authorEmail;

    if (author is Map<String, dynamic>) {
      authorId = author['_id'] as String? ?? '';
      authorUsername = author['username'] as String? ?? 'Người dùng';
      authorEmail = author['email'] as String?;
    } else if (author is String) {
      authorUsername = author;
    }

    return CommunityPost(
      id: json['_id'] as String? ?? '',
      authorId: authorId,
      authorUsername: authorUsername,
      authorEmail: authorEmail,
      text: json['text'] as String? ?? '',
      images: _parseStringList(json['images']),
      audio: _parseStringList(json['audio']),
      likes: _parseStringList(json['likes']),
      comments: _parseComments(json['comments']),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  String get authorInitial {
    return authorUsername.isNotEmpty ? authorUsername[0].toUpperCase() : 'U';
  }

  String get timeLabel {
    if (createdAt == null) return 'Vừa xong';

    final diff = DateTime.now().difference(createdAt!);
    if (diff.inSeconds < 60) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays == 1) return 'Hôm qua';
    return '${diff.inDays} ngày trước';
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List<dynamic>) {
      return value
          .where((item) => item != null)
          .map((item) => item.toString())
          .toList();
    }
    return const [];
  }

  static List<Map<String, dynamic>> _parseComments(dynamic value) {
    if (value is List<dynamic>) {
      return value
          .whereType<Map<String, dynamic>>()
          .map((comment) => Map<String, dynamic>.from(comment))
          .toList();
    }
    return const [];
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
