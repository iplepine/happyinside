import '../../../../../core/models/record.dart';
import 'package:flutter/foundation.dart';

/// 홈 화면 상태
@immutable
class HomeState {
  final List<Record> recentRecords;
  final bool isLoading;

  const HomeState({required this.recentRecords, required this.isLoading});

  factory HomeState.initial() =>
      const HomeState(recentRecords: [], isLoading: true);

  HomeState copyWith({List<Record>? recentRecords, bool? isLoading}) {
    return HomeState(
      recentRecords: recentRecords ?? this.recentRecords,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
