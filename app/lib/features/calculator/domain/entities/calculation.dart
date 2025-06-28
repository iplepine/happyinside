import '../../../../core/models/base_entity.dart';

/// 계산 결과 엔티티
class Calculation extends BaseEntity {
  final double firstNumber;
  final double secondNumber;
  final String operation;
  final double result;

  const Calculation({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.firstNumber,
    required this.secondNumber,
    required this.operation,
    required this.result,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'first_number': firstNumber,
      'second_number': secondNumber,
      'operation': operation,
      'result': result,
    };
  }

  factory Calculation.fromJson(Map<String, dynamic> json) {
    return Calculation(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      firstNumber: (json['first_number'] as num).toDouble(),
      secondNumber: (json['second_number'] as num).toDouble(),
      operation: json['operation'] as String,
      result: (json['result'] as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Calculation(id: $id, $firstNumber $operation $secondNumber = $result)';
  }
} 