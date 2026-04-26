import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/section_title.dart';
import 'widgets/vocab_item.dart';
import 'widgets/statistic_charts.dart';
import 'widgets/pie_chart_section.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8), // Khoảng cách nhẹ phía trên selector
            _buildModeSelector(),
            const SizedBox(height: 20),

            // Biểu đồ tròn lỗi sai
            PieChartSection(viewMode: viewMode),
            const SizedBox(height: 30),

            // Biểu đồ tiến trình
            _buildProgressSection(),
            const SizedBox(height: 25),

            const SectionTitle(title: 'Từ vựng đã lưu'),
            const SizedBox(height: 8),

            // Nhóm các VocabItem vào một AppCard duy nhất
            AppCard(
              padding: EdgeInsets.zero, // Để các item chạm mép card
              borderRadius: 20,
              child: Column(
                children: [
                  const VocabItem(jp: "勉強", reading: "べんきょう"),
                  _buildDivider(),
                  const VocabItem(jp: "食べる", reading: "たべる"),
                  _buildDivider(),
                  const VocabItem(jp: "走る", reading: "はしる"),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Divider mờ để phân cách các từ vựng
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade50,
      indent: 16,
      endIndent: 16,
    );
  }

  // Bộ chọn Mode dạng Mini Tab Pill với Icon + Text
  Widget _buildModeSelector() {
    return Center(
      child: Container(
        height: 36,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              alignment: viewMode == "day"
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 66,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.indigo.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                _buildModeButton(
                  Icons.calendar_view_day_rounded,
                  "D",
                  viewMode == "day",
                  () => setState(() => viewMode = "day"),
                ),
                _buildModeButton(
                  Icons.calendar_month_rounded,
                  "M",
                  viewMode == "month",
                  () => setState(() => viewMode = "month"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Hàm build button hỗ trợ cả Icon và nhãn viết tắt
  Widget _buildModeButton(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          // Bọc Center ở ngoài cùng để căn giữa toàn bộ Row
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // Chỉ chiếm không gian vừa đủ để dễ căn giữa
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment
                .center, // Căn giữa icon và text theo chiều dọc
            children: [
              Icon(
                icon,
                size: 14,
                color: isActive ? AppColors.indigo : Colors.grey.shade400,
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(
                  top: 1,
                ), // Thêm 1px padding top để bù trừ độ cao của font chữ nếu cần
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? AppColors.indigo : Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    height:
                        1, // Ép line-height về 1 để không có khoảng trống thừa trên/dưới chữ
                  ),
                ),
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
          const SectionTitle(title: 'Tiến trình'),
          const SizedBox(height: 15),
          SizedBox(
            height: 150,
            child: LineChart(StatisticCharts.getLineData(viewMode)),
          ),
        ],
      ),
    );
  }
}
