import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/challenge_progress.dart';
import 'widgets/active_challenge_list_widget.dart';
import 'widgets/challenge_recommendation_widget.dart';
import 'widgets/start_new_challenge_button.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  late List<ChallengeProgress> _activeChallenges;

  @override
  void initState() {
    super.initState();
    _loadDummyData();
  }

  void _loadDummyData() {
    _activeChallenges = [
      ChallengeProgress(
        id: '1',
        title: '매일 감정 기록하기',
        description: '30일 동안 매일 감정을 기록하는 챌린지',
        progress: 0.7,
        todayTask: '오늘의 감정을 기록해보세요',
        startDate: DateTime.now().subtract(const Duration(days: 21)),
      ),
      ChallengeProgress(
        id: '2',
        title: '감사 일기 쓰기',
        description: '매일 감사한 일 3가지를 기록하기',
        progress: 0.4,
        todayTask: '오늘 감사한 일을 찾아보세요',
        startDate: DateTime.now().subtract(const Duration(days: 12)),
      ),
      ChallengeProgress(
        id: '3',
        title: '긍정적 사고 연습',
        description: '부정적인 상황에서 긍정적 관점 찾기',
        progress: 0.2,
        todayTask: '어려운 상황에서 긍정적 면을 찾아보세요',
        startDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  void _onChallengeTap(ChallengeProgress challenge) {
    context.push('/challenge-detail', extra: challenge);
  }

  void _onStartNewChallenge() {
    context.push('/challenge-explore');
  }

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
                'Challenges',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 진행 중인 챌린지 리스트
                  ActiveChallengeListWidget(
                    challenges: _activeChallenges,
                    onChallengeTap: _onChallengeTap,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 새로운 챌린지 추천
                  ChallengeRecommendationWidget(
                    onChallengeTap: _onChallengeTap,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 챌린지 시작하기 버튼
                  StartNewChallengeButton(
                    onTap: _onStartNewChallenge,
                  ),
                  
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