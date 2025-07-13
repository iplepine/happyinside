import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:happyinside/features/sleep_record/presentation/controller/sleep_home_controller.dart';
import 'package:happyinside/features/sleep_record/presentation/controller/sleep_home_state.dart';
import 'package:happyinside/features/sleep_record/presentation/widgets/sleep_history_chart.dart';
import 'package:intl/intl.dart';

class SleepHomePage extends ConsumerWidget {
  const SleepHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sleepHomeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('수면 기록'), centerTitle: true),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
          ? Center(child: Text('오류: ${state.errorMessage}'))
          : _buildBody(context, ref, state),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push<bool>('/sleep-record');
          if (result == true) {
            ref.read(sleepHomeControllerProvider.notifier).fetchRecords();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, SleepHomeState state) {
    // 최근 7개 기록만 선택
    final recentRecords = state.records.take(7).toList();
    final incompleteRecord = state.incompleteRecordForToday;
    bool canComplete = false;
    if (incompleteRecord != null) {
      canComplete = DateTime.now().isAfter(
        incompleteRecord.wakeTime.add(const Duration(hours: 1)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80), // FAB에 가려지지 않도록
      child: Column(
        children: [
          if (incompleteRecord != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (canComplete) {
                    final result = await context.push<bool>(
                      '/sleep-record-update',
                      extra: incompleteRecord,
                    );
                    if (result == true) {
                      ref
                          .read(sleepHomeControllerProvider.notifier)
                          .fetchRecords();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('기상 1시간 이후부터 피로도를 기록할 수 있습니다.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: canComplete ? Colors.green : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: const Text('오늘의 기록 완성하기'),
              ),
            ),
          SleepHistoryChart(
            records: recentRecords,
            onBarLongPressed: (record) async {
              final result = await context.push<bool>(
                '/sleep-record-update',
                extra: record,
              );
              if (result == true) {
                ref.read(sleepHomeControllerProvider.notifier).fetchRecords();
              }
            },
          ),
        ],
      ),
    );
  }
}
