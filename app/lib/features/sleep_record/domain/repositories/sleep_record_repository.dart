import '../models/sleep_record.dart';

abstract class SleepRecordRepository {
  Future<void> addRecord(SleepRecord record);
  Future<List<SleepRecord>> getRecordsBetween(DateTime start, DateTime end);
  // Future<void> deleteRecord(String id); // 나중에 삭제 기능 추가 시
}
