import 'package:flutter_test/flutter_test.dart';
import 'package:happyinside/features/sleep_record/domain/models/sleep_record.dart';

void main() {
  group('SleepRecord', () {
    late SleepRecord sleepRecord;

    setUp(() {
      sleepRecord = SleepRecord(
        id: '1',
        sleepTime: DateTime(2024, 1, 1, 22, 0),
        wakeTime: DateTime(2024, 1, 2, 7, 0),
        freshness: 8,
        fatigue: 3,
        sleepSatisfaction: 7,
        content: '좋은 잠을 잤다',
        disruptionFactors: '커피',
        createdAt: DateTime(2024, 1, 2),
      );
    });

    group('생성자', () {
      test('모든 필수 필드가 올바르게 설정되어야 한다', () {
        expect(sleepRecord.id, '1');
        expect(sleepRecord.sleepTime, DateTime(2024, 1, 1, 22, 0));
        expect(sleepRecord.wakeTime, DateTime(2024, 1, 2, 7, 0));
        expect(sleepRecord.freshness, 8);
        expect(sleepRecord.fatigue, 3);
        expect(sleepRecord.sleepSatisfaction, 7);
        expect(sleepRecord.content, '좋은 잠을 잤다');
        expect(sleepRecord.disruptionFactors, '커피');
        expect(sleepRecord.createdAt, DateTime(2024, 1, 2));
      });

      test('nullable 필드가 null일 수 있어야 한다', () {
        final recordWithNulls = SleepRecord(
          id: '2',
          sleepTime: DateTime(2024, 1, 1, 22, 0),
          wakeTime: DateTime(2024, 1, 2, 7, 0),
          freshness: 8,
          sleepSatisfaction: 7,
          createdAt: DateTime(2024, 1, 2),
        );

        expect(recordWithNulls.fatigue, isNull);
        expect(recordWithNulls.content, isNull);
        expect(recordWithNulls.disruptionFactors, isNull);
      });
    });

    group('totalSleepHours', () {
      test('수면 시간이 올바르게 계산되어야 한다', () {
        // 22:00 ~ 07:00 = 9시간
        expect(sleepRecord.totalSleepHours, 9.0);
      });

      test('부분 시간도 올바르게 계산되어야 한다', () {
        final partialSleepRecord = SleepRecord(
          id: '3',
          sleepTime: DateTime(2024, 1, 1, 23, 30),
          wakeTime: DateTime(2024, 1, 2, 6, 30),
          freshness: 8,
          sleepSatisfaction: 7,
          createdAt: DateTime(2024, 1, 2),
        );

        // 23:30 ~ 06:30 = 7시간
        expect(partialSleepRecord.totalSleepHours, 7.0);
      });
    });

    group('averageScore', () {
      test('모든 점수가 있을 때 평균이 올바르게 계산되어야 한다', () {
        // freshness: 8, sleepSatisfaction: 7, fatigue: 3 (11-3=8)
        // (8 + 7 + 8) / 3 = 7.67
        expect(sleepRecord.averageScore, closeTo(7.67, 0.01));
      });

      test('fatigue가 null일 때 올바르게 계산되어야 한다', () {
        final recordWithoutFatigue = SleepRecord(
          id: '4',
          sleepTime: DateTime(2024, 1, 1, 22, 0),
          wakeTime: DateTime(2024, 1, 2, 7, 0),
          freshness: 8,
          sleepSatisfaction: 7,
          createdAt: DateTime(2024, 1, 2),
        );

        // freshness: 8, sleepSatisfaction: 7
        // (8 + 7) / 2 = 7.5
        expect(recordWithoutFatigue.averageScore, 7.5);
      });
    });

    group('copyWith', () {
      test('일부 필드만 변경할 수 있어야 한다', () {
        final updatedRecord = sleepRecord.copyWith(
          freshness: 9,
          content: '더 좋은 잠을 잤다',
        );

        expect(updatedRecord.id, sleepRecord.id);
        expect(updatedRecord.sleepTime, sleepRecord.sleepTime);
        expect(updatedRecord.wakeTime, sleepRecord.wakeTime);
        expect(updatedRecord.freshness, 9);
        expect(updatedRecord.fatigue, sleepRecord.fatigue);
        expect(updatedRecord.sleepSatisfaction, sleepRecord.sleepSatisfaction);
        expect(updatedRecord.content, '더 좋은 잠을 잤다');
        expect(updatedRecord.disruptionFactors, sleepRecord.disruptionFactors);
        expect(updatedRecord.createdAt, sleepRecord.createdAt);
      });

      test('모든 필드를 변경할 수 있어야 한다', () {
        final base = SleepRecord(
          id: '1',
          sleepTime: DateTime(2024, 1, 1, 22, 0),
          wakeTime: DateTime(2024, 1, 2, 7, 0),
          freshness: 8,
          fatigue: 3,
          sleepSatisfaction: 7,
          content: '좋은 잠을 잤다',
          disruptionFactors: null, // null로 생성
          createdAt: DateTime(2024, 1, 2),
        );
        final newRecord = base.copyWith(
          id: '5',
          sleepTime: DateTime(2024, 1, 2, 23, 0),
          wakeTime: DateTime(2024, 1, 3, 8, 0),
          freshness: 9,
          fatigue: 2,
          sleepSatisfaction: 8,
          content: '완벽한 잠',
          // disruptionFactors: null, // 명시적으로 넘기지 않음
          createdAt: DateTime(2024, 1, 3),
        );

        expect(newRecord.id, '5');
        expect(newRecord.sleepTime, DateTime(2024, 1, 2, 23, 0));
        expect(newRecord.wakeTime, DateTime(2024, 1, 3, 8, 0));
        expect(newRecord.freshness, 9);
        expect(newRecord.fatigue, 2);
        expect(newRecord.sleepSatisfaction, 8);
        expect(newRecord.content, '완벽한 잠');
        expect(newRecord.disruptionFactors, isNull);
        expect(newRecord.createdAt, DateTime(2024, 1, 3));
      });
    });

    group('equality', () {
      test('동일한 필드를 가진 레코드는 같아야 한다', () {
        final sameRecord = SleepRecord(
          id: '1',
          sleepTime: DateTime(2024, 1, 1, 22, 0),
          wakeTime: DateTime(2024, 1, 2, 7, 0),
          freshness: 8,
          fatigue: 3,
          sleepSatisfaction: 7,
          content: '좋은 잠을 잤다',
          disruptionFactors: '커피',
          createdAt: DateTime(2024, 1, 2),
        );

        expect(sleepRecord, equals(sameRecord));
      });

      test('다른 필드를 가진 레코드는 달라야 한다', () {
        final differentRecord = sleepRecord.copyWith(id: '2');
        expect(sleepRecord, isNot(equals(differentRecord)));
      });
    });
  });
}
