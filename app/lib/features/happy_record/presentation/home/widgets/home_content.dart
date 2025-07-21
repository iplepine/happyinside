import 'package:flutter/material.dart';
import 'package:happyinside/core/models/record.dart';

import 'recent_records_section.dart';
import 'quote_of_the_day.dart';

class HomeContent extends StatelessWidget {
  final List<Record> recentRecords;
  final Map<String, String> dailyQuote;
  final bool shouldScrollToTop;
  final VoidCallback onDidScrollToTop;

  const HomeContent({
    super.key,
    required this.recentRecords,
    required this.dailyQuote,
    required this.shouldScrollToTop,
    required this.onDidScrollToTop,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RecentRecordsSection(
                records: recentRecords,
                shouldScrollToTop: shouldScrollToTop,
                onDidScrollToTop: onDidScrollToTop,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(indent: 32, endIndent: 32),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: QuoteOfTheDay(dailyQuote: dailyQuote),
            ),
            SizedBox(height: 96 + bottomPadding), // FAB와 하단 여백 공간
          ],
        ),
      ),
    );
  }
}
