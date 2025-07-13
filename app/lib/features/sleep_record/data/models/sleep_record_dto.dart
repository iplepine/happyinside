import 'package:hive/hive.dart';

part 'sleep_record_dto.g.dart';

@HiveType(typeId: 3)
class SleepRecordDto {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime sleepTime;

  @HiveField(2)
  final DateTime wakeTime;

  @HiveField(3)
  final int freshness;

  @HiveField(4)
  final int sleepSatisfaction;

  @HiveField(5)
  final String? disruptionFactors;

  @HiveField(6)
  final int? fatigue;

  @HiveField(7)
  final String? content;

  @HiveField(8)
  final DateTime createdAt;

  SleepRecordDto({
    required this.id,
    required this.sleepTime,
    required this.wakeTime,
    required this.freshness,
    required this.sleepSatisfaction,
    this.disruptionFactors,
    this.fatigue,
    this.content,
    required this.createdAt,
  });
}
