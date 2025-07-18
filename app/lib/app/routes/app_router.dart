import 'package:go_router/go_router.dart';
import '../../features/main/presentation/main_home_page.dart';
import '../../features/happy_record/presentation/write/write_page.dart';
import '../../features/happy_record/presentation/home/happy_home_page.dart';
import '../../features/sleep_record/domain/models/sleep_record.dart';
import '../../features/sleep_record/presentation/home/sleep_home_page.dart';
import '../../features/sleep_record/presentation/sleep_record_page.dart';

/// 앱 라우터
class AppRouter {
  /// GoRouter 인스턴스
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MainHomePage()),
      GoRoute(
        path: '/happy',
        builder: (context, state) => const HappyHomePage(),
      ),
      GoRoute(
        path: '/sleep',
        builder: (context, state) => const SleepHomePage(),
      ),
      GoRoute(
        path: '/sleep-record',
        builder: (context, state) => const SleepRecordPage(),
      ),
      GoRoute(
        path: '/sleep-record-update',
        builder: (context, state) {
          final record = state.extra as SleepRecord?;
          return SleepRecordPage(initialRecord: record);
        },
      ),
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
