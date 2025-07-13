import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_tracker/features/sleep_record/presentation/home/sleep_home_controller.dart';
import 'package:sleep_tracker/features/sleep_record/presentation/home/widgets/sleep_history_chart.dart';
import 'package:sleep_tracker/features/sleep_record/presentation/record/sleep_record_page.dart';
import 'package:sleep_tracker/models/sleep_record.dart';

class SleepHomePage extends ConsumerWidget {
  const SleepHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sleepHomeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Tracker')),
      body: state.when(
        data: (data) {
          return Column(
            children: [
              SleepHistoryChart(
                records: data.records,
                onRecordSelected: (record) {
                  _navigateToRecordPage(context, record);
                },
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text('Error: $error'),
      ),
    );
  }

  void _navigateToRecordPage(BuildContext context, [SleepRecord? record]) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => SleepRecordPage(initialRecord: record),
      ),
    ).then((result) {
      if (result == true) {
        ref.read(sleepHomeControllerProvider.notifier).loadRecords();
      }
    });
  }

  void _showCompleteRecordDialog(SleepRecord record) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Complete Record'),
          content: const Text('Do you want to complete this record?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement complete record logic
                Navigator.pop(context);
              },
              child: const Text('Complete'),
            ),
          ],
        );
      },
    );
  }
}
