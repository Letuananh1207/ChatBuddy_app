import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    UserModel? user,
    String? token,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool isAuthenticated,
    @Default(false) bool isSessionRestored,
  }) = _AuthState;
}
