import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session.dart';

/// Session Provider
final sessionProvider = ChangeNotifierProvider<Session>((ref) {
  final session = Session();
  session.initialize();
  return session;
});

/// 로그인 상태만을 반환하는 Provider
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(sessionProvider).isLoggedIn;
});

/// 사용자 이름을 반환하는 Provider
final userNameProvider = Provider<String?>((ref) {
  return ref.watch(sessionProvider).userName;
});

/// 세션 유효성을 반환하는 Provider
final sessionValidProvider = Provider<bool>((ref) {
  return ref.watch(sessionProvider).isSessionValid;
});
