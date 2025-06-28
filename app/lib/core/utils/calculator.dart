/// 간단한 계산기 유틸리티 클래스
class Calculator {
  /// 두 숫자를 더합니다
  static int add(int a, int b) {
    return a + b;
  }

  /// 두 숫자를 뺍니다
  static int subtract(int a, int b) {
    return a - b;
  }

  /// 두 숫자를 곱합니다
  static int multiply(int a, int b) {
    return a * b;
  }

  /// 두 숫자를 나눕니다
  /// b가 0인 경우 예외를 발생시킵니다
  static double divide(int a, int b) {
    if (b == 0) {
      throw ArgumentError('0으로 나눌 수 없습니다');
    }
    return a / b;
  }

  /// 숫자가 짝수인지 확인합니다
  static bool isEven(int number) {
    return number % 2 == 0;
  }

  /// 숫자가 홀수인지 확인합니다
  static bool isOdd(int number) {
    return number % 2 != 0;
  }

  /// 팩토리얼을 계산합니다
  static int factorial(int n) {
    if (n < 0) {
      throw ArgumentError('음수의 팩토리얼은 계산할 수 없습니다');
    }
    if (n == 0 || n == 1) {
      return 1;
    }
    return n * factorial(n - 1);
  }
} 