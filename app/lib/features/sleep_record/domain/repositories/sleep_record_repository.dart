import '../models/sleep_record.dart';

abstract class SleepRecordRepository {
  Future<void> addRecord(SleepRecord record);
  // Future<List<SleepRecord>> getRecords(); // 나중에 목록 기능 추가 시
  // Future<void> deleteRecord(String id); // 나중에 삭제 기능 추가 시
}
