import 'package:flutter/material.dart';

import 'widgets/emotion_pattern_widget.dart';
import 'widgets/trigger_report_widget.dart';
import 'widgets/sleep_routine_insight_widget.dart';
import 'widgets/challenge_history_widget.dart';
import 'widgets/personal_keywords_widget.dart';

class MyInsightPage extends StatefulWidget {
  const MyInsightPage({super.key});

  @override
  State<MyInsightPage> createState() => _MyInsightPageState();
}

class _MyInsightPageState extends State<MyInsightPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: const Text(
                'My Insight',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. 감정 패턴 분석
                  EmotionPatternWidget(),
                  
                  const SizedBox(height: 24),
                  
                  // 2. 트리거 리포트
                  TriggerReportWidget(),
                  
                  const SizedBox(height: 24),
                  
                  // 3. 수면 & 루틴 인사이트
                  SleepRoutineInsightWidget(),
                  
                  const SizedBox(height: 24),
                  
                  // 4. 챌린지 히스토리 요약
                  ChallengeHistoryWidget(),
                  
                  const SizedBox(height: 24),
                  
                  // 5. 나를 설명하는 키워드
                  PersonalKeywordsWidget(),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 