/// 모든 엔티티의 기본 클래스
abstract class BaseEntity {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BaseEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  /// JSON으로 변환
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BaseEntity(id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
} 