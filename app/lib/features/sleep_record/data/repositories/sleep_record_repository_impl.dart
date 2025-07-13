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
