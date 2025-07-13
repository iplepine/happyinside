import '../repositories/sleep_record_repository.dart';

class DeleteSleepRecordUseCase {
  final SleepRecordRepository _repository;

  DeleteSleepRecordUseCase(this._repository);

  Future<void> call(String id) async {
    return _repository.deleteRecord(id);
  }
}
