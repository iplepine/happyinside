import 'dart:math';

import '../../core/constants/quotes.dart';

class QuoteService {
  Map<String, String> getQuoteOfTheDay() {
    final random = Random();
    final index = random.nextInt(quotes.length);
    return quotes[index];
  }
}
