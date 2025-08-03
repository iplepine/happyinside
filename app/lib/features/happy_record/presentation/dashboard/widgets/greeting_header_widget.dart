import 'package:flutter/material.dart';

class GreetingHeaderWidget extends StatelessWidget {
  final String username;
  final int todayEmotionCount;
  final int challengeCount;

  const GreetingHeaderWidget({
    super.key,
    required this.username,
    required this.todayEmotionCount,
    required this.challengeCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final hour = now.hour;
    
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 18) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $username님.',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '오늘 ${todayEmotionCount}개의 감정을 기록하셨네요.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          if (challengeCount > 0) ...[
            const SizedBox(height: 4),
            Text(
              '진행 중인 챌린지가 ${challengeCount}개 있어요.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
} 