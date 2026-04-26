import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Đừng quên thêm intl vào pubspec.yaml
import '../../../core/constants/colors.dart';
import '../../../core/widgets/app_card.dart';

class PieChartSection extends StatelessWidget {
  final String viewMode;

  const PieChartSection({super.key, required this.viewMode});

  // Hàm lấy chuỗi thời gian hiển thị
  String _getTimeRange() {
    final now = DateTime.now();
    if (viewMode == "day") {
      return DateFormat('dd/MM/yyyy').format(now);
    } else {
      return "Tháng ${now.month}/${now.year}";
    }
  }

  List<PieChartSectionData> _getSections() {
    bool isDay = viewMode == "day";
    final List<Map<String, dynamic>> data = [
      {'value': isDay ? 43.0 : 50.0, 'color': AppColors.indigo},
      {'value': isDay ? 29.0 : 20.0, 'color': const Color(0xFFEC4899)},
      {'value': isDay ? 18.0 : 15.0, 'color': const Color(0xFF10B981)},
      {'value': isDay ? 11.0 : 15.0, 'color': const Color(0xFFF59E0B)},
    ];

    return data.map((item) {
      final double val = item['value'] as double;
      return PieChartSectionData(
        color: item['color'] as Color,
        value: val,
        radius: 35,
        showTitle: true,
        title: '${val.toInt()}%',
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          // --- PHẦN NGÀY THÁNG MỚI THÊM VÀO ---
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              _getTimeRange(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          const SizedBox(height: 5),

          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 45,
                    sections: _getSections(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      viewMode == "day" ? '28' : '120',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.indigo,
                      ),
                    ),
                    Text(
                      'TỔNG LỖI',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem("の・か", AppColors.indigo),
                _buildLegendItem("は・が", const Color(0xFFEC4899)),
                _buildLegendItem("Thì Te", const Color(0xFF10B981)),
                _buildLegendItem("Khác", const Color(0xFFF59E0B)),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
