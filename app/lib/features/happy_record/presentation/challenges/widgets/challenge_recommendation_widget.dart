import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/models/challenge_progress.dart';
import '../../../domain/usecases/get_available_challenges_usecase.dart';

class ChallengeRecommendationWidget extends StatelessWidget {
  final Function(ChallengeProgress) onChallengeTap;
  final VoidCallback? onMoreTap;

  const ChallengeRecommendationWidget({
    super.key,
    required this.onChallengeTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // 현재 진행 중인 챌린지 목록 (dummy data)
    final activeChallenges = [
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
    ];
    
    // UseCase를 사용하여 추천 챌린지 가져오기
    final getAvailableChallengesUseCase = GetAvailableChallengesUseCase();
    final availableChallenges = getAvailableChallengesUseCase(activeChallenges);
    
    // 상위 3개만 추천으로 표시
    final recommendedChallenges = availableChallenges.take(3).toList();

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
                onPressed: onMoreTap ?? () {
                  // 전체 챌린지 목록으로 이동
                  context.push('/challenge-explore');
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
                  onTap: () {
                    // ChallengeExploreItem을 ChallengeProgress로 변환
                    final challengeProgress = ChallengeProgress(
                      id: challenge.id,
                      title: challenge.title,
                      description: challenge.description,
                      progress: 0.0,
                      todayTask: '새로운 챌린지를 시작해보세요',
                      startDate: DateTime.now(),
                    );
                    onChallengeTap(challengeProgress);
                  },
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
  final ChallengeExploreItem challenge;
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
