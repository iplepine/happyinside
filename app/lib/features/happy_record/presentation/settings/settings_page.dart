import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: const Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: theme.colorScheme.background,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // 계정 설정
                  _SettingsSection(
                    title: '계정',
                    items: [
                      _SettingsItem(
                        icon: Icons.person,
                        title: '프로필 설정',
                        subtitle: '이름, 프로필 사진 변경',
                        onTap: () {
                          // 프로필 설정 페이지로 이동
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.notifications,
                        title: '알림 설정',
                        subtitle: '푸시 알림 관리',
                        onTap: () {
                          // 알림 설정 페이지로 이동
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 데이터 관리
                  _SettingsSection(
                    title: '데이터',
                    items: [
                      _SettingsItem(
                        icon: Icons.download,
                        title: '데이터 내보내기',
                        subtitle: '기록 데이터를 파일로 저장',
                        onTap: () {
                          // 데이터 내보내기
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.delete,
                        title: '데이터 삭제',
                        subtitle: '모든 기록 데이터 삭제',
                        onTap: () {
                          // 데이터 삭제 확인 다이얼로그
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 앱 정보
                  _SettingsSection(
                    title: '앱 정보',
                    items: [
                      _SettingsItem(
                        icon: Icons.info,
                        title: '버전 정보',
                        subtitle: 'v1.0.0',
                        onTap: () {
                          // 버전 정보 표시
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.privacy_tip,
                        title: '개인정보 처리방침',
                        subtitle: '개인정보 수집 및 이용 안내',
                        onTap: () {
                          // 개인정보 처리방침 페이지로 이동
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.description,
                        title: '이용약관',
                        subtitle: '서비스 이용 약관',
                        onTap: () {
                          // 이용약관 페이지로 이동
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 지원
                  _SettingsSection(
                    title: '지원',
                    items: [
                      _SettingsItem(
                        icon: Icons.help,
                        title: '도움말',
                        subtitle: '자주 묻는 질문',
                        onTap: () {
                          // 도움말 페이지로 이동
                        },
                      ),
                      _SettingsItem(
                        icon: Icons.email,
                        title: '문의하기',
                        subtitle: '개발팀에게 문의',
                        onTap: () {
                          // 문의하기 페이지로 이동
                        },
                      ),
                    ],
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

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: items.map((item) => item).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.onSurface.withOpacity(0.5),
      ),
      onTap: onTap,
    );
  }
} 