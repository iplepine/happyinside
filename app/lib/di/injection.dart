import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../features/happy_record/data/models/record_dto.dart';
import '../features/happy_record/data/models/record_location_dto.dart';
import '../features/happy_record/data/models/record_photo_dto.dart';
import '../features/happy_record/data/repositories/record_repository_impl.dart';
import '../features/happy_record/domain/repositories/record_repository.dart';
import '../features/happy_record/domain/usecases/add_record_usecase.dart';
import '../features/happy_record/domain/usecases/get_recent_records_usecase.dart';
import '../features/sleep_record/data/models/sleep_record_dto.dart';
import '../features/sleep_record/data/repositories/sleep_record_repository_impl.dart';
import '../features/sleep_record/domain/repositories/sleep_record_repository.dart';
import '../features/sleep_record/domain/usecases/add_sleep_record_usecase.dart';
import '../features/sleep_record/domain/usecases/delete_sleep_record_usecase.dart';
import '../features/sleep_record/domain/usecases/get_sleep_records_usecase.dart';
import '../features/sleep_record/domain/usecases/update_sleep_record_usecase.dart';

/// 의존성 주입 설정
class Injection {
  static final GetIt _getIt = GetIt.instance;

  /// 의존성 초기화
  static Future<void> init() async {
    // Hive 초기화 및 어댑터 등록
    await Hive.initFlutter();
    // Happy Record Adapters
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(RecordDtoAdapter());
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(RecordLocationDtoAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(RecordPhotoDtoAdapter());
    }
    // Sleep Record Adapter
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(SleepRecordDtoAdapter());
    }

    final happyRecordBox = await Hive.openBox<RecordDto>('records');
    final sleepRecordBox = await Hive.openBox<SleepRecordDto>('sleep_records');

    // Repository 등록
    _getIt.registerSingleton<RecordRepository>(
      RecordRepositoryImpl(happyRecordBox),
    );
    _getIt.registerSingleton<SleepRecordRepository>(
      SleepRecordRepositoryImpl(sleepRecordBox),
    );

    // UseCase 등록
    _getIt.registerSingleton<GetRecentRecordsUseCase>(
      GetRecentRecordsUseCase(_getIt<RecordRepository>()),
    );
    _getIt.registerSingleton<AddRecordUseCase>(
      AddRecordUseCase(_getIt<RecordRepository>()),
    );
    _getIt.registerSingleton<AddSleepRecordUseCase>(
      AddSleepRecordUseCase(_getIt<SleepRecordRepository>()),
    );
    _getIt.registerSingleton<GetSleepRecordsUseCase>(
      GetSleepRecordsUseCase(_getIt<SleepRecordRepository>()),
    );
    _getIt.registerSingleton<UpdateSleepRecordUseCase>(
      UpdateSleepRecordUseCase(_getIt<SleepRecordRepository>()),
    );
    _getIt.registerSingleton<DeleteSleepRecordUseCase>(
      DeleteSleepRecordUseCase(_getIt<SleepRecordRepository>()),
    );
  }

  /// GetIt 인스턴스 반환
  static GetIt get getIt => _getIt;
}
