import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/colors.dart';

class StatisticCharts {
  static LineChartData getLineData(String viewMode) {
    bool isDay = viewMode == "day";
    final titles = isDay
        ? ['19', '20', '21', '22', '23', '24', '25']
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

    final spots = isDay
        ? const [
            FlSpot(0, 8),
            FlSpot(1, 6),
            FlSpot(2, 7),
            FlSpot(3, 4),
            FlSpot(4, 3),
            FlSpot(5, 2),
            FlSpot(6, 1),
          ]
        : const [
            FlSpot(0, 100),
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
            FlSpot(11, 10),
          ];

    return LineChartData(
      showingTooltipIndicators: spots
          .map(
            (spot) => ShowingTooltipIndicators([
              LineBarSpot(LineChartBarData(spots: spots), 0, spot),
            ]),
          )
          .toList(),
      lineTouchData: LineTouchData(
        enabled: false,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) => Colors.transparent,
          // GIẢM KHOẢNG CÁCH: từ mặc định xuống còn 2 hoặc 4 để sát điểm đốt hơn
          tooltipMargin: 2,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              return LineTooltipItem(
                barSpot.y.toInt().toString(),
                TextStyle(
                  color: AppColors.indigo,
                  fontWeight: FontWeight.bold,
                  // GIẢM KÍCH THƯỚC CHỮ: từ 11 xuống 9 hoặc 8
                  fontSize: 9,
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
      minY: 0,
      maxY:
          spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) +
          (isDay ? 3 : 20),
    );
  }
}
