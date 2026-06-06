class RecommendedLesson {
  final String title;
  final String description;
  final String? url;
  final String? embedUrl;
  final String? videoId;
  final String? thumbnailUrl;
  final String? channelTitle;
  final DateTime? publishedAt;

  RecommendedLesson({
    required this.title,
    required this.description,
    this.url,
    this.embedUrl,
    this.videoId,
    this.thumbnailUrl,
    this.channelTitle,
    this.publishedAt,
  });

  factory RecommendedLesson.fromJson(dynamic json) {
    if (json is String) {
      return RecommendedLesson(
        title: 'Bài học',
        description: json,
      );
    }

    if (json is Map<String, dynamic>) {
      return RecommendedLesson(
        title: json['title'] as String? ?? 'Bài học mới',
        description:
            json['description'] as String? ?? json['url'] as String? ?? '',
        url: json['url'] as String?,
        embedUrl: json['embedUrl'] as String?,
        videoId: json['videoId'] as String?,
        thumbnailUrl: json['thumbnailUrl'] as String?,
        channelTitle: json['channelTitle'] as String?,
        publishedAt: json['publishedAt'] != null
            ? DateTime.tryParse(json['publishedAt'] as String)
            : null,
      );
    }

    return RecommendedLesson(
      title: 'Bài học mới',
      description: json.toString(),
    );
  }

  String? get effectiveEmbedUrl {
    if (embedUrl != null && embedUrl!.isNotEmpty) {
      return embedUrl;
    }
    if (effectiveVideoId != null) {
      return 'https://www.youtube.com/embed/${effectiveVideoId!}';
    }
    if (url != null && url!.contains('watch?v=')) {
      return url!.replaceFirst('watch?v=', 'embed/');
    }
    return url;
  }

  String? get effectiveVideoId {
    if (videoId != null && videoId!.isNotEmpty) {
      return videoId;
    }

    if (url != null && url!.isNotEmpty) {
      final extracted = _extractVideoIdFromUrl(url!);
      if (extracted != null && extracted.isNotEmpty) {
        return extracted;
      }
    }

    if (embedUrl != null && embedUrl!.isNotEmpty) {
      final extracted = _extractVideoIdFromUrl(embedUrl!);
      if (extracted != null && extracted.isNotEmpty) {
        return extracted;
      }
    }

    return null;
  }

  static String? _extractVideoIdFromUrl(String url) {
    final patterns = [
      RegExp(r'youtube\.com\/watch\?v=([^&]+)'),
      RegExp(r'youtu\.be\/([^?&]+)'),
      RegExp(r'youtube\.com\/embed\/([^?&]+)'),
      RegExp(r'youtube\.com\/v\/([^?&]+)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }

    return null;
  }
}
