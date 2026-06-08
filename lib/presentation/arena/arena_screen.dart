import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../state/arena_notifier.dart';
import '../../data/services/arena_history_service.dart';
import '../arena/arena_room_screen.dart';

class ArenaScreen extends ConsumerStatefulWidget {
  const ArenaScreen({super.key});

  @override
  ConsumerState<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends ConsumerState<ArenaScreen> {
  final TextEditingController _joinController = TextEditingController();
  final List<Map<String, String>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await ArenaHistoryService.getHistory();
    setState(() {
      _history.clear();
      _history.addAll(history);
    });
  }

  @override
  void dispose() {
    _joinController.dispose();
    super.dispose();
  }

  void _showCreateDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo phòng mới'),
        content: const Text('Bạn sắp tạo một phòng Arena mới.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();

              // Tạo phòng
              final notifier = ref.read(arenaNotifierProvider(null).notifier);
              await notifier.createRoom();

              if (!context.mounted) return;

              final state = ref.read(arenaNotifierProvider(null));
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
                return;
              }

              if (state.room != null) {
                final newItem = {
                  'code': state.room!.code,
                };
                await ArenaHistoryService.addToHistory(newItem);
                setState(() {
                  _history.insert(0, newItem);
                });

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ArenaRoomScreen(
                      roomCode: state.room!.code,
                      isHost: true,
                    ),
                  ),
                );
              }
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  void _showJoinDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tham gia phòng'),
        content: TextField(
          controller: _joinController,
          decoration: const InputDecoration(hintText: 'Mã phòng'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _joinController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = _joinController.text.trim();
              if (code.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập mã phòng')),
                );
                return;
              }

              _joinController.clear();
              Navigator.of(context).pop();

              // Tham gia phòng
              final notifier = ref.read(arenaNotifierProvider(null).notifier);
              await notifier.joinRoom(code);

              if (!context.mounted) return;

              final state = ref.read(arenaNotifierProvider(null));
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
                return;
              }

              if (state.room != null) {
                final newItem = {
                  'code': state.room!.code,
                };
                await ArenaHistoryService.addToHistory(newItem);
                setState(() {
                  _history.insert(0, newItem);
                });

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ArenaRoomScreen(
                      roomCode: state.room!.code,
                      isHost: false,
                    ),
                  ),
                );
              }
            },
            child: const Text('Tham gia'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'WORD ARENA',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.indigo,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.indigo,
                    ),
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: const Text(
                      'Tạo phòng',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: _showCreateDialog,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    icon: const Icon(Icons.meeting_room, size: 18),
                    label: const Text(
                      'Tham gia phòng',
                      style: TextStyle(fontSize: 14),
                    ),
                    onPressed: _showJoinDialog,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_history.isNotEmpty) ...[
              const Text(
                'Lịch sử tham gia',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: const Text('Phòng'),
                        subtitle: Text('Mã: ${item['code'] ?? ''}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
