import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/community_post.dart';
import '../../data/repositories/community_repository.dart';
import '../../state/auth_notifier.dart';
import 'community_post_comment_card.dart';
import 'community_post_comment_input.dart';

class CommunityPostDetailBody extends ConsumerStatefulWidget {
  final CommunityPost detailPost;

  const CommunityPostDetailBody({super.key, required this.detailPost});

  @override
  ConsumerState<CommunityPostDetailBody> createState() =>
      _CommunityPostDetailBodyState();
}

class _CommunityPostDetailBodyState
    extends ConsumerState<CommunityPostDetailBody> {
  late final AudioPlayer _audioPlayer;
  final TextEditingController _commentController = TextEditingController();
  bool _isPlaying = false;
  bool _isLikeSubmitting = false;
  bool _isCommentSubmitting = false;
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() {
        _duration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() {
        _currentPosition = position;
      });
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _isPlaying = false;
        _currentPosition = _duration;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _toggleDetailAudio(CommunityPost post) async {
    if (post.audio.isEmpty) return;
    final url = post.audio.first;
    if (_isPlaying) {
      await _audioPlayer.pause();
      return;
    }
    if (_currentPosition > Duration.zero && _currentPosition < _duration) {
      await _audioPlayer.resume();
      return;
    }
    _currentPosition = Duration.zero;
    _duration = Duration.zero;
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> _toggleLike(String postId) async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để thích bài viết.')),
      );
      return;
    }

    try {
      setState(() {
        _isLikeSubmitting = true;
      });

      await ref.read(communityRepositoryProvider).toggleLike(postId);
      ref.invalidate(communityPostProvider(widget.detailPost.id));
      ref.invalidate(communityPostsProvider);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật lượt thích. $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLikeSubmitting = false;
        });
      }
    }
  }

  Future<void> _submitComment(String postId) async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để bình luận.')),
      );
      return;
    }

    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    try {
      setState(() {
        _isCommentSubmitting = true;
      });

      await ref
          .read(communityRepositoryProvider)
          .addComment(postId: postId, content: content);
      _commentController.clear();
      ref.invalidate(communityPostProvider(widget.detailPost.id));
      ref.invalidate(communityPostsProvider);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể gửi bình luận. $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCommentSubmitting = false;
        });
      }
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final detailPost = widget.detailPost;
    final currentUserId = ref.watch(authProvider).user?.id ?? '';
    final isLiked = detailPost.likes.contains(currentUserId);
    final audioLabel = detailPost.audio.isNotEmpty
        ? Uri.tryParse(detailPost.audio.first)?.pathSegments.last ??
            'Audio đính kèm'
        : 'Audio đính kèm';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
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
                              detailPost.authorInitial,
                              style: const TextStyle(color: AppColors.indigo),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detailPost.authorUsername,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                detailPost.timeLabel,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        detailPost.text,
                        style: const TextStyle(
                          color: Color(0xFF424242),
                          height: 1.45,
                        ),
                      ),
                      if (detailPost.images.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            detailPost.images.first,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 180,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.broken_image,
                                      size: 40, color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      if (detailPost.audio.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: () => _toggleDetailAudio(detailPost),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.indigo,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Icon(
                                        _isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            audioLabel,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF424242),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _isPlaying
                                                ? 'Đang phát • ${_formatDuration(_currentPosition)} / ${_formatDuration(_duration)}'
                                                : _currentPosition >
                                                            Duration.zero &&
                                                        _currentPosition <
                                                            _duration
                                                    ? 'Tạm dừng • ${_formatDuration(_currentPosition)} / ${_formatDuration(_duration)}'
                                                    : detailPost.audio.length >
                                                            1
                                                        ? '${detailPost.audio.length} file'
                                                        : audioLabel,
                                            style: const TextStyle(
                                              color: Color(0xFF9E9E9E),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.more_horiz,
                                        color: Colors.grey.shade500),
                                  ],
                                ),
                                if (_currentPosition > Duration.zero ||
                                    _isPlaying) ...[
                                  const SizedBox(height: 10),
                                  LinearProgressIndicator(
                                    value: _duration.inMilliseconds > 0
                                        ? _currentPosition.inMilliseconds /
                                            _duration.inMilliseconds
                                        : 0,
                                    color: AppColors.indigo,
                                    backgroundColor: Colors.grey.shade300,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          InkWell(
                            onTap: _isLikeSubmitting
                                ? null
                                : () => _toggleLike(detailPost.id),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    isLiked
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_outlined,
                                    color: isLiked
                                        ? AppColors.indigo
                                        : Colors.grey.shade600,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${detailPost.likes.length}',
                                    style: TextStyle(
                                      color: isLiked
                                          ? AppColors.indigo
                                          : Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.comment_outlined,
                                      color: Colors.grey.shade600, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${detailPost.comments.length}',
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Bình luận',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                ),
                const SizedBox(height: 10),
                if (detailPost.comments.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      'Chưa có bình luận nào. Hãy là người đầu tiên phản hồi!',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: detailPost.comments.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final comment = detailPost.comments[index];
                      return CommunityPostCommentCard(comment: comment);
                    },
                  ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: CommentInputField(
            controller: _commentController,
            isSubmitting: _isCommentSubmitting,
            onSubmit: () => _submitComment(detailPost.id),
          ),
        ),
      ],
    );
  }
}
