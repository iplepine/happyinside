import 'package:flutter/material.dart';
import '../../features/calculator/presentation/pages/calculator_page.dart';

/// 앱 라우터
class AppRouter {
  static const String initial = '/';
  static const String calculator = '/calculator';

  /// 라우트 생성
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(
          builder: (_) => const CalculatorPage(),
        );
      case calculator:
        return MaterialPageRoute(
          builder: (_) => const CalculatorPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('페이지를 찾을 수 없습니다'),
            ),
          ),
        );
    }
  }
} 