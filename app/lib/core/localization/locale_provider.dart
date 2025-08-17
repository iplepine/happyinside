import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ko', 'KR'));

  void setLocale(Locale locale) {
    state = locale;
  }

  void setKorean() {
    state = const Locale('ko', 'KR');
  }

  void setEnglish() {
    state = const Locale('en', 'US');
  }

  bool get isKorean => state.languageCode == 'ko';
  bool get isEnglish => state.languageCode == 'en';
}
