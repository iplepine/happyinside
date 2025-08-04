import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/models/challenge_progress.dart';

class ChallengeCardListWidget extends StatelessWidget {
  final List<ChallengeProgress> challenges;
  final VoidCallback? onMoreTap;

  const ChallengeCardListWidget({
    super.key,
    required this.challenges,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (challenges.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.flag_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              '진행 중인 챌린지가 없어요',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '새로운 챌린지를 시작해보세요!',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '진행 중인 챌린지',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (challenges.length > 3)
                TextButton(
                  onPressed: onMoreTap,
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
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: challenges.length > 3 ? 3 : challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return Container(
                width: 280,
                margin: EdgeInsets.only(
                  right:
                      index <
                          (challenges.length > 3 ? 2 : challenges.length - 1)
                      ? 12
                      : 0,
                ),
                child: _ChallengeCard(
                  challenge: challenge,
                  onTap: () {
                    context.push('/challenge-detail', extra: challenge);
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

class _ChallengeCard extends StatelessWidget {
  final ChallengeProgress challenge;
  final VoidCallback? onTap;

  const _ChallengeCard({required this.challenge, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    challenge.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              challenge.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: challenge.progress,
              backgroundColor: theme.colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '오늘: ${challenge.todayTask}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
