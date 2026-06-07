import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../data/models/arena_models.dart';
import '../../data/repositories/arena_repository.dart';
import '../../data/services/api_service.dart';
import '../../state/auth_notifier.dart';
import 'arena_start_match_screen.dart';

class ArenaRoomScreen extends ConsumerStatefulWidget {
  final String roomName;
  final String roomCode;
  final bool isHost;
  final ArenaRoom? initialRoom;

  const ArenaRoomScreen({
    super.key,
    required this.roomName,
    required this.roomCode,
    this.isHost = false,
    this.initialRoom,
  });

  @override
  ConsumerState<ArenaRoomScreen> createState() => _ArenaRoomScreenState();
}

class _ArenaRoomScreenState extends ConsumerState<ArenaRoomScreen> {
  ArenaRoom? _room;
  bool _isLoading = false;
  bool _isLeaving = false;

  @override
  void initState() {
    super.initState();
    _room = widget.initialRoom;
    _fetchRoom();
  }

  void _ensureAuthToken() {
    final authState = ref.read(authProvider);
    final apiService = ref.read(apiServiceProvider);
    if (authState.token != null && authState.token!.isNotEmpty) {
      apiService.setAuthToken(authState.token);
    }
  }

  Future<void> _fetchRoom() async {
    setState(() => _isLoading = true);
    _ensureAuthToken();
    final room =
        await ref.read(arenaRepositoryProvider).getRoom(widget.roomCode);
    if (!mounted) return;
    setState(() {
      _room = room ?? _room;
      _isLoading = false;
    });
  }

  Future<void> _updateReady(bool ready) async {
    if (_room == null) return;

    setState(() => _isLoading = true);
    _ensureAuthToken();
    final updatedRoom = await ref.read(arenaRepositoryProvider).setReady(
          widget.roomCode,
          ready,
        );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (updatedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể cập nhật trạng thái sẵn sàng. Thử lại sau.'),
        ),
      );
      return;
    }

    setState(() {
      _room = updatedRoom;
    });

    if (updatedRoom.status == 'running') {
      _openMatch(updatedRoom);
    }
  }

  Future<void> _leaveRoom() async {
    if (_isLeaving) return;
    setState(() => _isLeaving = true);
    _ensureAuthToken();
    final success =
        await ref.read(arenaRepositoryProvider).leaveRoom(widget.roomCode);
    setState(() => _isLeaving = false);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Không thể rời phòng. Thử lại sau.')),
    );
  }

  void _openMatch(ArenaRoom room) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArenaStartMatchScreen(
          room: room,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.id ?? '';
    final room = _room;
    final participant = room?.participantForUser(currentUserId);
    final isReady = participant?.ready ?? false;
    final isRunning = room?.status == 'running';
    final isFinished = room?.status == 'finished';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.indigo),
        title: Text(
          'Phòng: ${widget.roomName}',
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
                    if (_isLoading && room == null)
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
            if (_isLoading)
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
