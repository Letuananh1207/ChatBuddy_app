import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/widgets/app_card.dart';

class CommunityPostCommentCard extends StatelessWidget {
  final Map<String, dynamic> comment;

  const CommunityPostCommentCard({super.key, required this.comment});

  String get author {
    final user = comment['user'];
    if (user is Map<String, dynamic>) {
      return user['username']?.toString() ?? 'Người dùng';
    }
    return user?.toString() ?? 'Người dùng';
  }

  String get content => comment['content']?.toString() ?? '';

  String get createdAt {
    final raw = comment['createdAt'];
    if (raw is String) {
      final date = DateTime.tryParse(raw);
      if (date != null) {
        final diff = DateTime.now().difference(date);
        if (diff.inMinutes < 1) return 'Vừa xong';
        if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
        if (diff.inDays < 1) return '${diff.inHours} giờ trước';
        return '${diff.inDays} ngày trước';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.indigo.withAlpha(51),
                child: Text(
                  author.isNotEmpty ? author[0].toUpperCase() : 'U',
                  style: const TextStyle(color: AppColors.indigo),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          author,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkText,
                          ),
                        ),
                        Text(
                          createdAt,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      content,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
