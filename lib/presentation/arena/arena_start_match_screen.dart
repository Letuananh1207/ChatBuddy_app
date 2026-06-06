import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class ArenaStartMatchScreen extends StatefulWidget {
  final String roomName;
  final String roomCode;

  const ArenaStartMatchScreen({
    super.key,
    required this.roomName,
    required this.roomCode,
  });

  @override
  State<ArenaStartMatchScreen> createState() => _ArenaStartMatchScreenState();
}

class _ArenaStartMatchScreenState extends State<ArenaStartMatchScreen> {
  int _currentQuestion = 1;
  int _totalQuestions = 5;
  int? _selectedAnswer;

  final String _question = "Từ '勝利' trong tiếng Nhật có nghĩa là gì?";
  final List<String> _answers = [
    "Chiến thắng",
    "Thất bại",
    "Bạn bè",
    "Ngôn ngữ",
  ];

  // 🔹 Bộ đếm thời gian tổng
  int _totalTime = 60; // tổng thời gian (giây)
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_totalTime > 0) {
        setState(() {
          _totalTime--;
        });
      } else {
        timer.cancel();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hết giờ!')),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onAnswerSelected(int index) {
    setState(() {
      _selectedAnswer = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.indigo),
        title: const Text(
          'Trận đấu',
          style: TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 Thanh tiến trình + thời gian tổng
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: _currentQuestion / _totalQuestions,
                    backgroundColor: Colors.grey.shade300,
                    color: AppColors.indigo,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '⏱ $_totalTime s',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.indigo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Câu hỏi
            Text(
              "Câu $_currentQuestion/$_totalQuestions",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _question,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 24),

            // 🔹 4 đáp án
            ...List.generate(_answers.length, (index) {
              final isSelected = _selectedAnswer == index;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? AppColors.indigo : Colors.white,
                    foregroundColor:
                        isSelected ? Colors.white : AppColors.darkText,
                    side: BorderSide(
                      color:
                          isSelected ? AppColors.indigo : Colors.grey.shade300,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _onAnswerSelected(index),
                  child: Text(
                    _answers[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            }),

            const Spacer(),

            // 🔹 Nút tiếp tục
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chuyển sang câu tiếp theo...')),
                );
              },
              child: const Text(
                'Tiếp tục',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
