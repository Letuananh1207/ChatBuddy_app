import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/widgets/app_card.dart';
import 'community_post_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'author': 'Minh Anh',
      'time': '2 giờ trước',
      'content':
          'Mình đang phân biệt から và まで trong tiếng Nhật. Bạn nào có mẹo nhớ dễ hiểu không?',
      'image': null,
      'audio': null,
    },
    {
      'author': 'Hà Vy',
      'time': '5 giờ trước',
      'content': 'Hôm nay mình chia sẻ bài luyện nghe về hội thoại nhà hàng.',
      'image':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=60',
      'audio': null,
    },
    {
      'author': 'Tùng',
      'time': 'Hôm qua',
      'content':
          'Ai sửa giúp mình cách phát âm つ với ち được không? Mình có ghi âm mẫu trong file.',
      'image': null,
      'audio': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: _posts.length + 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.of(context)
                              .push<Map<String, dynamic>>(
                            MaterialPageRoute(
                              builder: (context) => const CommunityPostScreen(),
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              _posts.insert(0, result);
                            });
                          }
                        },
                        child: AppCard(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 18),
                          borderRadius: 20,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Bạn muốn chia sẻ điều gì?',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
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

                    return _buildPostCard(_posts[index - 1]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.indigo.withOpacity(0.2),
                child: Text(
                  post['author'][0],
                  style: const TextStyle(color: AppColors.indigo),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['author'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    post['time'],
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            post['content'],
            style: TextStyle(color: Colors.grey.shade800, height: 1.45),
          ),
          if (post['image'] != null) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                post['image'],
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 160,
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
          if (post['audio'] == true) ...[
            const SizedBox(height: 14),
            Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.indigo,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ghi âm học tập',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '00:45',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz, color: Colors.grey.shade500),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              _buildPostAction(Icons.thumb_up_alt_outlined, '56'),
              const SizedBox(width: 16),
              _buildPostAction(Icons.chat_bubble_outline, '14'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostAction(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
              color: Colors.grey.shade600, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
