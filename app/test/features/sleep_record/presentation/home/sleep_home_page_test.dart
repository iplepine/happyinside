import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zestinme/features/sleep_record/domain/models/sleep_record.dart';
import 'package:zestinme/features/sleep_record/presentation/controller/sleep_home_controller.dart';
import 'package:zestinme/features/sleep_record/presentation/home/sleep_home_page.dart';
import 'package:zestinme/features/sleep_record/presentation/state/sleep_home_state.dart';
import 'package:zestinme/features/sleep_record/presentation/widgets/sleep_history_chart.dart';

class TestSleepHomeController extends StateNotifier<SleepHomeState> {
  TestSleepHomeController() : super(const SleepHomeState.loading());

  void setState(SleepHomeState newState) {
    state = newState;
  }
}

void main() {
  late TestSleepHomeController testController;
  late ProviderContainer container;

  setUp(() {
    testController = TestSleepHomeController();

    container = ProviderContainer(
      overrides: [
        sleepHomeControllerProvider.overrideWith(
          (ref) => testController as SleepHomeController,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SleepHomePage', () {
    testWidgets('로딩 상태일 때 CircularProgressIndicator를 표시한다', (tester) async {
      // Given
      testController.setState(const SleepHomeState.loading());

      // When
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: SleepHomePage()),
        ),
      );

      // Then
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('데이터 상태일 때 SleepHistoryChart를 표시한다', (tester) async {
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

      testController.setState(SleepHomeState.data(mockRecords));

      // When
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: SleepHomePage()),
        ),
      );

      // Then
      expect(find.byType(SleepHistoryChart), findsOneWidget);
    });

    testWidgets('에러 상태일 때 에러 메시지를 표시한다', (tester) async {
      // Given
      testController.setState(const SleepHomeState.error('테스트 에러'));

      // When
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: SleepHomePage()),
        ),
      );

      // Then
      expect(find.text('Error: 테스트 에러'), findsOneWidget);
    });

    testWidgets('AppBar에 올바른 제목이 표시된다', (tester) async {
      // Given
      testController.setState(const SleepHomeState.loading());

      // When
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: SleepHomePage()),
        ),
      );

      // Then
      expect(find.text('Sleep Tracker'), findsOneWidget);
    });

    testWidgets('Scaffold이 올바르게 렌더링된다', (tester) async {
      // Given
      testController.setState(const SleepHomeState.loading());

      // When
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: const MaterialApp(home: SleepHomePage()),
        ),
      );

      // Then
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
