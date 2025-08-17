import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('ko', 'KR'), // Korean
    Locale('en', 'US'), // English
  ];

  // Korean translations
  String get appName => _localizedValues[locale.languageCode]!['appName']!;
  String get goodMorning =>
      _localizedValues[locale.languageCode]!['goodMorning']!;
  String get recordEmotionToday =>
      _localizedValues[locale.languageCode]!['recordEmotionToday']!;
  String get recordEmotionButton =>
      _localizedValues[locale.languageCode]!['recordEmotionButton']!;
  String get weeklyStats =>
      _localizedValues[locale.languageCode]!['weeklyStats']!;
  String get weeklyStatsInsight =>
      _localizedValues[locale.languageCode]!['weeklyStatsInsight']!;
  String get dailyQuestion =>
      _localizedValues[locale.languageCode]!['dailyQuestion']!;
  String get dailyQuestionText =>
      _localizedValues[locale.languageCode]!['dailyQuestionText']!;
  String get answerButton =>
      _localizedValues[locale.languageCode]!['answerButton']!;
  String get activeChallenges =>
      _localizedValues[locale.languageCode]!['activeChallenges']!;
  String get noActiveChallenges =>
      _localizedValues[locale.languageCode]!['noActiveChallenges']!;
  String get startNewChallenge =>
      _localizedValues[locale.languageCode]!['startNewChallenge']!;
  String get moreChallenges =>
      _localizedValues[locale.languageCode]!['moreChallenges']!;
  String get progressText =>
      _localizedValues[locale.languageCode]!['progressText']!;

  static final Map<String, Map<String, String>> _localizedValues = {
    'ko': {
      'appName': 'ZestInMe',
      'goodMorning': 'Good Morning, 영도자님 🌞',
      'recordEmotionToday': '오늘의 감정을 기록해볼까요?',
      'recordEmotionButton': '😊 감정 기록하기',
      'weeklyStats': '이번 주: 행복 3, 피곤 2',
      'weeklyStatsInsight': '(가볍게 한눈에 보는 인사이트)',
      'dailyQuestion': '오늘의 질문',
      'dailyQuestionText': '오늘 고마웠던 순간은?',
      'answerButton': '답변하기',
      'activeChallenges': '진행 중인 챌린지 카드',
      'noActiveChallenges': '진행 중인 챌린지가 없습니다',
      'startNewChallenge': '새로운 챌린지를 시작해보세요!',
      'moreChallenges': '더 많은 챌린지 보기',
      'progressText': '진행',
    },
    'en': {
      'appName': 'ZestInMe',
      'goodMorning': 'Good Morning, User 🌞',
      'recordEmotionToday': 'How about recording your emotions today?',
      'recordEmotionButton': '😊 Record Emotion',
      'weeklyStats': 'This week: Happy 3, Tired 2',
      'weeklyStatsInsight': '(Quick insight at a glance)',
      'dailyQuestion': 'Today\'s Question',
      'dailyQuestionText': 'What moment made you grateful today?',
      'answerButton': 'Answer',
      'activeChallenges': 'Active Challenge Cards',
      'noActiveChallenges': 'No active challenges',
      'startNewChallenge': 'Start a new challenge!',
      'moreChallenges': 'View More Challenges',
      'progressText': 'Progress',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ko', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
