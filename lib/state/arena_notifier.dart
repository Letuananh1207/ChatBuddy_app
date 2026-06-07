import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/arena_repository.dart';
import '../data/services/api_service.dart';
import 'arena_state.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

final arenaNotifierProvider =
    StateNotifierProvider.family<ArenaNotifier, ArenaState, String?>((ref, _) {
  final arenaRepository = ref.watch(arenaRepositoryProvider);
  final apiService = ref.watch(apiServiceProvider);
  final authState = ref.watch(authProvider);
  return ArenaNotifier(
    arenaRepository,
    apiService,
    authState,
  );
});

class ArenaNotifier extends StateNotifier<ArenaState> {
  final ArenaRepository _arenaRepository;
  final ApiService _apiService;
  final AuthState _authState;

  Timer? _pollingTimer;

  ArenaNotifier(this._arenaRepository, this._apiService, this._authState)
      : super(const ArenaState());

  void _ensureAuthToken() {
    if (_authState.token != null && _authState.token!.isNotEmpty) {
      _apiService.setAuthToken(_authState.token);
    }
  }

  Future<void> createRoom() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _ensureAuthToken();

    final room = await _arenaRepository.createRoom();
    if (room != null) {
      state = state.copyWith(room: room, isLoading: false);
      _startPolling(room.code);
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tạo phòng. Kiểm tra kết nối và đăng nhập.',
      );
    }
  }

  Future<void> joinRoom(String code) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _ensureAuthToken();

    final room = await _arenaRepository.joinRoom(code);
    if (room != null) {
      state = state.copyWith(room: room, isLoading: false);
      _startPolling(code);
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tham gia phòng. Kiểm tra mã phòng và kết nối.',
      );
    }
  }

  Future<void> fetchRoom(String code) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _ensureAuthToken();

    final room = await _arenaRepository.getRoom(code);
    if (room != null) {
      state = state.copyWith(room: room, isLoading: false);
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tải thông tin phòng.',
      );
    }
  }

  Future<void> setReady(String code, bool ready) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    _ensureAuthToken();

    final updatedRoom = await _arenaRepository.setReady(code, ready);
    if (updatedRoom != null) {
      state = state.copyWith(room: updatedRoom, isLoading: false);

      // Nếu trạng thái là running, tự động bắt đầu polling
      if (updatedRoom.status == 'running') {
        _startPolling(code);
      }
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Không thể cập nhật trạng thái sẵn sàng. Thử lại sau.',
      );
    }
  }

  Future<void> sendAnswer(
    String code,
    int questionIndex,
    String answer,
    int duration,
  ) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    _ensureAuthToken();

    final updatedRoom = await _arenaRepository.sendAnswer(
      code,
      questionIndex: questionIndex,
      answer: answer,
      duration: duration,
    );

    if (updatedRoom != null) {
      state = state.copyWith(room: updatedRoom, isSubmitting: false);
    } else {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Không gửi được câu trả lời. Thử lại sau.',
      );
    }
  }

  Future<void> leaveRoom(String code) async {
    _ensureAuthToken();
    await _arenaRepository.leaveRoom(code);
    _stopPolling();
    state = const ArenaState();
  }

  void _startPolling(String code) {
    _stopPolling();
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      _ensureAuthToken();
      final room = await _arenaRepository.getRoom(code);
      if (room != null) {
        state = state.copyWith(room: room);
      }
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
}
