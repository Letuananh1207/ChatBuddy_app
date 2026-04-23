import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/section_title.dart';
import 'widgets/vocab_item.dart';
import 'widgets/statistic_charts.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  String viewMode = "day";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModeSelector(),
            const SizedBox(height: 20),
            _buildPieChartSection(),
            const SizedBox(height: 30),
            _buildProgressSection(),
            const SizedBox(height: 30),
            const SectionTitle(title: 'TỪ VỰNG ĐÃ LƯU'),
            const SizedBox(height: 10),
            const VocabItem(jp: "勉強", reading: "べんきょう"),
            const VocabItem(jp: "食べる", reading: "たべる"),
            const VocabItem(jp: "走る", reading: "はしる"),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ToggleButtons(
          borderRadius: BorderRadius.circular(12),
          isSelected: [viewMode == "day", viewMode == "month"],
          onPressed: (index) =>
              setState(() => viewMode = index == 0 ? "day" : "month"),
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "NGÀY",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "THÁNG",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartSection() {
    return AppCard(
      child: Center(
        child: SizedBox(
          height: 180, // Giảm chiều cao tổng thể (từ 240 xuống 180)
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Biểu đồ tròn thu nhỏ
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 50, // Thu nhỏ lòng trong (từ 65 xuống 50)
                  sections: StatisticCharts.getSections(viewMode),
                ),
              ),

              // Chữ hiển thị ở giữa thu nhỏ lại một chút cho cân đối
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewMode == "day" ? '28' : '120',
                    style: const TextStyle(
                      fontSize: 28, // Giảm từ 36 xuống 28
                      fontWeight: FontWeight.w900,
                      color: AppColors.indigo,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    'LỖI SAI',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 9, // Giảm từ 10 xuống 9
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'TIẾN TRÌNH'),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(StatisticCharts.getLineData(viewMode)),
          ),
        ],
      ),
    );
  }
}
