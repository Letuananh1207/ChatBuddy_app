import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import 'widgets/community_post_input.dart';

class CommunityPostScreen extends StatelessWidget {
  const CommunityPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Đăng bài mới',
          style: TextStyle(color: AppColors.darkText),
        ),
        iconTheme: const IconThemeData(color: AppColors.darkText),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: CommunityPostInput(
            onPost: (content, mediaType) {
              Navigator.of(context).pop({
                'author': 'Bạn',
                'time': 'Vừa xong',
                'content': content,
                'image':
                    mediaType == 'Image' ? 'https://picsum.photos/200' : null,
                'audio': mediaType == 'Audio',
              });
            },
          ),
        ),
      ),
    );
  }
}
