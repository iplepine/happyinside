import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happyinside/features/sleep_record/domain/models/sleep_record.dart';
import 'package:happyinside/features/sleep_record/presentation/controller/sleep_home_controller.dart';
import 'package:happyinside/features/sleep_record/presentation/sleep_record_page.dart';
import 'package:happyinside/features/sleep_record/presentation/home/widgets/sleep_animated_button.dart';
import 'package:happyinside/features/sleep_record/presentation/home/widgets/sleep_drag_handler.dart';
import 'package:happyinside/features/sleep_record/presentation/home/widgets/sleep_home_content.dart';

class SleepHomePage extends ConsumerStatefulWidget {
  const SleepHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<SleepHomePage> createState() => _SleepHomePageState();
}

class _SleepHomePageState extends ConsumerState<SleepHomePage> {
  String? _selectedMode; // 'night' 또는 'morning'
  bool _isDragging = false;
  final GlobalKey _buttonKey = GlobalKey();
  late final SleepDragHandler _dragHandler;

  @override
  void initState() {
    super.initState();
    _dragHandler = SleepDragHandler(
      onModeChanged: (mode) {
        setState(() {
          _selectedMode = mode;
        });
      },
      buttonKey: _buttonKey,
    );
  }

  void _handleDragStart(Offset startPosition) {
    final buttonRenderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (buttonRenderBox == null) return;

    final buttonRect =
        buttonRenderBox.localToGlobal(Offset.zero) & buttonRenderBox.size;

    // 버튼 영역에서 드래그가 시작되었는지 확인
    if (buttonRect.contains(startPosition)) {
      setState(() {
        _isDragging = true;
      });
      _dragHandler.handleDragStart(startPosition);
    }
  }

  void _handleDragUpdate(Offset currentPosition) {
    if (!_isDragging) return;
    _dragHandler.handleDragUpdate(currentPosition);
  }

  void _handleDragEnd() {
    if (!_isDragging) return;

    // 드래그가 끝나면 선택된 모드에 따라 수면 기록 페이지로 이동
    if (_selectedMode == 'night' || _selectedMode == 'morning') {
      final now = DateTime.now();
      SleepRecord? initialRecord;

      if (_selectedMode == 'night') {
        // 잠들기 전 모드: 현재 시간에서 10분 뒤를 잠든 시간으로 설정
        final sleepTime = DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
        ).add(const Duration(minutes: 10)); // 10분 뒤로 설정
        initialRecord = SleepRecord(
          id: UniqueKey().toString(),
          sleepTime: sleepTime,
          wakeTime: sleepTime, // 임시값, 사용자가 나중에 설정
          freshness: 5,
          sleepSatisfaction: 5,
          disruptionFactors: '',
          createdAt: now,
          fatigue: null,
          content: null,
        );

        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => SleepRecordPage(initialRecord: initialRecord),
              ),
            )
            .then((result) {
              if (result == true) {
                ref.read(sleepHomeControllerProvider.notifier).fetchRecords();
              }
            });
      } else if (_selectedMode == 'morning') {
        // 일어난 후 모드: 기존 기록 확인 후 처리
        _handleMorningMode(now);
      }
    }

    setState(() {
      _isDragging = false;
      _selectedMode = null;
    });
  }

  void _handleMorningMode(DateTime now) {
    final state = ref.read(sleepHomeControllerProvider);

    state.when(
      loading: () => _createNewMorningRecord(now),
      data: (records) {
        print('=== Morning Mode Debug ===');
        print('Total records: ${records.length}');

        // 12시간 내에 잠든 시간은 있지만 일어난 시간이 없는 기록 찾기
        final incompleteRecord = records.where((record) {
          final timeDiff = now.difference(record.sleepTime).inHours;
          final isIncomplete =
              record.sleepTime == record.wakeTime; // 잠든 시간과 일어난 시간이 같음 (미완성)

          print(
            'Record: ${record.sleepTime} -> ${record.wakeTime}, timeDiff: $timeDiff, isIncomplete: $isIncomplete',
          );

          return timeDiff <= 12 && isIncomplete;
        }).firstOrNull;

        print('Found incomplete record: ${incompleteRecord != null}');

        if (incompleteRecord != null) {
          // 기존 기록이 있으면 수정할지 묻기
          print('Showing update dialog');
          _showUpdateDialog(incompleteRecord, now);
        } else {
          // 새 기록 생성
          print('Creating new morning record');
          _createNewMorningRecord(now);
        }
      },
      error: (message) => _createNewMorningRecord(now),
    );
  }

  void _showUpdateDialog(SleepRecord existingRecord, DateTime now) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('기존 기록 수정'),
          content: Text(
            '${existingRecord.sleepTime.hour.toString().padLeft(2, '0')}:${existingRecord.sleepTime.minute.toString().padLeft(2, '0')}에 잠든 기록이 있습니다.\n'
            '이 기록에 일어난 시간을 추가하시겠습니까?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _createNewMorningRecord(now);
              },
              child: const Text('새 기록 만들기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateExistingRecord(existingRecord, now);
              },
              child: const Text('기존 기록 수정'),
            ),
          ],
        );
      },
    );
  }

  void _createNewMorningRecord(DateTime now) {
    final wakeTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    final sleepTime = wakeTime.subtract(const Duration(hours: 8));
    final initialRecord = SleepRecord(
      id: UniqueKey().toString(),
      sleepTime: sleepTime,
      wakeTime: wakeTime,
      freshness: 5,
      sleepSatisfaction: 5,
      disruptionFactors: '',
      createdAt: now,
      fatigue: null,
      content: null,
    );

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => SleepRecordPage(initialRecord: initialRecord),
          ),
        )
        .then((result) {
          if (result == true) {
            ref.read(sleepHomeControllerProvider.notifier).fetchRecords();
          }
        });
  }

  void _updateExistingRecord(SleepRecord existingRecord, DateTime now) {
    // 기존 기록을 현재 시간으로 업데이트
    final updatedRecord = existingRecord.copyWith(
      wakeTime: DateTime(now.year, now.month, now.day, now.hour, now.minute),
    );

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => SleepRecordPage(initialRecord: updatedRecord),
          ),
        )
        .then((result) {
          if (result == true) {
            ref.read(sleepHomeControllerProvider.notifier).fetchRecords();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sleepHomeControllerProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text('수면 기록'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Stack(
        children: [
          // --- 기본 UI ---
          Positioned.fill(
            child: SafeArea(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (records) => SleepHomeContent(
                  records: records,
                  onBarLongPressed: (record) {
                    _navigateToRecordPage(context, ref, record);
                  },
                ),
                error: (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text('오류가 발생했습니다: $message'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(sleepHomeControllerProvider.notifier)
                            .fetchRecords(),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 하단 버튼 - 행복 기록과 동일한 위치
          Positioned(
            bottom: 32 + MediaQuery.of(context).padding.bottom, // 행복 기록과 동일한 위치
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTapDown: (details) =>
                    _handleDragStart(details.globalPosition),
                onTapUp: (details) => _handleDragEnd(),
                onPanUpdate: (details) =>
                    _handleDragUpdate(details.globalPosition),
                onPanEnd: (details) => _handleDragEnd(),
                dragStartBehavior: DragStartBehavior.down,
                child: SizedBox(
                  key: _buttonKey,
                  child: SleepAnimatedButton(selectedMode: _selectedMode),
                ),
              ),
            ),
          ),
        ],
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
