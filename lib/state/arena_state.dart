import '../data/models/arena_models.dart';

class ArenaState {
  final ArenaRoom? room;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final int elapsedSeconds;

  const ArenaState({
    this.room,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.elapsedSeconds = 0,
  });

  ArenaState copyWith({
    ArenaRoom? room,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    int? elapsedSeconds,
  }) {
    return ArenaState(
      room: room ?? this.room,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }
}
