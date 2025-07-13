import '../models/sleep_record.dart';
import '../repositories/sleep_record_repository.dart';

/// 특정 기간 동안의 수면 기록 조회 유즈케이스
class GetSleepRecordsUseCase {
  final SleepRecordRepository _repository;

  GetSleepRecordsUseCase(this._repository);

  /// [start]와 [end] 사이의 수면 기록을 조회합니다.
  Future<List<SleepRecord>> call(DateTime start, DateTime end) async {
    return _repository.getRecordsBetween(start, end);
  }
}
