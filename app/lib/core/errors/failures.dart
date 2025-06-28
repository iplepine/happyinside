/// 앱 전체에서 사용하는 에러 타입들
abstract class Failure {
  final String message;
  const Failure(this.message);
  
  @override
  String toString() => message;
}

/// 서버 관련 에러
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

/// 네트워크 관련 에러
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

/// 캐시 관련 에러
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

/// 인증 관련 에러
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

/// 유효성 검사 에러
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
} 