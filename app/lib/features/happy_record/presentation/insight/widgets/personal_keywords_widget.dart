import 'package:flutter/material.dart';

class PersonalKeywordsWidget extends StatelessWidget {
  const PersonalKeywordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.3),
            theme.colorScheme.secondaryContainer.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                '나를 설명하는 키워드',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            'Nomi가 분석한 당신의 특징',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _KeywordChip(
                keyword: '아침형 인간',
                emoji: '🌅',
                description: '아침에 에너지가 넘쳐요',
              ),
              _KeywordChip(
                keyword: '스트레스 해소는 산책',
                emoji: '🚶‍♂️',
                description: '활동적인 스트레스 해소법',
              ),
              _KeywordChip(
                keyword: '음악 애호가',
                emoji: '🎵',
                description: '음악이 기분 전환의 핵심',
              ),
              _KeywordChip(
                keyword: '규칙적인 수면',
                emoji: '😴',
                description: '안정적인 수면 패턴',
              ),
              _KeywordChip(
                keyword: '감사하는 마음',
                emoji: '🙏',
                description: '일상의 작은 것들에 감사',
              ),
              _KeywordChip(
                keyword: '긍정적 사고',
                emoji: '✨',
                description: '어려운 상황에서도 긍정적',
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '당신은 활동적이고 긍정적인 사람이에요. 규칙적인 생활과 감사하는 마음이 당신의 행복의 비결이네요!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  final String keyword;
  final String emoji;
  final String description;

  const _KeywordChip({
    required this.keyword,
    required this.emoji,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                keyword,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
