import 'package:get_it/get_it.dart';

/// 의존성 주입 설정
class Injection {
  static final GetIt _getIt = GetIt.instance;

  /// 의존성 초기화
  static Future<void> init() async {
    // Core
    // 여기에 core 의존성만 남깁니다. 필요시 추가.
  }

  /// GetIt 인스턴스 반환
  static GetIt get getIt => _getIt;
} 