import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Tất cả bài viết và thảo luận cộng đồng sẽ xuất hiện ở đây.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
