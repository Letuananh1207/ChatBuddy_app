import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/widgets/app_card.dart';

typedef CommunityPostCallback = void Function(String content, String mediaType);

class CommunityPostInput extends StatefulWidget {
  const CommunityPostInput({
    super.key,
    required this.onPost,
  });

  final CommunityPostCallback onPost;

  @override
  State<CommunityPostInput> createState() => _CommunityPostInputState();
}

class _CommunityPostInputState extends State<CommunityPostInput> {
  final TextEditingController _postController = TextEditingController();
  String _selectedMediaType = 'Text';

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _postController,
            minLines: 6,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'Chia sẻ suy nghĩ hoặc trải nghiệm của bạn...',
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),

      // 🔹 Thanh đăng cố định phía dưới
      bottomNavigationBar: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        borderRadius: 0,
        child: Row(
          children: [
            TextButton.icon(
              onPressed: () {
                // TODO: mở file picker
              },
              icon: const Icon(Icons.image_outlined),
              label: const Text("Ảnh"),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                // TODO: mở chức năng ghi âm
              },
              icon: const Icon(Icons.mic_none),
              label: const Text("Audio"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final content = _postController.text.trim();
                if (content.isEmpty) return;
                widget.onPost(content, _selectedMediaType);
                _postController.clear();
                setState(() => _selectedMediaType = 'Text');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
              ),
              child: const Text(
                'Đăng',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
