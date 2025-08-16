import 'package:flutter_test/flutter_test.dart';
import 'package:zestinme/features/sleep_record/domain/models/sleep_record.dart';
import 'package:zestinme/features/sleep_record/domain/usecases/get_sleep_records_usecase.dart';
import 'package:zestinme/features/sleep_record/presentation/controller/sleep_home_controller.dart';
import 'package:zestinme/features/sleep_record/presentation/state/sleep_home_state.dart';

class MockGetSleepRecordsUseCase implements GetSleepRecordsUseCase {
  final List<SleepRecord>? recordsToReturn;
  final Exception? exceptionToThrow;

  MockGetSleepRecordsUseCase({this.recordsToReturn, this.exceptionToThrow});

  @override
  Future<List<SleepRecord>> call(DateTime startDate, DateTime endDate) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return recordsToReturn ?? [];
  }
}

void main() {
  group('SleepHomeController', () {
    late SleepHomeController controller;
    late MockGetSleepRecordsUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockGetSleepRecordsUseCase();
      controller = SleepHomeController(mockUseCase);
    });

    group('초기화', () {
      test('초기화 시 fetchRecords가 호출되어야 한다', () async {
        // Given
        final mockRecords = [
          SleepRecord(
            id: '1',
            sleepTime: DateTime(2024, 1, 1, 22, 0),
            wakeTime: DateTime(2024, 1, 2, 7, 0),
            freshness: 8,
            fatigue: 3,
            sleepSatisfaction: 7,
            content: '좋은 잠을 잤다',
            disruptionFactors: null,
            createdAt: DateTime(2024, 1, 2),
          ),
        ];

        mockUseCase = MockGetSleepRecordsUseCase(recordsToReturn: mockRecords);
        controller = SleepHomeController(mockUseCase);

        // When
        await Future.delayed(const Duration(milliseconds: 100));

        // Then
        expect(controller.state, SleepHomeState.data(mockRecords));
      });

      test('초기화 시 fetchRecords가 호출되어야 한다', () async {
        // Given
        final mockRecords = [
          SleepRecord(
            id: '1',
            sleepTime: DateTime(2024, 1, 1, 22, 0),
            wakeTime: DateTime(2024, 1, 2, 7, 0),
            freshness: 8,
            fatigue: 3,
            sleepSatisfaction: 7,
            content: '좋은 잠을 잤다',
            disruptionFactors: null,
            createdAt: DateTime(2024, 1, 2),
          ),
        ];

        mockUseCase = MockGetSleepRecordsUseCase(recordsToReturn: mockRecords);
        controller = SleepHomeController(mockUseCase);

        // When
        await Future.delayed(const Duration(milliseconds: 100));

        // Then
        expect(controller.state, SleepHomeState.data(mockRecords));
      });
    });

    group('fetchRecords', () {
      test('성공적으로 데이터를 가져오면 data 상태가 되어야 한다', () async {
        // Given
        final mockRecords = [
          SleepRecord(
            id: '1',
            sleepTime: DateTime(2024, 1, 1, 22, 0),
            wakeTime: DateTime(2024, 1, 2, 7, 0),
            freshness: 8,
            fatigue: 3,
            sleepSatisfaction: 7,
            content: '좋은 잠을 잤다',
            disruptionFactors: null,
            createdAt: DateTime(2024, 1, 2),
          ),
        ];

        mockUseCase = MockGetSleepRecordsUseCase(recordsToReturn: mockRecords);
        controller = SleepHomeController(mockUseCase);

        // When
        await Future.delayed(const Duration(milliseconds: 100));

        // Then
        expect(controller.state, SleepHomeState.data(mockRecords));
      });

      test('에러가 발생하면 error 상태가 되어야 한다', () async {
        // Given
        final exception = Exception('테스트 에러');
        mockUseCase = MockGetSleepRecordsUseCase(exceptionToThrow: exception);
        controller = SleepHomeController(mockUseCase);

        // When
        await Future.delayed(const Duration(milliseconds: 100));

        // Then
        expect(controller.state, SleepHomeState.error(exception.toString()));
      });

      test('빈 리스트를 반환하면 data 상태에 빈 리스트가 있어야 한다', () async {
        // Given
        mockUseCase = MockGetSleepRecordsUseCase(recordsToReturn: []);
        controller = SleepHomeController(mockUseCase);

        // When
        await Future.delayed(const Duration(milliseconds: 100));

        // Then
        expect(controller.state, const SleepHomeState.data([]));
      });
    });
  });
}
