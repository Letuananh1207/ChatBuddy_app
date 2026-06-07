import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../data/models/arena_models.dart';
import '../../data/repositories/arena_repository.dart';
import '../../data/services/api_service.dart';
import '../../state/auth_notifier.dart';

class ArenaStartMatchScreen extends ConsumerStatefulWidget {
  final ArenaRoom room;

  const ArenaStartMatchScreen({
    super.key,
    required this.room,
  });

  @override
  ConsumerState<ArenaStartMatchScreen> createState() =>
      _ArenaStartMatchScreenState();
}

class _ArenaStartMatchScreenState extends ConsumerState<ArenaStartMatchScreen> {
  late ArenaRoom _room;
  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  int _totalTime = 60;
  Timer? _timer;
  DateTime? _questionStartTime;
  bool _isSubmitting = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _startTimer();
    if (_room.questions.isEmpty) {
      _refreshRoom();
    } else {
      _questionStartTime = DateTime.now();
    }
  }

  void _ensureAuthToken() {
    final authState = ref.read(authProvider);
    final apiService = ref.read(apiServiceProvider);
    if (authState.token != null && authState.token!.isNotEmpty) {
      apiService.setAuthToken(authState.token);
    }
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

  Future<void> _refreshRoom() async {
    setState(() {
      _isLoading = true;
    });
    _ensureAuthToken();
    final updatedRoom =
        await ref.read(arenaRepositoryProvider).getRoom(_room.code);
    if (!mounted) return;
    setState(() {
      if (updatedRoom != null) {
        _room = updatedRoom;
      }
      _isLoading = false;
      _questionStartTime ??= DateTime.now();
    });
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

    final currentQuestion = _room.questions[_currentQuestionIndex];
    final answer = currentQuestion.options[_selectedAnswerIndex!];
    final duration = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inSeconds
        : 0;

    setState(() {
      _isSubmitting = true;
    });
    _ensureAuthToken();
    final updatedRoom = await ref.read(arenaRepositoryProvider).sendAnswer(
          _room.code,
          questionIndex: _currentQuestionIndex,
          answer: answer,
          duration: duration,
        );
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
    });

    if (updatedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Không gửi được câu trả lời. Thử lại sau.')),
      );
      return;
    }

    setState(() {
      _room = updatedRoom;
      _selectedAnswerIndex = null;
      _questionStartTime = DateTime.now();
    });

    if (_currentQuestionIndex + 1 < _room.questions.length) {
      setState(() {
        _currentQuestionIndex += 1;
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trận đấu đã kết thúc.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final hasQuestions = _room.questions.isNotEmpty;
    final currentQuestion =
        hasQuestions ? _room.questions[_currentQuestionIndex] : null;

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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: hasQuestions
                              ? (_currentQuestionIndex + 1) /
                                  _room.questions.length
                              : 0,
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
                  if (!hasQuestions)
                    const Center(
                      child: Text(
                        'Không có câu hỏi để hiển thị.',
                        style: TextStyle(color: Colors.black87),
                      ),
                    )
                  else ...[
                    Text(
                      'Câu ${_currentQuestionIndex + 1}/${_room.questions.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentQuestion?.text ?? '',
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(
                      currentQuestion?.options.length ?? 0,
                      (index) {
                        final isSelected = _selectedAnswerIndex == index;
                        final answerText =
                            currentQuestion?.options[index] ?? '';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isSelected ? AppColors.indigo : Colors.white,
                              foregroundColor: isSelected
                                  ? Colors.white
                                  : AppColors.darkText,
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
                  ],
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed:
                        hasQuestions && !_isSubmitting ? _submitAnswer : null,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
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
