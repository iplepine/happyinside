import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happyinside/features/sleep_record/domain/models/sleep_record.dart';
import 'package:happyinside/features/sleep_record/domain/usecases/get_sleep_records_usecase.dart';
import 'package:happyinside/features/sleep_record/presentation/controller/sleep_home_controller.dart';
import 'package:happyinside/features/sleep_record/presentation/home/sleep_home_page.dart';
import 'package:happyinside/features/sleep_record/presentation/state/sleep_home_state.dart';

class TestGetSleepRecordsUseCase implements GetSleepRecordsUseCase {
  final List<SleepRecord>? recordsToReturn;
  final Exception? exceptionToThrow;
  final Duration delay;

  TestGetSleepRecordsUseCase({
    this.recordsToReturn,
    this.exceptionToThrow,
    this.delay = Duration.zero,
  });

  @override
  Future<List<SleepRecord>> call(DateTime startDate, DateTime endDate) async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }

    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }

    return recordsToReturn ?? [];
  }
}

void main() {
  group('SleepHomePage Integration Tests', () {
    late TestGetSleepRecordsUseCase testUseCase;
    late ProviderContainer container;

    setUp(() {
      testUseCase = TestGetSleepRecordsUseCase();

      container = ProviderContainer(
        overrides: [
          sleepHomeControllerProvider.overrideWith(
            (ref) => SleepHomeController(testUseCase),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('전체 플로우', () {
      testWidgets('로딩부터 데이터 표시까지의 전체 플로우를 테스트한다', (tester) async {
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

        testUseCase = TestGetSleepRecordsUseCase(
          recordsToReturn: mockRecords,
          delay: const Duration(milliseconds: 100),
        );

        container = ProviderContainer(
          overrides: [
            sleepHomeControllerProvider.overrideWith(
              (ref) => SleepHomeController(testUseCase),
            ),
          ],
        );

        // When - 초기 렌더링
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: const MaterialApp(home: SleepHomePage()),
          ),
        );

        // Then - 로딩 상태 확인
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // When - 데이터 로딩 완료 대기
        await tester.pump(const Duration(milliseconds: 150));

        // Then - 데이터 상태 확인
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Sleep Tracker'), findsOneWidget);
      });

      testWidgets('에러 발생 시 에러 메시지가 표시된다', (tester) async {
        // Given
        testUseCase = TestGetSleepRecordsUseCase(
          exceptionToThrow: Exception('테스트 에러'),
          delay: const Duration(milliseconds: 100),
        );

        container = ProviderContainer(
          overrides: [
            sleepHomeControllerProvider.overrideWith(
              (ref) => SleepHomeController(testUseCase),
            ),
          ],
        );

        // When
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: const MaterialApp(home: SleepHomePage()),
          ),
        );

        // Then - 로딩 상태 확인
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // When - 에러 발생 대기
        await tester.pump(const Duration(milliseconds: 150));

        // Then - 에러 상태 확인
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Error: Exception: 테스트 에러'), findsOneWidget);
      });

      testWidgets('빈 데이터일 때 차트가 올바르게 표시된다', (tester) async {
        // Given
        testUseCase = TestGetSleepRecordsUseCase(
          recordsToReturn: [],
          delay: const Duration(milliseconds: 100),
        );

        container = ProviderContainer(
          overrides: [
            sleepHomeControllerProvider.overrideWith(
              (ref) => SleepHomeController(testUseCase),
            ),
          ],
        );

        // When
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: const MaterialApp(home: SleepHomePage()),
          ),
        );

        // Then - 로딩 상태 확인
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // When - 데이터 로딩 완료 대기
        await tester.pump(const Duration(milliseconds: 150));

        // Then - 빈 데이터 상태 확인
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Sleep Tracker'), findsOneWidget);
      });
    });

    // 여기서는 "작성하기" 버튼에 대해 두 가지 타입의 기록(잠들기 전, 일어난 후)을 드래그 제스처로 구분해서 작성하는 플로우를 테스트해야 해.
    // 즉, 왼쪽으로 드래그하면 "잠들기 전 기록", 오른쪽으로 드래그하면 "일어난 후 기록" 작성 화면으로 이동하는지 확인하는 통합 테스트를 작성할 거야.

    testWidgets('작성하기 버튼을 왼쪽으로 드래그하면 잠들기 전 기록 작성 화면으로 이동한다', (tester) async {
      // Given
      testUseCase = TestGetSleepRecordsUseCase(recordsToReturn: []);
      container = ProviderContainer(
        overrides: [
          sleepHomeControllerProvider.overrideWith(
            (ref) => SleepHomeController(testUseCase),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: SleepHomePage()),
        ),
      );

      // When - "작성하기" 버튼 찾기
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      // "작성하기" 버튼을 왼쪽으로 드래그
      await tester.drag(fabFinder, const Offset(-100, 0));
      await tester.pumpAndSettle();

      // Then - 잠들기 전 기록 작성 화면으로 이동했는지 확인
      // (예시: '잠들기 전 기록'이라는 텍스트가 있는지 확인)
      expect(find.text('잠들기 전 기록'), findsOneWidget);
    });

    testWidgets('작성하기 버튼을 오른쪽으로 드래그하면 일어난 후 기록 작성 화면으로 이동한다', (tester) async {
      // Given
      testUseCase = TestGetSleepRecordsUseCase(recordsToReturn: []);
      container = ProviderContainer(
        overrides: [
          sleepHomeControllerProvider.overrideWith(
            (ref) => SleepHomeController(testUseCase),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: SleepHomePage()),
        ),
      );

      // When - "작성하기" 버튼 찾기
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);

      // "작성하기" 버튼을 오른쪽으로 드래그
      await tester.drag(fabFinder, const Offset(100, 0));
      await tester.pumpAndSettle();

      // Then - 일어난 후 기록 작성 화면으로 이동했는지 확인
      // (예시: '일어난 후 기록'이라는 텍스트가 있는지 확인)
      expect(find.text('일어난 후 기록'), findsOneWidget);
    });

    group('상태 전환', () {
      testWidgets('로딩 상태에서 데이터 상태로 전환된다', (tester) async {
        // Given
        final mockRecords = [
          SleepRecord(
            id: '1',
            sleepTime: DateTime(2024, 1, 1, 22, 0),
            wakeTime: DateTime(2024, 1, 2, 7, 0),
            freshness: 8,
            sleepSatisfaction: 7,
            createdAt: DateTime(2024, 1, 2),
          ),
        ];

        testUseCase = TestGetSleepRecordsUseCase(
          recordsToReturn: mockRecords,
          delay: const Duration(milliseconds: 50),
        );

        container = ProviderContainer(
          overrides: [
            sleepHomeControllerProvider.overrideWith(
              (ref) => SleepHomeController(testUseCase),
            ),
          ],
        );

        // When
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: const MaterialApp(home: SleepHomePage()),
          ),
        );

        // Then - 초기 로딩 상태
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // When - 데이터 로딩 완료
        await tester.pump(const Duration(milliseconds: 100));

        // Then - 데이터 상태
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('Sleep Tracker'), findsOneWidget);
      });
    });
  });
}
