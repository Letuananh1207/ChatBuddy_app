import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/community_post.dart';
import '../../data/repositories/community_repository.dart';
import 'community_post_detail_screen.dart';
import 'community_post_screen.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(communityPostsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(communityPostsProvider);
            },
            child: postsAsync.when(
              data: (posts) => ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: posts.length + 1,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () async {
                        final result =
                            await Navigator.of(context).push<CommunityPost?>(
                          MaterialPageRoute(
                            builder: (context) => const CommunityPostScreen(),
                          ),
                        );
                        if (result != null) {
                          ref.invalidate(communityPostsProvider);
                        }
                      },
                      child: AppCard(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 18),
                        borderRadius: 20,
                        child: Row(
                          children: [
                            Expanded(
                              child: const Text(
                                'Bạn muốn chia sẻ điều gì?',
                                style: TextStyle(
                                  color: Color(0xFF757575),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.edit_note, color: AppColors.indigo),
                          ],
                        ),
                      ),
                    );
                  }

                  return _buildPostCard(context, posts[index - 1]);
                },
              ),
              loading: () => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, stackTrace) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Không thể tải bài viết cộng đồng. $error',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, CommunityPost post) {
    final hasImage = post.images.isNotEmpty;
    final hasAudio = post.audio.isNotEmpty;
    final attachmentText = <Widget>[];
    if (hasImage) {
      attachmentText.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.photo, size: 16, color: Color(0xFF616161)),
          const SizedBox(width: 4),
          Text(
            '${post.images.length} ảnh',
            style: const TextStyle(color: Color(0xFF616161), fontSize: 12),
          ),
        ],
      ));
    }
    if (hasAudio) {
      if (attachmentText.isNotEmpty) {
        attachmentText.add(const SizedBox(width: 8));
      }
      attachmentText.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.audiotrack, size: 16, color: Color(0xFF616161)),
          const SizedBox(width: 4),
          Text(
            '${post.audio.length} audio',
            style: const TextStyle(color: Color(0xFF616161), fontSize: 12),
          ),
        ],
      ));
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CommunityPostDetailScreen(
              post: post,
            ),
          ),
        );
      },
      child: AppCard(
        padding: const EdgeInsets.all(16),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.indigo.withAlpha(51),
                  child: Text(
                    post.authorInitial,
                    style: const TextStyle(color: AppColors.indigo),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorUsername,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.timeLabel,
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              post.text,
              style: const TextStyle(color: Color(0xFF424242), height: 1.45),
            ),
            if (attachmentText.isNotEmpty) ...[
              const SizedBox(height: 14),
              Row(children: attachmentText),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.thumb_up_alt_outlined,
                    color: Colors.grey.shade600, size: 18),
                const SizedBox(width: 6),
                Text(
                  '${post.likes.length}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(width: 18),
                Row(
                  children: [
                    Icon(Icons.comment_outlined,
                        color: Colors.grey.shade600, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${post.comments.length}',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
