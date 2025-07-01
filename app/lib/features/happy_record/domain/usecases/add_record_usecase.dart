import '../repositories/record_repository.dart';
import '../../../../core/models/record.dart';

class AddRecordUseCase {
  final RecordRepository repository;
  AddRecordUseCase(this.repository);

  Future<void> call(Record record) => repository.addRecord(record);
} 