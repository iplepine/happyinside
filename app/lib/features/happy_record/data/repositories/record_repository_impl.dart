import 'package:hive/hive.dart';
import '../../domain/repositories/record_repository.dart';
import '../models/record_dto.dart';
import '../../../../core/models/record.dart';

class RecordRepositoryImpl implements RecordRepository {
  final Box<RecordDto> recordBox;
  RecordRepositoryImpl(this.recordBox);

  @override
  List<Record> getRecentRecords({int limit = 5}) {
    final records = recordBox.values
        .map((dto) => dto.toDomain())
        .whereType<Record>()
        .toList();
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records.take(limit).toList();
  }

  @override
  Future<void> addRecord(Record record) async {
    final dto = RecordDto.fromDomain(record);
    await recordBox.add(dto);
  }
} 