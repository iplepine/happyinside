import 'package:flutter/material.dart';

class EmotionPatternWidget extends StatelessWidget {
  const EmotionPatternWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.05),
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
              Icon(Icons.analytics, color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                '감정 패턴 분석',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 긍정/부정 비율
          Row(
            children: [
              Expanded(
                child: _EmotionRatioCard(
                  title: '긍정적',
                  percentage: 75,
                  color: Colors.green,
                  emoji: '😊',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _EmotionRatioCard(
                  title: '부정적',
                  percentage: 25,
                  color: Colors.orange,
                  emoji: '😔',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 자주 느낀 감정
          Text(
            '자주 느낀 감정',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _EmotionChip(emoji: '😊', label: '행복', count: 12),
              _EmotionChip(emoji: '😌', label: '평온', count: 8),
              _EmotionChip(emoji: '😤', label: '스트레스', count: 5),
              _EmotionChip(emoji: '😴', label: '피곤', count: 3),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmotionRatioCard extends StatelessWidget {
  final String title;
  final int percentage;
  final Color color;
  final String emoji;

  const _EmotionRatioCard({
    required this.title,
    required this.percentage,
    required this.color,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$percentage%',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmotionChip extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;

  const _EmotionChip({
    required this.emoji,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji),
          const SizedBox(width: 4),
          Text(
            '$label ($count)',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
