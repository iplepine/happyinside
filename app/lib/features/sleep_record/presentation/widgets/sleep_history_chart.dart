import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/sleep_record.dart';

class SleepHistoryChart extends StatelessWidget {
  final List<SleepRecord> records;

  const SleepHistoryChart({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('최근 7일간의 기록이 여기에 표시됩니다.'),
        ),
      );
    }

    // 최신 데이터가 오른쪽으로 가도록 정렬
    final chartData = records.reversed.toList();

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 10, // Y축 최대값: 수면 만족도 10점
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final record = chartData[groupIndex];
                  return BarTooltipItem(
                    '${DateFormat('MM/dd').format(record.createdAt)}\n${record.sleepSatisfaction}점',
                    const TextStyle(color: Colors.white, height: 1.5),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    if (value == 0 || value == 5 || value == 10) {
                      return Text(value.toInt().toString());
                    }
                    return const Text('');
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    final record = chartData[value.toInt()];
                    final date = DateFormat('MM/dd').format(record.createdAt);
                    final sleepTime = DateFormat.Hm().format(record.sleepTime);
                    final wakeTime = DateFormat.Hm().format(record.wakeTime);
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 4.0,
                      child: Text(
                        '$date\n${sleepTime}~${wakeTime}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 9, height: 1.2),
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) =>
                  const FlLine(color: Colors.grey, strokeWidth: 0.3),
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(show: false),
            barGroups: chartData.asMap().entries.map((entry) {
              final index = entry.key;
              final record = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: record.sleepSatisfaction.toDouble(),
                    color: Colors.amber,
                    width: 16,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
