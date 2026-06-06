import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/recommended_lesson.dart';
import 'youtube_player_screen.dart';

class LessonCard extends StatelessWidget {
  final dynamic item;

  const LessonCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final title = item is RecommendedLesson
        ? item.title
        : item['title'] as String? ?? 'Bài học mới';
    final description = item is RecommendedLesson
        ? item.description
        : item['desc'] as String? ?? '';
    final thumbnailUrl = item is RecommendedLesson ? item.thumbnailUrl : null;
    final channelTitle = item is RecommendedLesson ? item.channelTitle : null;
    final publishedAt = item is RecommendedLesson ? item.publishedAt : null;
    final videoId = item is RecommendedLesson ? item.effectiveVideoId : null;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: item is RecommendedLesson && videoId != null
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => YoutubePlayerScreen(
                    lesson: item as RecommendedLesson,
                  ),
                ),
              );
            }
          : null,
      child: AppCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        borderRadius: 20,
        child: Row(
          children: [
            // Thumbnail or placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 80,
                height: 60,
                color: const Color(0xFFEEF2FF),
                child: thumbnailUrl != null
                    ? Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.play_circle_fill_rounded,
                          color: AppColors.indigo,
                          size: 28,
                        ),
                      )
                    : const Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppColors.indigo,
                        size: 28,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                  if (channelTitle != null || publishedAt != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${channelTitle ?? ''}${channelTitle != null && publishedAt != null ? ' · ' : ''}${publishedAt != null ? '${publishedAt.day.toString().padLeft(2, '0')}/${publishedAt.month.toString().padLeft(2, '0')}/${publishedAt.year}' : ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 10),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey.shade300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
