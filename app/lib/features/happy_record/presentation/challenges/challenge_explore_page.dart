import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/challenge_progress.dart';
import '../../domain/usecases/get_available_challenges_usecase.dart';

class ChallengeExplorePage extends StatefulWidget {
  const ChallengeExplorePage({super.key});

  @override
  State<ChallengeExplorePage> createState() => _ChallengeExplorePageState();
}

class _ChallengeExplorePageState extends State<ChallengeExplorePage> {
  String _selectedCategory = '전체';
  final List<String> _categories = ['전체', '감정 관리', '습관 형성', '자기계발', '건강', '관계'];
  late final GetAvailableChallengesUseCase _getAvailableChallengesUseCase;
  late List<ChallengeExploreItem> _availableChallenges;

  @override
  void initState() {
    super.initState();
    _getAvailableChallengesUseCase = GetAvailableChallengesUseCase();
    _loadAvailableChallenges();
  }

  void _loadAvailableChallenges() {
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
    
    _availableChallenges = _getAvailableChallengesUseCase(activeChallenges);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text(
          '챌린지 탐색',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 카테고리 필터
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  
                  return Container(
                    margin: EdgeInsets.only(
                      right: index < _categories.length - 1 ? 8 : 0,
                    ),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      backgroundColor: theme.colorScheme.surface,
                      selectedColor: theme.colorScheme.primaryContainer,
                      checkmarkColor: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 챌린지 목록
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _getFilteredChallenges().length,
                itemBuilder: (context, index) {
                  final challenge = _getFilteredChallenges()[index];
                  return _ChallengeExploreCard(
                    challenge: challenge,
                    onTap: () {
                      context.push('/challenge-detail', extra: challenge);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ChallengeExploreItem> _getFilteredChallenges() {
    if (_selectedCategory == '전체') {
      return _availableChallenges;
    }
    
    return _availableChallenges.where((challenge) => 
      challenge.category == _selectedCategory
    ).toList();
  }
}

class _ChallengeExploreCard extends StatelessWidget {
  final ChallengeExploreItem challenge;
  final VoidCallback onTap;

  const _ChallengeExploreCard({
    required this.challenge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
                Text(
                  challenge.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
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
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // 태그들
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _TagChip(
                  label: challenge.category,
                  color: theme.colorScheme.primary,
                ),
                _TagChip(
                  label: challenge.duration,
                  color: Colors.blue,
                ),
                _TagChip(
                  label: challenge.difficulty,
                  color: _getDifficultyColor(challenge.difficulty),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // 참여자 수와 시작 버튼
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  '${challenge.participants}명 참여 중',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('시작하기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case '쉬움':
        return Colors.green;
      case '보통':
        return Colors.orange;
      case '어려움':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TagChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
