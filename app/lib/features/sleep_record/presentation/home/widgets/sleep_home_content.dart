import 'package:flutter/material.dart';
import 'package:happyinside/features/sleep_record/domain/models/sleep_record.dart';
import 'package:happyinside/features/sleep_record/presentation/widgets/sleep_history_chart.dart';

import 'sleep_statistics.dart';

class SleepHomeContent extends StatelessWidget {
  final List<SleepRecord> records;
  final Function(SleepRecord) onBarLongPressed;

  const SleepHomeContent({
    super.key,
    required this.records,
    required this.onBarLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              onBarLongPressed: onBarLongPressed,
            ),
          ),
          const SizedBox(height: 20),
          // 통계 정보
          if (records.isNotEmpty) SleepStatistics(records: records),
        ],
      ),
    );
  }
}
