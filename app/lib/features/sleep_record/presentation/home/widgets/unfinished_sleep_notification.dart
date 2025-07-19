import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../di/injection.dart';
import '../../../domain/models/sleep_record.dart';
import '../../../domain/repositories/sleep_record_repository.dart';
import '../../../domain/usecases/get_unfinished_sleep_record_usecase.dart';
import '../../sleep_record_page.dart';
import '../../controller/sleep_home_controller.dart';

class UnfinishedSleepNotification extends ConsumerStatefulWidget {
  const UnfinishedSleepNotification({super.key});

  @override
  ConsumerState<UnfinishedSleepNotification> createState() =>
      _UnfinishedSleepNotificationState();
}

class _UnfinishedSleepNotificationState
    extends ConsumerState<UnfinishedSleepNotification>
    with SingleTickerProviderStateMixin {
  bool _isDismissed = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(1.0, 0.0)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismissNotification() {
    _animationController.forward().then((_) {
      setState(() {
        _isDismissed = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<SleepRecord?>(
      future: _getUnfinishedRecord(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        final unfinishedRecord = snapshot.data;
        if (unfinishedRecord == null) {
          return const SizedBox.shrink();
        }

        return SlideTransition(
          position: _slideAnimation,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 500 ||
                  details.primaryVelocity! < -500) {
                _dismissNotification();
              }
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
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
                          '${unfinishedRecord.sleepTime.hour.toString().padLeft(2, '0')}:${unfinishedRecord.sleepTime.minute.toString().padLeft(2, '0')}에 잠든 기록이 있습니다',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _navigateToRecordPage(context, ref, unfinishedRecord);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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
            ),
          ),
        );
      },
    );
  }

  Future<SleepRecord?> _getUnfinishedRecord(WidgetRef ref) async {
    final repository = Injection.getIt<SleepRecordRepository>();
    final useCase = GetUnfinishedSleepRecordUseCase(repository);
    return await useCase();
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
            // 기록이 업데이트되면 페이지를 새로고침
            ref.read(sleepHomeControllerProvider.notifier).fetchRecords();
          }
        });
  }
}
