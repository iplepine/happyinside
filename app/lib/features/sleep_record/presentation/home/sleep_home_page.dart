import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happyinside/features/sleep_record/domain/models/sleep_record.dart';
import 'package:happyinside/features/sleep_record/presentation/controller/sleep_home_controller.dart';
import 'package:happyinside/features/sleep_record/presentation/sleep_record_page.dart';
import 'package:happyinside/features/sleep_record/presentation/widgets/sleep_history_chart.dart';
import 'package:happyinside/features/sleep_record/presentation/home/widgets/sleep_animated_button.dart';

class SleepHomePage extends ConsumerStatefulWidget {
  const SleepHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<SleepHomePage> createState() => _SleepHomePageState();
}

class _SleepHomePageState extends ConsumerState<SleepHomePage> {
  String? _selectedMode; // 'night' 또는 'morning'
  bool _isDragging = false;
  final GlobalKey _buttonKey = GlobalKey();

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
      _updateModeFromPosition(startPosition);
    }
  }

  void _handleDragUpdate(Offset currentPosition) {
    if (!_isDragging) return;
    _updateModeFromPosition(currentPosition);
  }

  void _handleDragEnd() {
    if (!_isDragging) return;

    // 드래그가 끝나면 선택된 모드에 따라 수면 기록 페이지로 이동
    if (_selectedMode == 'night' || _selectedMode == 'morning') {
      final now = DateTime.now();
      SleepRecord? initialRecord;

      if (_selectedMode == 'night') {
        // 잠들기 전 모드: 현재 시간을 잠든 시간으로 설정
        final sleepTime = DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
        );
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
      } else if (_selectedMode == 'morning') {
        // 일어난 후 모드: 현재 시간을 일어난 시간으로 설정
        final wakeTime = DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
        );
        final sleepTime = wakeTime.subtract(const Duration(hours: 8));
        initialRecord = SleepRecord(
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
      }

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

    setState(() {
      _isDragging = false;
      _selectedMode = null;
    });
  }

  void _updateModeFromPosition(Offset globalPosition) {
    final screenWidth = MediaQuery.of(context).size.width;
    final centerX = screenWidth / 2;

    // 화면 중앙을 기준으로 왼쪽은 밤, 오른쪽은 아침
    String mode;
    if (globalPosition.dx < centerX - 20) {
      mode = 'night'; // 왼쪽 - 밤
    } else if (globalPosition.dx > centerX + 20) {
      mode = 'morning'; // 오른쪽 - 아침
    } else {
      mode = 'default'; // 중앙 - 기본
    }

    if (_selectedMode != mode) {
      setState(() {
        _selectedMode = mode == 'default' ? null : mode;
      });
    }
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
                data: (records) => SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 24,
                    bottom: 120, // 버튼을 위한 여백
                  ),
                  child: Column(
                    children: [
                      // 차트 섹션
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SleepHistoryChart(
                          records: records,
                          onBarLongPressed: (record) {
                            _navigateToRecordPage(context, ref, record);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 통계 정보
                      if (records.isNotEmpty) _buildStatistics(records),
                    ],
                  ),
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

  Widget _buildStatistics(List<SleepRecord> records) {
    final totalHours = records.fold<double>(
      0,
      (sum, record) => sum + record.totalSleepHours,
    );
    final avgHours = totalHours / records.length;
    final avgScore =
        records.fold<double>(0, (sum, record) => sum + record.averageScore) /
        records.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('평균 수면', '${avgHours.toStringAsFixed(1)}시간'),
          _buildStatItem('평균 점수', '${avgScore.toStringAsFixed(1)}점'),
          _buildStatItem('기록 수', '${records.length}개'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
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
