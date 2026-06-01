import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chatbuddy_app/presentation/auth/auth_screen.dart';
import 'package:chatbuddy_app/presentation/main_screen.dart';
import 'package:chatbuddy_app/presentation/profile/profile_screen.dart';
import 'package:chatbuddy_app/presentation/learning/learning_screen.dart';
import 'package:chatbuddy_app/presentation/splash/splash_screen.dart';
import 'package:chatbuddy_app/presentation/statistic/statistic_screen.dart';
import '../../state/auth_notifier.dart';
import '../../state/auth_state.dart';

const _kSplashMinimumDuration = Duration(milliseconds: 700);

class _SplashDelayNotifier extends StateNotifier<bool> {
  _SplashDelayNotifier() : super(false) {
    Future.delayed(_kSplashMinimumDuration, () {
      state = true;
    });
  }
}

final splashDelayProvider = StateNotifierProvider<_SplashDelayNotifier, bool>(
  (ref) => _SplashDelayNotifier(),
);

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
  final isSplashDelayElapsed = ref.watch(splashDelayProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
      final isSplashRoute = state.uri.toString() == '/splash';
      final isAuthenticated = authState.isAuthenticated;

      if (!authState.isSessionRestored || !isSplashDelayElapsed) {
        return isSplashRoute ? null : '/splash';
      }
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }
      if (isAuthenticated && isLoggingIn) {
        return '/main';
      }
      if (isAuthenticated && isSplashRoute) {
        return '/main';
      }
      if (!isAuthenticated && isSplashRoute) {
        return '/login';
      }
      return null;
    },
  );
});
