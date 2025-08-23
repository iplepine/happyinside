import 'package:flutter/foundation.dart';

/// 사용자 세션 정보를 관리하는 모델
class Session extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _accessToken;
  DateTime? _loginTime;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get accessToken => _accessToken;
  DateTime? get loginTime => _loginTime;

  /// 로그인 처리
  Future<bool> login({required String email, required String password}) async {
    try {
      // TODO: 실제 API 호출로 대체
      await Future.delayed(const Duration(seconds: 1)); // 시뮬레이션

      // 로그인 성공 시뮬레이션
      _isLoggedIn = true;
      _userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      _userName = '사용자';
      _userEmail = email;
      _accessToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
      _loginTime = DateTime.now();

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login failed: $e');
      return false;
    }
  }

  /// 로그아웃 처리
  Future<void> logout() async {
    try {
      // TODO: 실제 로그아웃 API 호출로 대체
      await Future.delayed(const Duration(milliseconds: 500)); // 시뮬레이션

      // 세션 정보 초기화
      _isLoggedIn = false;
      _userId = null;
      _userName = null;
      _userEmail = null;
      _accessToken = null;
      _loginTime = null;

      notifyListeners();
    } catch (e) {
      debugPrint('Logout failed: $e');
    }
  }

  /// 세션 정보 업데이트
  void updateSession({String? userName, String? userEmail}) {
    if (userName != null) _userName = userName;
    if (userEmail != null) _userEmail = userEmail;
    notifyListeners();
  }

  /// 토큰 갱신
  void refreshToken(String newToken) {
    _accessToken = newToken;
    notifyListeners();
  }

  /// 세션 유효성 검사
  bool get isSessionValid {
    if (!_isLoggedIn || _accessToken == null) return false;

    // 토큰 만료 시간 체크 (예: 24시간)
    if (_loginTime != null) {
      final now = DateTime.now();
      final difference = now.difference(_loginTime!);
      return difference.inHours < 24;
    }

    return false;
  }

  /// 세션 정보 초기화 (앱 시작 시)
  void initialize() {
    // TODO: 저장된 세션 정보 복원
    // SharedPreferences나 다른 저장소에서 세션 정보를 불러와서 초기화
    debugPrint('Session initialized');
  }
}
