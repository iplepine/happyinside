import 'package:flutter_test/flutter_test.dart';
import 'package:happyinside/core/utils/calculator.dart';

void main() {
  group('Calculator Tests', () {
    group('add', () {
      test('should add two positive numbers correctly', () {
        final result1 = Calculator.add(2, 3);
        final result2 = Calculator.add(10, 20);
        
        print('Calculator.add(2, 3) = $result1');
        print('Calculator.add(10, 20) = $result2');
        
        expect(result1, equals(5));
        expect(result2, equals(30));
      });

      test('should add negative numbers correctly', () {
        expect(Calculator.add(-2, -3), equals(-5));
        expect(Calculator.add(-10, 5), equals(-5));
      });

      test('should add zero correctly', () {
        expect(Calculator.add(5, 0), equals(5));
        expect(Calculator.add(0, 5), equals(5));
      });
    });

    group('subtract', () {
      test('should subtract two positive numbers correctly', () {
        expect(Calculator.subtract(5, 3), equals(2));
        expect(Calculator.subtract(10, 7), equals(3));
      });

      test('should subtract negative numbers correctly', () {
        expect(Calculator.subtract(5, -3), equals(8));
        expect(Calculator.subtract(-5, -3), equals(-2));
      });

      test('should subtract zero correctly', () {
        expect(Calculator.subtract(5, 0), equals(5));
        expect(Calculator.subtract(0, 5), equals(-5));
      });
    });

    group('multiply', () {
      test('should multiply two positive numbers correctly', () {
        expect(Calculator.multiply(2, 3), equals(6));
        expect(Calculator.multiply(5, 4), equals(20));
      });

      test('should multiply with negative numbers correctly', () {
        expect(Calculator.multiply(2, -3), equals(-6));
        expect(Calculator.multiply(-2, -3), equals(6));
      });

      test('should multiply with zero correctly', () {
        expect(Calculator.multiply(5, 0), equals(0));
        expect(Calculator.multiply(0, 5), equals(0));
      });
    });

    group('divide', () {
      test('should divide two positive numbers correctly', () {
        expect(Calculator.divide(6, 2), equals(3.0));
        expect(Calculator.divide(10, 3), closeTo(3.333, 0.001));
      });

      test('should divide with negative numbers correctly', () {
        expect(Calculator.divide(6, -2), equals(-3.0));
        expect(Calculator.divide(-6, -2), equals(3.0));
      });

      test('should throw ArgumentError when dividing by zero', () {
        expect(() => Calculator.divide(5, 0), throwsArgumentError);
        expect(() => Calculator.divide(0, 0), throwsArgumentError);
      });
    });

    group('isEven', () {
      test('should return true for even numbers', () {
        expect(Calculator.isEven(2), isTrue);
        expect(Calculator.isEven(0), isTrue);
        expect(Calculator.isEven(-4), isTrue);
      });

      test('should return false for odd numbers', () {
        expect(Calculator.isEven(1), isFalse);
        expect(Calculator.isEven(3), isFalse);
        expect(Calculator.isEven(-5), isFalse);
      });
    });

    group('isOdd', () {
      test('should return true for odd numbers', () {
        expect(Calculator.isOdd(1), isTrue);
        expect(Calculator.isOdd(3), isTrue);
        expect(Calculator.isOdd(-5), isTrue);
      });

      test('should return false for even numbers', () {
        expect(Calculator.isOdd(2), isFalse);
        expect(Calculator.isOdd(0), isFalse);
        expect(Calculator.isOdd(-4), isFalse);
      });
    });

    group('factorial', () {
      test('should calculate factorial correctly for positive numbers', () {
        expect(Calculator.factorial(0), equals(1));
        expect(Calculator.factorial(1), equals(1));
        expect(Calculator.factorial(5), equals(120));
        expect(Calculator.factorial(3), equals(6));
      });

      test('should throw ArgumentError for negative numbers', () {
        expect(() => Calculator.factorial(-1), throwsArgumentError);
        expect(() => Calculator.factorial(-5), throwsArgumentError);
      });
    });
  });
} 