import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class VocabItem extends StatelessWidget {
  final String jp;
  final String reading;

  const VocabItem({super.key, required this.jp, required this.reading});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Thêm hiệu ứng nhấn để tăng trải nghiệm người dùng
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Hiển thị: Kanji (phiên âm) trên một hàng
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    jp,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '($reading)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Icon mũi tên nhỏ gọn đồng bộ với trang Learning và Settings
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
