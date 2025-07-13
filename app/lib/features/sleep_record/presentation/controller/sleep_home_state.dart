import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/sleep_record.dart';

part 'sleep_home_state.freezed.dart';

@freezed
class SleepHomeState with _$SleepHomeState {
  const factory SleepHomeState({
    @Default(true) bool isLoading,
    @Default([]) List<SleepRecord> records,
    SleepRecord? incompleteRecordForToday,
    String? errorMessage,
  }) = _SleepHomeState;
}
