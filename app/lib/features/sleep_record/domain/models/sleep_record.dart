import 'package:equatable/equatable.dart';

class SleepRecord extends Equatable {
  final String id;
  final DateTime sleepTime;
  final DateTime wakeTime;
  final int freshness;
  final int fatigue;
  final int sleepSatisfaction;
  final String? content;
  final String? disruptionFactors;
  final DateTime createdAt;

  const SleepRecord({
    required this.id,
    required this.sleepTime,
    required this.wakeTime,
    required this.freshness,
    required this.fatigue,
    required this.sleepSatisfaction,
    this.content,
    this.disruptionFactors,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    sleepTime,
    wakeTime,
    freshness,
    fatigue,
    sleepSatisfaction,
    content,
    disruptionFactors,
    createdAt,
  ];
}
