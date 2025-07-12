import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happyinside/app/app.dart';
import 'package:happyinside/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.init();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}
