import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/colors.dart';
import '../../data/models/arena_models.dart';
import '../../data/repositories/arena_repository.dart';
import '../../data/services/api_service.dart';
import '../../state/auth_notifier.dart';
import '../arena/arena_room_screen.dart';

class ArenaScreen extends ConsumerStatefulWidget {
  const ArenaScreen({super.key});

  @override
  ConsumerState<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends ConsumerState<ArenaScreen> {
  final TextEditingController _createController = TextEditingController();
  final TextEditingController _joinController = TextEditingController();

  final List<Map<String, String>> _history = [];
  bool _isProcessing = false;

  @override
  void dispose() {
    _createController.dispose();
    _joinController.dispose();
    super.dispose();
  }

  void _ensureAuthToken() {
    final authState = ref.read(authProvider);
    final apiService = ref.read(apiServiceProvider);
    if (authState.token != null && authState.token!.isNotEmpty) {
      apiService.setAuthToken(authState.token);
    }
  }

  Future<ArenaRoom?> _createRoom() async {
    _ensureAuthToken();
    return await ref.read(arenaRepositoryProvider).createRoom();
  }

  Future<ArenaRoom?> _joinRoom(String code) async {
    _ensureAuthToken();
    return await ref.read(arenaRepositoryProvider).joinRoom(code);
  }

  void _showCreateDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo phòng mới'),
        content: TextField(
          controller: _createController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Tên phòng',
            hintText: 'Nhập tên phòng',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _createController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: _isProcessing
                ? null
                : () async {
                    final name = _createController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Vui lòng nhập tên phòng')),
                      );
                      return;
                    }

                    _createController.clear();
                    Navigator.of(context).pop();
                    setState(() => _isProcessing = true);

                    final room = await _createRoom();
                    if (!context.mounted) return;
                    setState(() => _isProcessing = false);

                    if (room == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Không thể tạo phòng. Kiểm tra kết nối và đăng nhập.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _history.insert(0, {
                        'name': name,
                        'code': room.code,
                      });
                    });

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ArenaRoomScreen(
                          roomName: name,
                          roomCode: room.code,
                          isHost: true,
                          initialRoom: room,
                        ),
                      ),
                    );
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
            onPressed: _isProcessing
                ? null
                : () async {
                    final code = _joinController.text.trim();
                    if (code.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập mã phòng')),
                      );
                      return;
                    }

                    _joinController.clear();
                    Navigator.of(context).pop();
                    setState(() => _isProcessing = true);

                    final room = await _joinRoom(code);
                    if (!context.mounted) return;
                    setState(() => _isProcessing = false);

                    if (room == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Không thể tham gia phòng. Kiểm tra mã phòng và kết nối.',
                          ),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _history.insert(0, {
                        'name': code,
                        'code': code,
                      });
                    });

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ArenaRoomScreen(
                          roomName: code,
                          roomCode: room.code,
                          isHost: false,
                          initialRoom: room,
                        ),
                      ),
                    );
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
                        title: Text(item['name'] ?? ''),
                        subtitle: Text('Mã phòng: ${item['code'] ?? ''}'),
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
