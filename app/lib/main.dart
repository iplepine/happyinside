import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zestinme/app/app.dart';
import 'package:zestinme/di/injection.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 한국어 날짜 포맷 초기화
  await initializeDateFormatting('ko_KR', null);

  // 의존성 주입 초기화
  await Injection.init();

  runApp(const ProviderScope(child: MyApp()));
}
