import '../../../../core/models/record.dart';

abstract class RecordRepository {
  List<Record> getRecentRecords({int limit = 5});
  Future<void> addRecord(Record record);
} 