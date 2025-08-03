import 'package:flutter/material.dart';
import '../../../domain/models/challenge_progress.dart';

class ChallengeRecommendationWidget extends StatelessWidget {
  final Function(ChallengeProgress) onChallengeTap;

  const ChallengeRecommendationWidget({
    super.key,
    required this.onChallengeTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Dummy 추천 챌린지들
    final recommendedChallenges = [
      ChallengeProgress(
        id: 'rec1',
        title: '스트레스 해소 루틴',
        description: '매일 10분 명상으로 스트레스 관리하기',
        progress: 0.0,
        todayTask: '오늘 10분 명상하기',
        startDate: DateTime.now(),
      ),
      ChallengeProgress(
        id: 'rec2',
        title: '감사 연습',
        description: '매일 감사한 일 3가지를 찾아보기',
        progress: 0.0,
        todayTask: '오늘 감사한 일 찾기',
        startDate: DateTime.now(),
      ),
      ChallengeProgress(
        id: 'rec3',
        title: '긍정적 사고 훈련',
        description: '부정적 상황에서 긍정적 관점 찾기',
        progress: 0.0,
        todayTask: '긍정적 관점 연습하기',
        startDate: DateTime.now(),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '추천 챌린지',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // 전체 챌린지 목록으로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('전체 챌린지 목록으로 이동합니다')),
                  );
                },
                child: Text(
                  '더보기',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: recommendedChallenges.length,
            itemBuilder: (context, index) {
              final challenge = recommendedChallenges[index];
              return Container(
                width: 200,
                margin: EdgeInsets.only(
                  right: index < recommendedChallenges.length - 1 ? 12 : 0,
                ),
                child: _RecommendedChallengeCard(
                  challenge: challenge,
                  onTap: () => onChallengeTap(challenge),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecommendedChallengeCard extends StatelessWidget {
  final ChallengeProgress challenge;
  final VoidCallback onTap;

  const _RecommendedChallengeCard({
    required this.challenge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer.withOpacity(0.3),
              theme.colorScheme.secondaryContainer.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  '추천',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              challenge.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              challenge.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '시작하기',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 