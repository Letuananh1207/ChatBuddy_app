import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.indigo,
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 1.1,
      ),
    );
  }
}
