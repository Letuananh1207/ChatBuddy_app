import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class LearningFilter extends StatelessWidget {
  final String viewMode;
  final Function(String) onModeChanged;

  const LearningFilter({
    super.key,
    required this.viewMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 170,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: viewMode == "day"
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: 82,
              height: 28,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              _buildFilterBtn("NGÀY", "day"),
              _buildFilterBtn("THÁNG", "month"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBtn(String label, String mode) {
    bool isActive = viewMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => onModeChanged(mode),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.indigo : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }
}
