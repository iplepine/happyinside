# ZestInMe 색상 팔레트 사용 가이드 (CSS 변수 기반)

## 🎨 색상 철학
**레몬 테마의 풍부한 색상 시스템**으로 "상쾌하고 따뜻한 사용자 경험"을 제공합니다.

## 📊 색상 비율
- **뉴트럴(흰색/회색)**: 70%
- **Primary(레몬)**: 20% - 주요 액션/하이라이트
- **Secondary/Accent**: 10% - 보조 요소/강조

## 🎯 역할별 색상 매핑

### Primary - `#FFE135`
**용도**: 주요 액션, 하이라이트, CTA 버튼
- "오늘의 감정 기록하기" 버튼
- 선택된 탭
- 주요 알림/뱃지
- 플로팅 액션 버튼

### Secondary - `#FFF8C4`
**용도**: 보조 요소, 카드 배경, 테두리
- 카드 배경
- 보조 버튼
- 테두리
- 비활성 상태

### Accent - `#FFF59D`
**용도**: 강조, 성공 상태, 특별한 요소
- 성공 배지
- 강조 요소
- 특별한 카드
- 진행률 표시

### Muted - `#FFFAEB`
**용도**: 배경, 비활성, 부드러운 요소
- 전체 배경
- 비활성 텍스트
- 부드러운 구분선
- 힌트 텍스트

## 🖥️ 화면별 적용 예시

### Home 화면
- 전체 배경: `muted` (`#FFFAEB`)
- 상단 인사말: `foreground` (`#2A2A00`)
- 메인 버튼: `primary` (`#FFE135`) + `primaryForeground` (`#2A2A00`)
- 카드 배경: `card` (`#FFFFFF`)
- 탭 선택: `primary` (`#FFE135`)
- 탭 비선택: `accent` (`#FFF59D`)

### Insights 화면
- 차트 색상: `chart1` ~ `chart5` 그라데이션
- 성공 배지: `accent` (`#FFF59D`)
- 중립 데이터: `mutedForeground` (`#717182`)
- 나머지 요소: `card` + `cardForeground`

### Settings 화면
- 토글 ON: `accent` (`#FFF59D`)
- Export 버튼: `secondary` (`#FFF8C4`)
- 파괴적 액션: `destructive` (`#D4183D`)

## ♿ 접근성 가이드라인

### 텍스트 대비
- **Primary 위 텍스트**: `primaryForeground` (`#2A2A00`) - 대비 4.5:1 이상
- **Secondary 위 텍스트**: `secondaryForeground` (`#2A2A00`)
- **Accent 위 텍스트**: `accentForeground` (`#2A2A00`)
- **작은 텍스트는 Primary 배경 위에 금지**

### 터치 영역
- 최소 48dp 터치 영역 보장
- 버튼 간격 최소 8dp

## 🎨 사용법

### 직접 색상 사용
```dart
import 'package:zestinme/core/constants/app_colors.dart';

// 기본 색상
color: AppColors.primary,
color: AppColors.secondary,
color: AppColors.accent,
color: AppColors.muted,

// 포그라운드 색상
color: AppColors.primaryForeground,
color: AppColors.secondaryForeground,
color: AppColors.accentForeground,
color: AppColors.mutedForeground,
```

### 역할별 색상 사용
```dart
// 역할별 색상 매핑
color: AppColors.roleColors['primary'],
color: AppColors.roleColors['success'],
color: AppColors.roleColors['warning'],
color: AppColors.roleColors['destructive'],
```

### 그라데이션 사용
```dart
// Primary 그라데이션
decoration: BoxDecoration(
  gradient: AppColors.primaryGradient,
),

// 차트 그라데이션
decoration: BoxDecoration(
  gradient: AppColors.chartGradient,
),
```

### 투명도 변형
```dart
// 투명도 적용
color: AppColors.primaryWithOpacity(0.8),
color: AppColors.secondaryWithOpacity(0.6),
color: AppColors.accentWithOpacity(0.4),
```

## 🔄 다크 모드

### Primary (다크)
- `#FFE135` - 동일한 primary 색상
- `primaryForeground`: `#2A2A00`

### Secondary (다크)
- `#4A4A00` - 어두운 secondary
- `secondaryForeground`: `#FFE135`

### 배경
- Background: `#252525` (oklch(0.145 0 0))
- Card: `#252525`
- Text: `#FBFBFB` (oklch(0.985 0 0))

## 📐 반지름 값

```dart
// CSS 변수 기반 반지름
borderRadius: BorderRadius.circular(AppColors.radius), // 10px
borderRadius: BorderRadius.circular(AppColors.radiusSm), // 6px
borderRadius: BorderRadius.circular(AppColors.radiusMd), // 8px
borderRadius: BorderRadius.circular(AppColors.radiusLg), // 10px
borderRadius: BorderRadius.circular(AppColors.radiusXl), // 14px
```

## 🎨 차트 색상

```dart
// 차트 색상 배열
final chartColors = AppColors.chartColors; // [chart1, chart2, chart3, chart4, chart5]

// 개별 차트 색상
color: AppColors.chart1, // #FFE135
color: AppColors.chart2, // #FFF176
color: AppColors.chart3, // #FFCC02
color: AppColors.chart4, // #F9A825
color: AppColors.chart5, // #FF8F00
```

## ⚠️ 주의사항

1. **Primary 과다 사용 금지**: 눈부시고 피곤함을 유발
2. **텍스트 대비 확인**: Primary 위 작은 텍스트 사용 금지
3. **일관성 유지**: 같은 기능은 항상 같은 색상 사용
4. **접근성 테스트**: 색맹 사용자도 구분 가능한지 확인
5. **다크 모드 고려**: 모든 색상이 다크 모드에서도 적절한지 확인

## 🧪 테스트 체크리스트

- [ ] 라이트/다크 모드 모두 테스트
- [ ] 텍스트 대비 4.5:1 이상 확인
- [ ] 색맹 사용자 관점에서 구분 가능한지 확인
- [ ] Primary 사용량 20% 이하 유지
- [ ] Secondary/Accent 사용량 10% 이하 유지
- [ ] 반지름 값 일관성 확인
- [ ] 차트 색상 그라데이션 효과 확인
