import 'package:flutter/material.dart';
import '../../../core/widgets/app_card.dart';

class VocabItem extends StatelessWidget {
  final String jp;
  final String reading;

  const VocabItem({super.key, required this.jp, required this.reading});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 4),
      borderRadius: 12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$jp  ($reading)",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
