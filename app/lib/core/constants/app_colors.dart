import 'package:flutter/material.dart';

/// ZestInMe 앱 색상 팔레트
/// 레몬(활력) + 라임(안정) 색상 조합
class AppColors {
  // 라이트 모드 색상
  static const lemon = Color(0xFFFFD300); // 레몬 - CTA/하이라이트
  static const lemonLight = Color(0xFFFFF4B8); // 연한 레몬
  static const lime = Color(0xFF6CCB2C); // 라임 - 성공/안정
  static const limeLight = Color(0xFFEAF6D8); // 연한 라임

  // 뉴트럴 색상
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF101418);
  static const ink = Color(0xFF1F2429);
  static const inkLight = Color(0xFFC3CAD3);
  static const surfaceVariant = Color(0xFFF8F9FA);

  // 다크 모드 색상
  static const lemonDark = Color(0xFFFFDB26); // 채도 낮춘 골드
  static const lemonDarkContainer = Color(0xFF2A2A1A);
  static const limeDark = Color(0xFF57B21F);
  static const limeDarkContainer = Color(0xFF1A2E0F);
  static const backgroundDark = Color(0xFF101418);
  static const surfaceDark = Color(0xFF14181C);
  static const inkDark = Color(0xFFE1E6EC);
  static const outlineDark = Color(0xFF4A5568);

  // 상태 색상
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFFA726);
  static const info = Color(0xFF3A84FF);
  static const success = lime;

  // 투명도 변형
  static Color lemonWithOpacity(double opacity) => lemon.withOpacity(opacity);
  static Color limeWithOpacity(double opacity) => lime.withOpacity(opacity);
  static Color inkWithOpacity(double opacity) => ink.withOpacity(opacity);

  // 그라데이션
  static const lemonGradient = LinearGradient(
    colors: [lemon, lemonLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const limeGradient = LinearGradient(
    colors: [lime, limeLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 역할별 색상 매핑
  static const Map<String, Color> roleColors = {
    'cta': lemon, // 주요 액션 버튼
    'success': lime, // 성공/완료 상태
    'warning': warning, // 경고
    'error': error, // 오류
    'info': info, // 정보
    'neutral': inkLight, // 중립/비활성
  };

  // 접근성을 위한 대비 색상
  static final Map<Color, Color> contrastColors = {
    lemon: black, // 레몬 위 텍스트는 검정
    lime: Color(0xFF0B1407), // 라임 위 텍스트는 진한 녹색
    lemonDark: black, // 다크 레몬 위 텍스트는 검정
    limeDark: inkDark, // 다크 라임 위 텍스트는 밝은 잉크
  };
}
