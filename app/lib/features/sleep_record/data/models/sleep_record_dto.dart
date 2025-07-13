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
  final int? fatigue;

  @HiveField(5)
  final int sleepSatisfaction;

  @HiveField(6)
  final String? content;

  @HiveField(7)
  final String? disruptionFactors;

  @HiveField(8)
  final DateTime createdAt;

  SleepRecordDto({
    required this.id,
    required this.sleepTime,
    required this.wakeTime,
    required this.freshness,
    this.fatigue,
    required this.sleepSatisfaction,
    this.content,
    this.disruptionFactors,
    required this.createdAt,
  });
}
