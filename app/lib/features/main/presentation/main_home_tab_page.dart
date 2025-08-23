import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zestinme/core/constants/app_colors.dart';
import '../../../core/providers/session_provider.dart';

class MainHomeTabPage extends ConsumerStatefulWidget {
  const MainHomeTabPage({super.key});

  @override
  ConsumerState<MainHomeTabPage> createState() => _MainHomeTabPageState();
}

class _MainHomeTabPageState extends ConsumerState<MainHomeTabPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final userName = ref.watch(userNameProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // 상단 헤더 섹션
              _buildHeaderSection(isLoggedIn, userName),

              const SizedBox(height: 24),

              // 메인 액션 버튼
              _buildMainActionButton(),

              const SizedBox(height: 24),

              // 기록 요약 섹션
              _buildRecordSummarySection(),

              const SizedBox(height: 16),

              // 하단 액션 링크
              _buildSecondaryActionLink(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isLoggedIn, String? userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 왼쪽 인사말
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '안녕하세요! 🍋',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: AppColors.fontWeightMedium,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '오늘도 상큼한 하루 되세요',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),

        // 오른쪽 배지
        if (isLoggedIn)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.ring, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.flash_on,
                  color: AppColors.primaryForeground,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '7일',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryForeground,
                    fontWeight: AppColors.fontWeightMedium,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMainActionButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () {
          context.push('/happy');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryForeground,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😊', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              '오늘의 감정 기록하기',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: AppColors.fontWeightMedium,
                color: AppColors.primaryForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordSummarySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.muted, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(
            '기록 요약',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: AppColors.fontWeightMedium,
              color: AppColors.foreground,
            ),
          ),

          const SizedBox(height: 20),

          // 탭바
          _buildTabBar(),

          const SizedBox(height: 20),

          // 통계 박스들
          _buildStatsBoxes(),

          const SizedBox(height: 30),

          // 빈 상태 표시
          _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = [
      {'label': '오늘', 'icon': Icons.access_time},
      {'label': '이번 주', 'icon': Icons.calendar_today},
      {'label': '이번 달', 'icon': Icons.show_chart},
    ];

    return Row(
      children: tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;
        final isSelected = index == _selectedTabIndex;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: index < tabs.length - 1 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 16,
                    color: isSelected
                        ? AppColors.primaryForeground
                        : AppColors.foreground,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tab['label'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: AppColors.fontWeightMedium,
                      color: isSelected
                          ? AppColors.primaryForeground
                          : AppColors.foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsBoxes() {
    final stats = [
      {
        'label': '총 기록',
        'count': '0',
        'color': AppColors.primary.withOpacity(0.05),
        'textColor': AppColors.mutedForeground,
      },
      {
        'label': '좋은 기록',
        'count': '0',
        'color': AppColors.primary.withOpacity(0.05),
        'textColor': AppColors.mutedForeground,
      },
      {
        'label': '힘든 기록',
        'count': '0',
        'color': AppColors.primary.withOpacity(0.05),
        'textColor': AppColors.mutedForeground,
      },
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: stat == stats.last ? 0 : 8),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: stat['color'] as Color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Text(
                  stat['count'] as String,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: AppColors.fontWeightMedium,
                    color: stat['textColor'] as Color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['label'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mutedForeground,
                    fontWeight: AppColors.fontWeightMedium,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        // 레몬 아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.emoji_nature, color: AppColors.primary, size: 40),
        ),

        const SizedBox(height: 16),

        // 빈 상태 텍스트
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '오늘 기록이 없습니다',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: AppColors.fontWeightMedium,
                color: AppColors.foreground,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),

        const SizedBox(height: 4),

        Text(
          '오늘 첫 기록을 남겨보세요!',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.mutedForeground),
        ),
      ],
    );
  }

  Widget _buildSecondaryActionLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          // 힘든 일 기록하기 페이지로 이동
          context.push('/difficult');
        },
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mutedForeground,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('😔', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '힘든 일 기록하기',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mutedForeground,
                fontWeight: AppColors.fontWeightNormal,
                decoration: TextDecoration.underline,
                decorationThickness: 1.5,
                decorationColor: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
