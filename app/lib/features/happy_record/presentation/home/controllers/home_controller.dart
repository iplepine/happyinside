import 'package:flutter/material.dart';
import '../state/home_state.dart';
import '../intent/home_intent.dart';
import '../../../../../di/injection.dart';
import '../../../domain/usecases/get_recent_records_usecase.dart';

class HomeController extends ChangeNotifier {
  final GetRecentRecordsUseCase getRecentRecordsUseCase =
      Injection.getIt<GetRecentRecordsUseCase>();

  HomeState _state = HomeState.initial();
  HomeState get state => _state;

  void onIntent(HomeIntent intent) async {
    if (intent is LoadRecentRecords) {
      _state = _state.copyWith(isLoading: true);
      notifyListeners();

      try {
        final records = getRecentRecordsUseCase();
        _state = _state.copyWith(recentRecords: records, isLoading: false);
      } catch (e) {
        // TODO: 에러 처리 구현
        _state = _state.copyWith(isLoading: false);
      }
    }
    notifyListeners();
  }

  // reduce 함수는 onIntent에서 모든 로직을 처리하므로 제거하거나 주석처리합니다.
  // HomeState reduce(HomeIntent intent, HomeState prevState) { ... }
}
