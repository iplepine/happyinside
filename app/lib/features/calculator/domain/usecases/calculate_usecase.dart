import '../entities/calculation.dart';
import '../repositories/calculator_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/calculator.dart';

/// 계산 유스케이스
class CalculateUseCase {
  final CalculatorRepository repository;

  CalculateUseCase(this.repository);

  /// 계산 수행
  Future<Calculation> execute({
    required double firstNumber,
    required double secondNumber,
    required String operation,
  }) async {
    // Core의 Calculator 유틸리티 사용
    double result;
    switch (operation) {
      case '+':
        result = Calculator.add(firstNumber.toInt(), secondNumber.toInt()).toDouble();
        break;
      case '-':
        result = Calculator.subtract(firstNumber.toInt(), secondNumber.toInt()).toDouble();
        break;
      case '*':
        result = Calculator.multiply(firstNumber.toInt(), secondNumber.toInt()).toDouble();
        break;
      case '/':
        result = Calculator.divide(firstNumber.toInt(), secondNumber.toInt());
        break;
      default:
        throw ValidationFailure('지원하지 않는 연산입니다: $operation');
    }

    // 계산 결과를 리포지토리를 통해 저장
    final calculation = await repository.calculate(
      firstNumber: firstNumber,
      secondNumber: secondNumber,
      operation: operation,
    );

    return calculation;
  }
} 