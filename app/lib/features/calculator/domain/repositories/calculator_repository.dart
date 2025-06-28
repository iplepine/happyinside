import '../entities/calculation.dart';
import '../../../../core/errors/failures.dart';

/// 계산기 리포지토리 인터페이스
abstract class CalculatorRepository {
  /// 계산 수행
  Future<Calculation> calculate({
    required double firstNumber,
    required double secondNumber,
    required String operation,
  });

  /// 계산 기록 가져오기
  Future<List<Calculation>> getCalculationHistory();

  /// 계산 기록 저장
  Future<void> saveCalculation(Calculation calculation);

  /// 계산 기록 삭제
  Future<void> deleteCalculation(String id);
} 