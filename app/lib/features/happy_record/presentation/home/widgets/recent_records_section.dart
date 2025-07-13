import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/models/record.dart';

class RecentRecordsSection extends StatefulWidget {
  final List<Record> records;
  final bool shouldScrollToTop;
  final VoidCallback onDidScrollToTop;

  const RecentRecordsSection({
    super.key,
    required this.records,
    this.shouldScrollToTop = false,
    required this.onDidScrollToTop,
  });

  @override
  State<RecentRecordsSection> createState() => _RecentRecordsSectionState();
}

class _RecentRecordsSectionState extends State<RecentRecordsSection> {
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void didUpdateWidget(covariant RecentRecordsSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.shouldScrollToTop &&
        !oldWidget.shouldScrollToTop &&
        widget.records.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
        widget.onDidScrollToTop();
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.records.isEmpty) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.sentiment_dissatisfied, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                '아직 행복 기록이 없어요!\n오늘의 행복을 빠르게 기록해보세요 :)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
                maxLines: 3,
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 180, // 높이를 늘려 오버플로우 방지
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: PageView.builder(
              clipBehavior: Clip.none,
              itemCount: widget.records.length,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final record = widget.records[index];
                return Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: _currentPage == index ? 0 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (_currentPage == index)
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _formatDate(record.createdAt),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            record.content,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          if (record.tags.isNotEmpty)
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 4.0,
                              alignment: WrapAlignment.center,
                              children: record.tags
                                  .map(
                                    (tag) => Chip(
                                      label: Text(
                                        '#$tag',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary.withAlpha(50),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.records.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildPageIndicator(),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.records.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
