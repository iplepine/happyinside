import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:happyinside/features/sleep_record/presentation/controller/sleep_home_controller.dart';
import 'package:happyinside/features/sleep_record/presentation/widgets/sleep_history_chart.dart';

class SleepHomePage extends ConsumerWidget {
  const SleepHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sleepHomeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('수면 기록'), centerTitle: true),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (records) {
          // 최근 7개 기록만 선택
          final recentRecords = records.take(7).toList();
          return SleepHistoryChart(records: recentRecords);
        },
        error: (message) => Center(child: Text('오류: $message')),
      ),
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
}
