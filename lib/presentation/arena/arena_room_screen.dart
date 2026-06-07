import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../data/models/arena_models.dart';
import '../../state/arena_notifier.dart';
import '../../state/auth_notifier.dart';
import 'arena_start_match_screen.dart';

class ArenaRoomScreen extends ConsumerStatefulWidget {
  final String roomCode;
  final bool isHost;

  const ArenaRoomScreen({
    super.key,
    required this.roomCode,
    this.isHost = false,
  });

  @override
  ConsumerState<ArenaRoomScreen> createState() => _ArenaRoomScreenState();
}

class _ArenaRoomScreenState extends ConsumerState<ArenaRoomScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch room data khi screen init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(arenaNotifierProvider(null).notifier).fetchRoom(widget.roomCode);
    });
  }

  Future<void> _updateReady(bool ready) async {
    final notifier = ref.read(arenaNotifierProvider(null).notifier);
    await notifier.setReady(widget.roomCode, ready);

    if (!mounted) return;
    final state = ref.read(arenaNotifierProvider(null));
    if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage!)),
      );
      return;
    }

    if (state.room?.status == 'running') {
      _openMatch(state.room!);
    }
  }

  Future<void> _leaveRoom() async {
    final notifier = ref.read(arenaNotifierProvider(null).notifier);
    await notifier.leaveRoom(widget.roomCode);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _openMatch(ArenaRoom room) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArenaStartMatchScreen(
          roomCode: room.code,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arenaState = ref.watch(arenaNotifierProvider(null));
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.id ?? '';
    final room = arenaState.room;
    final participant = room?.participantForUser(currentUserId);
    final isReady = participant?.ready ?? false;
    final isRunning = room?.status == 'running';
    final isFinished = room?.status == 'finished';
    final isLoading = arenaState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.indigo),
        title: Text(
          'Phòng: ${widget.roomCode}',
          style: const TextStyle(
            color: AppColors.darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: AppColors.indigo),
            onPressed: _leaveRoom,
            tooltip: 'Rời phòng',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thành viên phòng',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    if (isLoading && room == null)
                      const Center(child: CircularProgressIndicator())
                    else if (room == null)
                      const Text('Không tải được thông tin phòng.')
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: room.participants.map((participant) {
                          return Chip(
                            avatar: participant.ready
                                ? const Icon(Icons.check_circle,
                                    size: 18, color: AppColors.indigo)
                                : const Icon(Icons.person,
                                    size: 18, color: Colors.grey),
                            label: Text(participant.user.displayName),
                            backgroundColor: participant.ready
                                ? Colors.indigo.withAlpha(25)
                                : Colors.grey.withAlpha(25),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Thông tin phòng',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Mã phòng', style: TextStyle(fontSize: 14)),
                        Text(
                          widget.roomCode,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.indigo,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Trạng thái',
                            style: TextStyle(fontSize: 14)),
                        Text(
                          room?.status.toUpperCase() ?? 'CHƯA TẢI',
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.darkText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Nội dung phòng',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Nội dung của người chơi sẽ dựa vào các bộ từ vựng của các thành viên trong phòng. Nếu không có dữ liệu thì sẽ dùng bộ từ vựng ngẫu nhiên.',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: room == null || isFinished
                    ? null
                    : () {
                        if (isRunning) {
                          _openMatch(room);
                        } else {
                          _updateReady(!isReady);
                        }
                      },
                child: Text(
                  isFinished
                      ? 'Trận đấu đã kết thúc'
                      : isRunning
                          ? 'Vào trận đấu'
                          : isReady
                              ? 'Hủy sẵn sàng'
                              : 'Sẵn sàng',
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
