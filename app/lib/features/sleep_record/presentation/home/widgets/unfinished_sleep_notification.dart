import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../di/injection.dart';
import '../../../domain/models/sleep_record.dart';
import '../../../domain/repositories/sleep_record_repository.dart';
import '../../../domain/usecases/get_unfinished_sleep_record_usecase.dart';
import '../../sleep_record_page.dart';
import '../../controller/sleep_home_controller.dart';

class UnfinishedSleepNotification extends ConsumerStatefulWidget {
  final VoidCallback? onDismissed;
  const UnfinishedSleepNotification({super.key, this.onDismissed});

  @override
  ConsumerState<UnfinishedSleepNotification> createState() =>
      _UnfinishedSleepNotificationState();
}

class _UnfinishedSleepNotificationState
    extends ConsumerState<UnfinishedSleepNotification> {
  Future<SleepRecord?>? _unfinishedRecordFuture;

  @override
  void initState() {
    super.initState();
    _loadUnfinishedRecord();
  }

  void _loadUnfinishedRecord() {
    final repository = Injection.getIt<SleepRecordRepository>();
    final useCase = GetUnfinishedSleepRecordUseCase(repository);
    _unfinishedRecordFuture = useCase();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SleepRecord?>(
      future: _unfinishedRecordFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final unfinishedRecord = snapshot.data!;
        final key = ValueKey<String>(unfinishedRecord.id);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Dismissible(
              key: key,
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                if (widget.onDismissed != null) {
                  widget.onDismissed!();
                }
              },
              background: Container(
                color: Colors.redAccent,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Icon(Icons.delete_sweep, color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete_sweep, color: Colors.white),
                    ),
                  ],
                ),
              ),
              child: _NotificationContent(
                record: unfinishedRecord,
                onTap: () =>
                    _navigateToRecordPage(context, ref, unfinishedRecord),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToRecordPage(
    BuildContext context,
    WidgetRef ref,
    SleepRecord record,
  ) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => SleepRecordPage(initialRecord: record),
          ),
        )
        .then((result) {
          if (result == true) {
            ref.read(sleepHomeControllerProvider.notifier).fetchRecords();
            // 수정 완료 후 알림을 다시 표시하지 않기 위해 상태를 갱신
            setState(() {
              _unfinishedRecordFuture = null;
            });
          }
        });
  }
}

class _NotificationContent extends StatelessWidget {
  final SleepRecord record;
  final VoidCallback onTap;

  const _NotificationContent({required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.bedtime, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '미완성 수면 기록',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${record.sleepTime.hour.toString().padLeft(2, '0')}:${record.sleepTime.minute.toString().padLeft(2, '0')}에 잠든 기록이 있습니다',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '완료하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
