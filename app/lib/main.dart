import 'package:flutter/material.dart';
import 'app/app.dart';
import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 의존성 주입 초기화
  await Injection.init();
  
  runApp(const MyApp());
}
