import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/widgets/app_card.dart';

typedef CommunityPostCallback = Future<void> Function(
  String content, {
  List<PlatformFile>? images,
  List<PlatformFile>? audios,
});

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
  bool _isPosting = false;
  List<PlatformFile>? _selectedImages;
  List<PlatformFile>? _selectedAudios;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        // Validate that all selected files are images
        final validFiles = result.files.where((file) {
          final ext = file.extension?.toLowerCase() ?? '';
          return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
        }).toList();

        if (validFiles.isNotEmpty) {
          setState(() {
            _selectedImages = validFiles;
          });
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vui lòng chọn file ảnh hợp lệ')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
      );
    }
  }

  Future<void> _pickAudio() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'aac', 'm4a', 'flac', 'ogg', 'wma'],
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        // Validate that all selected files are audio
        final validFiles = result.files.where((file) {
          final ext = file.extension?.toLowerCase() ?? '';
          return ['mp3', 'wav', 'aac', 'm4a', 'flac', 'ogg', 'wma']
              .contains(ext);
        }).toList();

        if (validFiles.isNotEmpty) {
          setState(() {
            _selectedAudios = validFiles;
          });
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vui lòng chọn file audio hợp lệ')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn audio: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages?.removeAt(index);
      if (_selectedImages?.isEmpty ?? false) {
        _selectedImages = null;
      }
    });
  }

  void _removeAudio(int index) {
    setState(() {
      _selectedAudios?.removeAt(index);
      if (_selectedAudios?.isEmpty ?? false) {
        _selectedAudios = null;
      }
    });
  }

  Future<void> _handlePost() async {
    final content = _postController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isPosting = true);
    try {
      await widget.onPost(
        content,
        images: _selectedImages,
        audios: _selectedAudios,
      );
      if (!mounted) return;
      _postController.clear();
      setState(() {
        _selectedImages = null;
        _selectedAudios = null;
      });
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
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
      bottomNavigationBar: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedImages != null && _selectedImages!.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ảnh được chọn:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF616161),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedImages!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final file = entry.value;
                        return Chip(
                          label: Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onDeleted: () => _removeImage(index),
                          deleteIcon: const Icon(Icons.close, size: 18),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            if (_selectedAudios != null && _selectedAudios!.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Audio được chọn:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF616161),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedAudios!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final file = entry.value;
                        return Chip(
                          label: Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onDeleted: () => _removeAudio(index),
                          deleteIcon: const Icon(Icons.close, size: 18),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              borderRadius: 0,
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.image_outlined),
                    label: const Text("Ảnh"),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _pickAudio,
                    icon: const Icon(Icons.audiotrack),
                    label: const Text("Audio"),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isPosting ? null : _handlePost,
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
                    child: _isPosting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Đăng',
                            style: TextStyle(color: Colors.white),
                          ),
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
