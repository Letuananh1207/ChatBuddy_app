import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/colors.dart';

class StatisticCharts {
  // Dữ liệu biểu đồ tròn (Giữ nguyên)
  static List<PieChartSectionData> getSections(String viewMode) {
    bool isDay = viewMode == "day";
    return [
      PieChartSectionData(
        color: AppColors.indigo,
        value: isDay ? 43 : 50,
        title: isDay ? 'の方か\n43%' : 'の方か\n50%',
        radius: 30,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xFFEC4899),
        value: isDay ? 29 : 20,
        title: isDay ? 'は vs が\n29%' : 'は vs が\n20%',
        radius: 30,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xFF10B981),
        value: isDay ? 18 : 15,
        title: isDay ? 'Thì Te\n18%' : 'Thì Te\n15%',
        radius: 30,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color(0xFFF59E0B),
        value: isDay ? 11 : 15,
        title: isDay ? 'Khác\n11%' : 'Khác\n15%',
        radius: 30,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  // Cấu hình Line Chart: Số lỗi nguyên (Integer) và xu hướng giảm
  static LineChartData getLineData(String viewMode) {
    bool isDay = viewMode == "day";

    final titles = isDay
        ? ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
        : [
            'Th1',
            'Th2',
            'Th3',
            'Th4',
            'Th5',
            'Th6',
            'Th7',
            'Th8',
            'Th9',
            'Th10',
            'Th11',
            'Th12',
          ];

    // Dữ liệu số lỗi giảm dần (Số nguyên)
    final spots = isDay
        ? const [
            FlSpot(0, 8), // Thứ 2: 8 lỗi
            FlSpot(1, 6),
            FlSpot(2, 7), // Biến động nhẹ
            FlSpot(3, 4),
            FlSpot(4, 3),
            FlSpot(5, 2),
            FlSpot(6, 1), // Chủ nhật: 1 lỗi
          ]
        : const [
            FlSpot(0, 100), // Tháng 1
            FlSpot(1, 85),
            FlSpot(2, 90),
            FlSpot(3, 70),
            FlSpot(4, 65),
            FlSpot(5, 50),
            FlSpot(6, 45),
            FlSpot(7, 30),
            FlSpot(8, 35),
            FlSpot(9, 20),
            FlSpot(10, 15),
            FlSpot(11, 10), // Tháng 12
          ];

    return LineChartData(
      // Hiển thị số lỗi ngay tại các nút
      showingTooltipIndicators: spots.map((spot) {
        return ShowingTooltipIndicators([
          LineBarSpot(LineChartBarData(spots: spots), 0, spot),
        ]);
      }).toList(),

      lineTouchData: LineTouchData(
        enabled: false,
        handleBuiltInTouches: false,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) => Colors.transparent,
          tooltipMargin: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                barSpot.y
                    .toInt()
                    .toString(), // Ép kiểu về Int để hiển thị số nguyên
                const TextStyle(
                  color: AppColors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              );
            }).toList();
          },
        ),
      ),

      gridData: const FlGridData(show: true, drawVerticalLine: false),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < titles.length) {
                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  child: Text(
                    titles[index],
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isDay ? 12 : 9,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.indigo,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.indigo.withOpacity(0.1),
          ),
        ),
      ],
      minX: 0,
      maxX: (titles.length - 1).toDouble(),
      // Điều chỉnh khoảng trống để không mất số chú thích ở trên
      minY: 0, // Số lỗi thấp nhất là 0
      maxY:
          spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) +
          (isDay ? 3 : 20),
    );
  }
}
