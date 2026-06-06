import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'arena_room_screen.dart';

class ArenaScreen extends StatefulWidget {
  const ArenaScreen({super.key});

  @override
  State<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends State<ArenaScreen> {
  final TextEditingController _createController = TextEditingController();
  final TextEditingController _joinController = TextEditingController();

  // 🔹 Lưu lịch sử tham gia phòng
  final List<Map<String, String>> _history = [];

  @override
  void dispose() {
    _createController.dispose();
    _joinController.dispose();
    super.dispose();
  }

  String _generateRoomCode() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
        6,
        (index) => letters[(DateTime.now().millisecondsSinceEpoch + index) %
            letters.length]).join();
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
            onPressed: () {
              final name = _createController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập tên phòng')),
                );
                return;
              }
              final code = _generateRoomCode();
              _createController.clear();
              Navigator.of(context).pop();

              // 🔹 Thêm vào lịch sử
              setState(() {
                _history.insert(0, {"name": name, "code": code});
              });

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ArenaRoomScreen(
                    roomName: name,
                    roomCode: code,
                    isHost: true,
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
          decoration:
              const InputDecoration(hintText: 'Mã phòng hoặc tên phòng'),
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
            onPressed: () {
              final code = _joinController.text.trim();
              if (code.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập mã phòng')),
                );
                return;
              }
              _joinController.clear();
              Navigator.of(context).pop();

              // 🔹 Thêm vào lịch sử
              setState(() {
                _history.insert(0, {"name": code, "code": code});
              });

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ArenaRoomScreen(
                    roomName: code,
                    roomCode: code,
                    isHost: false,
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
            Text(
              'WORD ARENA',
              style: const TextStyle(
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

            // 🔹 Lịch sử tham gia
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
                        title: Text(item["name"] ?? ""),
                        subtitle: Text("Mã phòng: ${item["code"]}"),
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
