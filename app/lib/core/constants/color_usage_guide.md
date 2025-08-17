# ZestInMe 색상 팔레트 사용 가이드

## 🎨 색상 철학
**레몬(활력) + 라임(안정)** 조합으로 "상쾌한 습관 → 차분한 성찰"의 브랜드 아이덴티티를 표현합니다.

## 📊 색상 비율
- **뉴트럴(회색/검정/흰색)**: 85%
- **레몬(Primary Accent)**: 10% - CTA 버튼/뱃지/차트 긍정값
- **라임(Secondary Accent)**: 5% - 성공/토글/그래프 보조

## 🎯 역할별 색상 매핑

### Primary (레몬) - `#FFD300`
**용도**: 주요 액션, 하이라이트, CTA 버튼
- "오늘 기록하기" 버튼
- 긍정적인 차트 값
- 중요 알림/뱃지
- 플로팅 액션 버튼

### Secondary (라임) - `#6CCB2C`
**용도**: 성공 상태, 안정, 웰빙
- 완료된 챌린지
- 성공 배지
- 토글 ON 상태
- 진행률 표시

### 뉴트럴 색상
- **Background**: `#FFFFFF` (라이트) / `#101418` (다크)
- **Surface**: `#FFFFFF` (라이트) / `#14181C` (다크)
- **Text**: `#1F2429` (라이트) / `#E1E6EC` (다크)
- **Outline**: `#C3CAD3` (라이트) / `#4A5568` (다크)

## 🖥️ 화면별 적용 예시

### Home 화면
- 상단 인사말: 뉴트럴 텍스트
- "오늘 기록하기" 버튼: 레몬 `#FFD300`
- 챌린지 카드: 뉴트럴 배경
- 완료된 챌린지: 라임 `#6CCB2C`

### Insights 화면
- 긍정적인 막대/도넛: 레몬
- 성공 배지: 라임
- 중립 데이터: 뉴트럴 회색
- 나머지 요소: 뉴트럴

### Settings 화면
- 토글 ON: 라임
- Export 버튼: 뉴트럴 (기본)
- 파괴적 액션: 에러 레드 `#E53935`

## ♿ 접근성 가이드라인

### 텍스트 대비
- **레몬 위 텍스트**: 진한 잉크 `#101418` (대비 4.5:1 이상)
- **라임 위 텍스트**: 진한 녹색 `#0B1407`
- **작은 텍스트는 레몬 배경 위에 금지**

### 터치 영역
- 최소 48dp 터치 영역 보장
- 버튼 간격 최소 8dp

## 🎨 사용법

### 테마에서 색상 사용
```dart
// 테마 색상 사용
color: Theme.of(context).colorScheme.primary, // 레몬
color: Theme.of(context).colorScheme.secondary, // 라임
```

### 직접 색상 사용
```dart
import 'package:zestinme/core/constants/app_colors.dart';

// 직접 색상 사용
color: AppColors.lemon,
color: AppColors.lime,
color: AppColors.roleColors['cta'],
```

### 그라데이션 사용
```dart
decoration: BoxDecoration(
  gradient: AppColors.lemonGradient,
),
```

## 🔄 다크 모드

### Primary (다크)
- `#FFDB26` - 채도 살짝 낮춘 골드
- onPrimary: `#101418`

### Secondary (다크)
- `#57B21F` - 어두운 라임
- onSecondary: `#E1E6EC`

### 배경
- Background: `#101418`
- Surface: `#14181C`
- Text: `#E1E6EC`

## ⚠️ 주의사항

1. **레몬 과다 사용 금지**: 눈부시고 피곤함을 유발
2. **텍스트 대비 확인**: 레몬 위 작은 텍스트 사용 금지
3. **일관성 유지**: 같은 기능은 항상 같은 색상 사용
4. **접근성 테스트**: 색맹 사용자도 구분 가능한지 확인

## 🧪 테스트 체크리스트

- [ ] 라이트/다크 모드 모두 테스트
- [ ] 텍스트 대비 4.5:1 이상 확인
- [ ] 색맹 사용자 관점에서 구분 가능한지 확인
- [ ] 레몬 사용량 10% 이하 유지
- [ ] 라임 사용량 5% 이하 유지
