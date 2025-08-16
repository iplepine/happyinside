import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/di/injection.dart';
import '../../domain/usecases/get_sleep_records_usecase.dart';
import '../state/sleep_home_state.dart';

final sleepHomeControllerProvider =
    StateNotifierProvider<SleepHomeController, SleepHomeState>(
      (ref) => SleepHomeController(Injection.getIt<GetSleepRecordsUseCase>()),
    );

class SleepHomeController extends StateNotifier<SleepHomeState> {
  final GetSleepRecordsUseCase _getSleepRecordsUseCase;

  SleepHomeController(this._getSleepRecordsUseCase)
    : super(const SleepHomeState.loading()) {
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    state = const SleepHomeState.loading();
    try {
      final now = DateTime.now();
      // 우선 최근 30일 기록을 가져오도록 설정
      final records = await _getSleepRecordsUseCase(
        now.subtract(const Duration(days: 30)),
        now,
      );

      state = SleepHomeState.data(records);
    } catch (e) {
      state = SleepHomeState.error(e.toString());
    }
  }
}
