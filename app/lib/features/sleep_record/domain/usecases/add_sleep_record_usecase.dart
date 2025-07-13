import '../models/sleep_record.dart';
import '../repositories/sleep_record_repository.dart';

class AddSleepRecordUseCase {
  final SleepRecordRepository _repository;

  AddSleepRecordUseCase(this._repository);

  Future<void> call(SleepRecord record) async {
    return _repository.addRecord(record);
  }
}
