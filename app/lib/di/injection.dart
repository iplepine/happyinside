import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../features/happy_record/data/models/record_dto.dart';
import '../features/happy_record/data/models/record_location_dto.dart';
import '../features/happy_record/data/models/record_photo_dto.dart';
import '../features/happy_record/data/repositories/record_repository_impl.dart';
import '../features/happy_record/domain/repositories/record_repository.dart';
import '../features/happy_record/domain/usecases/get_recent_records_usecase.dart';
import '../features/happy_record/domain/usecases/add_record_usecase.dart';

/// 의존성 주입 설정
class Injection {
  static final GetIt _getIt = GetIt.instance;

  /// 의존성 초기화
  static Future<void> init() async {
    // Hive 초기화 및 어댑터 등록
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(RecordDtoAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(RecordLocationDtoAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(RecordPhotoDtoAdapter());
    final recordBox = await Hive.openBox<RecordDto>('records');

    // Repository 등록
    _getIt.registerSingleton<RecordRepository>(RecordRepositoryImpl(recordBox));
    // UseCase 등록
    _getIt.registerSingleton<GetRecentRecordsUseCase>(
      GetRecentRecordsUseCase(_getIt<RecordRepository>()),
    );
    _getIt.registerSingleton<AddRecordUseCase>(
      AddRecordUseCase(_getIt<RecordRepository>()),
    );
  }

  /// GetIt 인스턴스 반환
  static GetIt get getIt => _getIt;
} 