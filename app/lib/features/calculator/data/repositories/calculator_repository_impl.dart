import 'dart:math';
import '../../domain/entities/calculation.dart';
import '../../domain/repositories/calculator_repository.dart';
import '../../../../core/utils/calculator.dart';

/// Calculator Repository 구현체
class CalculatorRepositoryImpl implements CalculatorRepository {
  final List<Calculation> _calculations = [];

  @override
  Future<Calculation> calculate({
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
        throw ArgumentError('지원하지 않는 연산입니다: $operation');
    }

    // 계산 결과 생성
    final calculation = Calculation(
      id: _generateId(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      firstNumber: firstNumber,
      secondNumber: secondNumber,
      operation: operation,
      result: result,
    );

    // 메모리에 저장
    _calculations.add(calculation);

    return calculation;
  }

  @override
  Future<List<Calculation>> getCalculationHistory() async {
    return List.unmodifiable(_calculations);
  }

  @override
  Future<void> saveCalculation(Calculation calculation) async {
    _calculations.add(calculation);
  }

  @override
  Future<void> deleteCalculation(String id) async {
    _calculations.removeWhere((calc) => calc.id == id);
  }

  /// ID 생성
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(1000).toString();
  }
} 