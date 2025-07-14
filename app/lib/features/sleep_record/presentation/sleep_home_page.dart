import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:happyinside/features/sleep_record/presentation/controller/sleep_home_controller.dart';
import 'package:happyinside/features/sleep_record/presentation/widgets/sleep_history_chart.dart';
import 'package:intl/intl.dart';
import 'package:happyinside/features/sleep_record/presentation/sleep_record_page.dart';
import 'package:happyinside/features/sleep_record/domain/models/sleep_record.dart';

class SleepHomePage extends ConsumerWidget {
  const SleepHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sleepHomeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Tracker')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (records) => Column(
          children: [
            SleepHistoryChart(
              records: records,
              onBarLongPressed: (record) {
                _navigateToRecordPage(context, ref, record);
              },
            ),
          ],
        ),
        error: (message) => Center(child: Text('Error: $message')),
      ),
    );
  }

  void _navigateToRecordPage(
    BuildContext context,
    WidgetRef ref, [
    SleepRecord? record,
  ]) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => SleepRecordPage(initialRecord: record),
      ),
    ).then((result) {
      if (result == true) {
        ref.read(sleepHomeControllerProvider.notifier).fetchRecords();
      }
    });
  }
}
