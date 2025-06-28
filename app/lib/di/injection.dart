import 'package:get_it/get_it.dart';
import '../core/network/api_client.dart';
import '../features/calculator/domain/repositories/calculator_repository.dart';
import '../features/calculator/domain/usecases/calculate_usecase.dart';
import '../features/calculator/data/repositories/calculator_repository_impl.dart';

/// 의존성 주입 설정
class Injection {
  static final GetIt _getIt = GetIt.instance;

  /// 의존성 초기화
  static Future<void> init() async {
    // Core
    _getIt.registerLazySingleton<ApiClient>(
      () => ApiClient(client: _getIt()),
    );

    // Features
    _initCalculator();
  }

  /// Calculator Feature 의존성 초기화
  static void _initCalculator() {
    // Repository
    _getIt.registerLazySingleton<CalculatorRepository>(
      () => CalculatorRepositoryImpl(),
    );

    // Use Cases
    _getIt.registerLazySingleton(
      () => CalculateUseCase(_getIt()),
    );
  }

  /// GetIt 인스턴스 반환
  static GetIt get getIt => _getIt;
} 