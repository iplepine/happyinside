import '../../core/constants/quotes.dart';

class QuoteService {
  Map<String, String> getQuoteOfTheDay() {
    // 이달의 몇 번째 날인지를 기준으로 인덱스를 계산 (1~31)
    final dayOfMonth = DateTime.now().day;
    final index = dayOfMonth % quotes.length;
    return quotes[index];
  }
}
