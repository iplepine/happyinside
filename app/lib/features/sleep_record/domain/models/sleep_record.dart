import 'package:equatable/equatable.dart';

class SleepRecord extends Equatable {
  final String id;
  final DateTime sleepTime;
  final DateTime wakeTime;
  final int freshness;
  final int? fatigue; // Nullable로 변경
  final int sleepSatisfaction;
  final String? content;
  final String? disruptionFactors;
  final DateTime createdAt;

  const SleepRecord({
    required this.id,
    required this.sleepTime,
    required this.wakeTime,
    required this.freshness,
    this.fatigue, // Nullable로 변경
    required this.sleepSatisfaction,
    this.content,
    this.disruptionFactors,
    required this.createdAt,
  });

  double get totalSleepHours {
    return wakeTime.difference(sleepTime).inMinutes / 60.0;
  }

  double get averageScore {
    final scores = [freshness, sleepSatisfaction];
    if (fatigue != null) {
      // 피로도는 부정적인 의미이므로, 11에서 빼서 긍정적인 점수로 변환 (10 -> 1, 1 -> 10)
      scores.add(11 - fatigue!);
    }
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  SleepRecord copyWith({
    String? id,
    DateTime? sleepTime,
    DateTime? wakeTime,
    int? freshness,
    int? fatigue,
    int? sleepSatisfaction,
    String? content,
    String? disruptionFactors,
    DateTime? createdAt,
  }) {
    return SleepRecord(
      id: id ?? this.id,
      sleepTime: sleepTime ?? this.sleepTime,
      wakeTime: wakeTime ?? this.wakeTime,
      freshness: freshness ?? this.freshness,
      fatigue: fatigue ?? this.fatigue,
      sleepSatisfaction: sleepSatisfaction ?? this.sleepSatisfaction,
      content: content ?? this.content,
      disruptionFactors: disruptionFactors ?? this.disruptionFactors,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
