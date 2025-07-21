import 'package:flutter/material.dart';

class QuoteOfTheDay extends StatelessWidget {
  final Map<String, String> dailyQuote;

  const QuoteOfTheDay({super.key, required this.dailyQuote});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '"${dailyQuote['quote']!}"',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '- ${dailyQuote['author']!} -',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}
