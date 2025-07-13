import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:happyinside/features/sleep_record/presentation/controller/sleep_home_controller.dart';
import 'package:intl/intl.dart';

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
          if (records.isEmpty) {
            return const Center(child: Text('기록이 없습니다.'));
          }
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return ListTile(
                title: Text(
                  '${DateFormat('yyyy.MM.dd(E)', 'ko_KR').format(record.createdAt)} 기록',
                ),
                subtitle: Text(
                  '수면 시간: ${DateFormat.Hm().format(record.sleepTime)} ~ ${DateFormat.Hm().format(record.wakeTime)}',
                ),
                trailing: Text('만족도: ${record.sleepSatisfaction}/10'),
              );
            },
          );
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
