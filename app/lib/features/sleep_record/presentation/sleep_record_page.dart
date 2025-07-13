import 'package:flutter/material.dart';
import 'package:happyinside/core/errors/failures.dart';

import '../../../di/injection.dart';
import '../domain/models/sleep_record.dart';
import '../domain/usecases/add_sleep_record_usecase.dart';

class SleepRecordPage extends StatefulWidget {
  const SleepRecordPage({super.key});

  @override
  State<SleepRecordPage> createState() => _SleepRecordPageState();
}

class _SleepRecordPageState extends State<SleepRecordPage> {
  final _formKey = GlobalKey<FormState>();

  late TimeOfDay _sleepTime;
  late TimeOfDay _wakeTime;
  int _freshness = 5;
  int _fatigue = 5;
  int _sleepSatisfaction = 5;
  final _contentController = TextEditingController();
  final _disruptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDefaultTimes();
  }

  void _initializeDefaultTimes() {
    final now = DateTime.now();
    _wakeTime = TimeOfDay.fromDateTime(now);

    final recommendedSleepTime = now.subtract(const Duration(hours: 8));
    _sleepTime = TimeOfDay.fromDateTime(recommendedSleepTime);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _disruptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(
    BuildContext context, {
    required bool isSleepTime,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isSleepTime ? _sleepTime : _wakeTime,
    );
    if (picked != null) {
      setState(() {
        if (isSleepTime) {
          _sleepTime = picked;
        } else {
          _wakeTime = picked;
        }
      });
    }
  }

  void _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final now = DateTime.now();
      // 일어난 시간을 오늘 날짜로 설정
      final wakeDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _wakeTime.hour,
        _wakeTime.minute,
      );
      // 잠든 시간을 우선 오늘 날짜로 설정
      var sleepDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _sleepTime.hour,
        _sleepTime.minute,
      );

      // 만약 잠든 시간(23:00)이 일어난 시간(07:00)보다 뒤라면, 잠든 날짜를 하루 전으로 조정
      if (sleepDateTime.isAfter(wakeDateTime)) {
        sleepDateTime = sleepDateTime.subtract(const Duration(days: 1));
      }

      final record = SleepRecord(
        id: UniqueKey().toString(),
        sleepTime: sleepDateTime,
        wakeTime: wakeDateTime,
        freshness: _freshness,
        fatigue: _fatigue,
        sleepSatisfaction: _sleepSatisfaction,
        content: _contentController.text,
        disruptionFactors: _disruptionController.text,
        createdAt: now,
      );

      final addSleepRecordUseCase = Injection.getIt<AddSleepRecordUseCase>();
      try {
        await addSleepRecordUseCase(record);

        if (mounted) {
          Navigator.pop(context, true);
        }
      } on SleepTimeOverlapException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('수면 기록하기')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              _buildTimePicker(
                label: '잠든 시간',
                time: _sleepTime,
                onTap: () => _selectTime(context, isSleepTime: true),
              ),
              const SizedBox(height: 16),
              _buildTimePicker(
                label: '일어난 시간',
                time: _wakeTime,
                onTap: () => _selectTime(context, isSleepTime: false),
              ),
              const SizedBox(height: 24),
              _buildSlider(
                label: '잠에서 깼을 때의 상쾌함',
                value: _freshness,
                onChanged: (v) => setState(() => _freshness = v),
              ),
              const SizedBox(height: 16),
              _buildSlider(
                label: '하루 중 피로도',
                value: _fatigue,
                onChanged: (v) => setState(() => _fatigue = v),
              ),
              const SizedBox(height: 16),
              _buildSlider(
                label: '수면 만족도',
                value: _sleepSatisfaction,
                onChanged: (v) => setState(() => _sleepSatisfaction = v),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: '구체적인 내용 (예: 오전에 괜찮았는지)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _disruptionController,
                decoration: const InputDecoration(
                  labelText: '수면 방해 요인 (예: 화장실 가느라 깸)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Text(
              time.format(context),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: value.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: '$value',
                onChanged: (v) => onChanged(v.round()),
              ),
            ),
            SizedBox(
              width: 30,
              child: Text('$value', textAlign: TextAlign.right),
            ),
          ],
        ),
      ],
    );
  }
}
