import 'package:go_router/go_router.dart';
import '../../features/happy_record/presentation/write/write_page.dart';
import '../../features/home/presentation/home_page.dart';

/// 앱 라우터
class AppRouter {
  /// GoRouter 인스턴스
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/write',
        builder: (context, state) {
          final score = state.extra as int?;
          return WritePage(initialScore: score);
        },
      ),
    ],
  );
}
