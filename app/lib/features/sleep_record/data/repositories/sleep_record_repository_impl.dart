import 'package:hive/hive.dart';

import '../../domain/models/sleep_record.dart';
import '../../domain/repositories/sleep_record_repository.dart';
import '../models/sleep_record_dto.dart';

class SleepRecordRepositoryImpl implements SleepRecordRepository {
  final Box<SleepRecordDto> _box;

  SleepRecordRepositoryImpl(this._box);

  @override
  Future<void> addRecord(SleepRecord record) async {
    await _box.put(record.id, _toDto(record));
  }

  @override
  Future<void> updateRecord(SleepRecord record) async {
    await _box.put(record.id, _toDto(record));
  }

  @override
  Future<void> deleteRecord(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<SleepRecord>> getAllRecords() async {
    return _box.values.map(_fromDto).toList();
  }

  @override
  Future<List<SleepRecord>> getOverlappingRecords(
    String id,
    DateTime start,
    DateTime end,
  ) async {
    final List<SleepRecordDto> overlaps = [];
    for (final dto in _box.values) {
      if (dto.id == id) continue;

      if (start.isBefore(dto.wakeTime) && dto.sleepTime.isBefore(end)) {
        overlaps.add(dto);
      }
    }
    return overlaps.map(_fromDto).toList();
  }

  @override
  Future<List<SleepRecord>> getRecordsBetween(
    DateTime start,
    DateTime end,
  ) async {
    final records = _box.values
        .where(
          (dto) =>
              dto.createdAt.isAfter(start.subtract(const Duration(days: 1))) &&
              dto.createdAt.isBefore(end.add(const Duration(days: 1))),
        )
        .map(_fromDto)
        .toList();

    // 최신순으로 정렬
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records;
  }

  // --- Mappers ---

  SleepRecordDto _toDto(SleepRecord record) {
    return SleepRecordDto(
      id: record.id,
      sleepTime: record.sleepTime,
      wakeTime: record.wakeTime,
      freshness: record.freshness,
      fatigue: record.fatigue,
      sleepSatisfaction: record.sleepSatisfaction,
      content: record.content,
      disruptionFactors: record.disruptionFactors,
      createdAt: record.createdAt,
    );
  }

  SleepRecord _fromDto(SleepRecordDto dto) {
    return SleepRecord(
      id: dto.id,
      sleepTime: dto.sleepTime,
      wakeTime: dto.wakeTime,
      freshness: dto.freshness,
      fatigue: dto.fatigue,
      sleepSatisfaction: dto.sleepSatisfaction,
      content: dto.content,
      disruptionFactors: dto.disruptionFactors,
      createdAt: dto.createdAt,
    );
  }
}
