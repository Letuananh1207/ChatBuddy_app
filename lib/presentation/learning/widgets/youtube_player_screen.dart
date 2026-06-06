import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../core/widgets/app_card.dart';
import '../../../data/models/recommended_lesson.dart';

class YoutubePlayerScreen extends StatefulWidget {
  final RecommendedLesson lesson;

  const YoutubePlayerScreen({super.key, required this.lesson});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final videoId = widget.lesson.effectiveVideoId;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
        privacyEnhancedMode: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black,
        );
    final descriptionStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey.shade700,
          height: 1.6,
        );
    final appBarTitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lesson.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: appBarTitleStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              borderRadius: 20,
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: widget.lesson.effectiveVideoId != null
                      ? YoutubePlayer(controller: _controller)
                      : Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: Text('Không tìm thấy video YouTube hợp lệ.'),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (widget.lesson.description.isNotEmpty)
              AppCard(
                borderRadius: 20,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mô tả',
                      style: titleStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.lesson.description,
                      style: descriptionStyle,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
