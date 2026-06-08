import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../data/models/arena_models.dart';
import '../../data/repositories/arena_repository.dart';

class ArenaRankingScreen extends ConsumerStatefulWidget {
  final String roomCode;

  const ArenaRankingScreen({
    super.key,
    required this.roomCode,
  });

  @override
  ConsumerState<ArenaRankingScreen> createState() => _ArenaRankingScreenState();
}

class _ArenaRankingScreenState extends ConsumerState<ArenaRankingScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<ArenaParticipant> _rankings = [];

  @override
  void initState() {
    super.initState();
    _fetchRanking();
  }

  Future<void> _fetchRanking() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final repository = ref.read(arenaRepositoryProvider);
    final result = await repository.getRanking(widget.roomCode);

    if (!mounted) return;

    setState(() {
      if (result.isEmpty) {
        _errorMessage = 'Không tải được bảng xếp hạng.';
      } else {
        _rankings = result;
      }
      _isLoading = false;
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
          'Bảng xếp hạng',
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
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Phòng: ${widget.roomCode}',
                        style: const TextStyle(
                          color: AppColors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _rankings.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final participant = _rankings[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.indigo,
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            participant.user.displayName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Đúng: ${participant.correctCount} • Thời gian: ${participant.totalTime}s',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
