import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happyinside/di/injection.dart';
import '../../domain/models/sleep_record.dart';
import '../../domain/usecases/get_sleep_records_usecase.dart';
import 'sleep_home_state.dart';

final sleepHomeControllerProvider =
    StateNotifierProvider<SleepHomeController, SleepHomeState>(
      (ref) => SleepHomeController(Injection.getIt<GetSleepRecordsUseCase>()),
    );

class SleepHomeController extends StateNotifier<SleepHomeState> {
  final GetSleepRecordsUseCase _getSleepRecordsUseCase;

  SleepHomeController(this._getSleepRecordsUseCase)
    : super(const SleepHomeState()) {
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final now = DateTime.now();
      // 우선 최근 30일 기록을 가져오도록 설정
      final records = await _getSleepRecordsUseCase(
        now.subtract(const Duration(days: 30)),
        now,
      );

      // 오늘 날짜의 미완성 기록 찾기
      SleepRecord? incompleteRecord;
      final today = DateTime(now.year, now.month, now.day);
      for (final record in records) {
        final wakeUpDay = DateTime(
          record.wakeTime.year,
          record.wakeTime.month,
          record.wakeTime.day,
        );
        if (wakeUpDay == today && record.fatigue == null) {
          incompleteRecord = record;
          break;
        }
      }

      state = state.copyWith(
        isLoading: false,
        records: records,
        incompleteRecordForToday: incompleteRecord,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
