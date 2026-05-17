import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chatbuddy_app/presentation/auth/auth_screen.dart';
import 'package:chatbuddy_app/presentation/main_screen.dart';
import 'package:chatbuddy_app/presentation/profile/profile_screen.dart';
import 'package:chatbuddy_app/presentation/settings/settings_screen.dart';
import 'package:chatbuddy_app/presentation/learning/learning_screen.dart';
import 'package:chatbuddy_app/presentation/statistic/statistic_screen.dart';
import '../../state/auth_notifier.dart';
import '../../state/auth_state.dart';

/// Chỉ refresh redirect khi auth đổi, không tạo lại GoRouter (tránh mất SnackBar / lỗi UI).
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }
}

final _routerRefreshNotifierProvider = Provider<_RouterRefreshNotifier>((ref) {
  return _RouterRefreshNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(_routerRefreshNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'learning',
            builder: (context, state) => const LearningScreen(),
          ),
          GoRoute(
            path: 'statistic',
            builder: (context, state) => const StatisticScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggingIn = state.uri.toString() == '/login';
      final isAuthenticated = authState.isAuthenticated;

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }
      if (isAuthenticated && isLoggingIn) {
        return '/main';
      }
      return null;
    },
  );
});
