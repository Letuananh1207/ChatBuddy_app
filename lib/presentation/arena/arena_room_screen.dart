import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'arena_start_match_screen.dart';

class ArenaRoomScreen extends StatelessWidget {
  final String roomName;
  final String roomCode;
  final bool isHost;

  const ArenaRoomScreen({
    super.key,
    required this.roomName,
    required this.roomCode,
    this.isHost = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.indigo),
        title: Text(
          'Phòng: $roomName',
          style: const TextStyle(
              color: AppColors.darkText, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
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
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        Chip(label: Text('Bạn')),
                        Chip(label: Text('Minh')),
                        Chip(label: Text('Lan')),
                        Chip(label: Text('Anh')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Mã phòng',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                    Text(
                      roomCode,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.indigo,
                      ),
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
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Text(
                        'Nội dung phòng',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Nội dung của người phần chơi sẽ dựa vào các bộ từ vựng của các thành viên trong phòng. Trong trường hợp không có thì sẽ sử dụng bộ từ vựng ngẫu nhiên.',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                if (isHost) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ArenaStartMatchScreen(
                        roomName: roomName,
                        roomCode: roomCode,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Đang chờ chủ phòng bắt đầu...')),
                  );
                }
              },
              child: Text(
                isHost ? 'Bắt đầu trận đấu' : 'Chờ chủ phòng',
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
