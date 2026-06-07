import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../data/repositories/community_repository.dart';
import 'widgets/community_post_input.dart';

class CommunityPostScreen extends ConsumerStatefulWidget {
  const CommunityPostScreen({super.key});

  @override
  ConsumerState<CommunityPostScreen> createState() =>
      _CommunityPostScreenState();
}

class _CommunityPostScreenState extends ConsumerState<CommunityPostScreen> {
  String? _errorMessage;

  Future<void> _createPost(
    String content, {
    List<PlatformFile>? images,
    List<PlatformFile>? audios,
  }) async {
    setState(() {
      _errorMessage = null;
    });

    try {
      final repository = ref.read(communityRepositoryProvider);
      final post = await repository.createPost(
        text: content,
        images: images,
        audios: audios,
      );
      if (!mounted) return;
      Navigator.of(context).pop(post);
    } catch (error) {
      _errorMessage = error.toString();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể đăng bài: $_errorMessage')),
      );
    }
  }

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
            onPost: _createPost,
          ),
        ),
      ),
    );
  }
}
