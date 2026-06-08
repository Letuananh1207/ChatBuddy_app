import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import 'arena_ranking_screen.dart';
import '../../state/arena_notifier.dart';

class ArenaStartMatchScreen extends ConsumerStatefulWidget {
  final String roomCode;

  const ArenaStartMatchScreen({
    super.key,
    required this.roomCode,
  });

  @override
  ConsumerState<ArenaStartMatchScreen> createState() =>
      _ArenaStartMatchScreenState();
}

class _ArenaStartMatchScreenState extends ConsumerState<ArenaStartMatchScreen> {
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  int _correctCount = 0;
  bool _awaitingFinish = false;
  Timer? _timer;
  DateTime? _matchStartTime;

  @override
  void initState() {
    super.initState();
    _matchStartTime = DateTime.now();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  Future<void> _submitAnswer() async {
    if (_selectedAnswerIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng chọn đáp án trước khi tiếp tục.')),
      );
      return;
    }

    final arenaState = ref.read(arenaNotifierProvider(null));
    final room = arenaState.room;

    if (room == null || room.questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có câu hỏi.')),
      );
      return;
    }

    final currentQuestion = room.questions[_currentQuestionIndex];
    final selectedAnswer = currentQuestion.options[_selectedAnswerIndex!];
    if (selectedAnswer == currentQuestion.correctAnswer) {
      _correctCount += 1;
    }

    final isLastQuestion = _currentQuestionIndex + 1 >= room.questions.length;
    final notifier = ref.read(arenaNotifierProvider(null).notifier);

    if (isLastQuestion) {
      final duration = _matchStartTime != null
          ? DateTime.now().difference(_matchStartTime!).inSeconds
          : 0;
      await notifier.sendAnswer(
        widget.roomCode,
        score: _correctCount,
        duration: duration,
      );
    }

    if (!mounted) return;

    final updatedState = ref.read(arenaNotifierProvider(null));
    if (updatedState.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updatedState.errorMessage!)),
      );
      return;
    }

    setState(() {
      _selectedAnswerIndex = null;
      if (isLastQuestion) {
        _awaitingFinish = true;
      }
    });

    if (_currentQuestionIndex + 1 < room.questions.length) {
      setState(() {
        _currentQuestionIndex += 1;
      });
      return;
    }

    if (isLastQuestion) {
      if (updatedState.room?.status == 'finished') {
        _navigateToDashboard();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Đã gửi kết quả. Vui lòng chờ trạng thái trận đấu chuyển sang FINISHED.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trận đấu đã kết thúc.')),
    );
    Navigator.of(context).pop();
  }

  void _navigateToDashboard() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => ArenaRankingScreen(roomCode: widget.roomCode),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(arenaNotifierProvider(null), (previous, next) {
      if (_awaitingFinish && next.room?.status == 'finished') {
        _navigateToDashboard();
      }
    });

    final arenaState = ref.watch(arenaNotifierProvider(null));
    final room = arenaState.room;
    final hasQuestions = room != null && room.questions.isNotEmpty;
    final currentQuestion =
        hasQuestions ? room.questions[_currentQuestionIndex] : null;
    final isLastQuestion =
        hasQuestions && _currentQuestionIndex + 1 >= room.questions.length;
    final isSubmitting = arenaState.isSubmitting;

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
            if (hasQuestions) ...[
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value:
                          (_currentQuestionIndex + 1) / room.questions.length,
                      backgroundColor: Colors.grey.shade300,
                      color: AppColors.indigo,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_currentQuestionIndex + 1}/${room.questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.indigo,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Câu ${_currentQuestionIndex + 1}/${room.questions.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                (currentQuestion?.text.isNotEmpty ?? false)
                    ? currentQuestion!.text
                    : 'Không có nội dung câu hỏi.',
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              if (currentQuestion?.options.isEmpty ?? true)
                const Text(
                  'Không có đáp án cho câu hỏi này.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion?.options.length ?? 0,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedAnswerIndex == index;
                      final answerText = currentQuestion?.options[index] ?? '';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSelected ? AppColors.indigo : Colors.white,
                            foregroundColor:
                                isSelected ? Colors.white : AppColors.darkText,
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.indigo
                                  : Colors.grey.shade300,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _selectAnswer(index),
                          child: Text(
                            answerText,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ] else ...[
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
            const SizedBox(height: 12),
            if (_awaitingFinish)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Đã gửi kết quả. Đang chờ trận đấu kết thúc...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.indigo, fontSize: 14),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: !_awaitingFinish &&
                      hasQuestions &&
                      _selectedAnswerIndex != null &&
                      !isSubmitting
                  ? _submitAnswer
                  : null,
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      isLastQuestion ? 'Hoàn thành' : 'Tiếp tục',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
