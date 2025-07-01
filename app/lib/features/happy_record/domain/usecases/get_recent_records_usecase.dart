import '../repositories/record_repository.dart';
import '../../../../core/models/record.dart';

class GetRecentRecordsUseCase {
  final RecordRepository repository;
  GetRecentRecordsUseCase(this.repository);

  /// 최근 기록 최대 5개 반환 (최신순)
  List<Record> call({int limit = 5}) {
    return repository.getRecentRecords(limit: limit);
  }
} 