import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:happyinside/shared/services/quote_service.dart';

import 'controllers/home_controller.dart';
import 'intent/home_intent.dart';
import 'state/home_state.dart';
import 'widgets/animated_score_button.dart';
import 'widgets/score_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView>
    with SingleTickerProviderStateMixin {
  late final HomeController _controller;
  int _currentPage = 0;
  late final PageController _pageController = PageController(
    viewportFraction: 0.85,
  );
  bool _shouldScrollToTop = false;

  // --- 명언 ---
  late final QuoteService _quoteService;
  late final Map<String, String> _dailyQuote;

  // --- 오버레이 및 제스처 상태 ---
  OverlayEntry? _overlayEntry;
  int _sliderScore = 4;
  final double _sliderWidth = 220;
  Offset? _lastDragPosition;
  bool _isDragging = false; // 현재 드래그/선택 중인지 상태

  // --- 애니메이션 상태 ---
  late AnimationController _animationController;
  late Animation<Rect?> _heroAnimation;
  final GlobalKey _fabKey = GlobalKey(); // FAB 위치 추적용

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.addListener(_onStateChanged);
    _controller.onIntent(LoadRecentRecords());

    _quoteService = QuoteService();
    _dailyQuote = _quoteService.getQuoteOfTheDay();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onStateChanged() => setState(() {});

  void _goToWritePage(BuildContext context, int score) {
    context.push('/write', extra: score).then((result) {
      if (result == true) {
        _shouldScrollToTop = true;
        _controller.onIntent(LoadRecentRecords());
      }
    });
  }

  // --- Gesture Handling ---
  void _handleDragStart(Offset startPosition) {
    final fabRenderBox =
        _fabKey.currentContext?.findRenderObject() as RenderBox?;
    if (fabRenderBox == null) return;

    final fabRect = fabRenderBox.localToGlobal(Offset.zero) & fabRenderBox.size;

    // FAB 영역에서 드래그가 시작되었는지 확인
    if (fabRect.contains(startPosition)) {
      setState(() {
        _isDragging = true;
        _lastDragPosition = startPosition;
      });
      _updateScoreFromLocal(startPosition);
    }
  }

  void _handleDragUpdate(Offset currentPosition) {
    if (!_isDragging) return;

    setState(() {
      _lastDragPosition = currentPosition;
    });
    _updateScoreFromLocal(currentPosition);
  }

  void _handleDragEnd() {
    if (!_isDragging) return;

    // 드래그가 끝나면 항상 점수와 함께 쓰기 페이지로 이동
    _goToWritePage(context, _sliderScore);

    setState(() {
      _isDragging = false;
      _lastDragPosition = null;
      _sliderScore = 3; // 기본값으로 리셋
    });
  }

  void _updateScoreFromLocal(Offset globalPosition) {
    // 화면 중앙에 배치된 슬라이더의 위치를 기준으로 점수 계산
    final screenWidth = MediaQuery.of(context).size.width;
    final sliderStartX = (screenWidth - _sliderWidth) / 2;
    final sliderEndX = sliderStartX + _sliderWidth;

    // 드래그 위치가 슬라이더 범위 내에 있는지 확인
    double dx = globalPosition.dx.clamp(sliderStartX, sliderEndX);

    // 슬라이더 내에서의 상대적 위치 계산 (0.0 ~ 1.0)
    double relativePosition = (dx - sliderStartX) / _sliderWidth;

    // 5개 점수로 변환 (1~5)
    int score = (relativePosition * 5).floor() + 1;
    score = score.clamp(1, 5);

    if (_sliderScore != score) {
      setState(() {
        _sliderScore = score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    if (_shouldScrollToTop && state.recentRecords.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      });
      _shouldScrollToTop = false; // 플래그 리셋
    }

    // GestureDetector가 전체 화면 터치를 감지하도록 함
    return GestureDetector(
      onPanStart: (details) => _handleDragStart(details.globalPosition),
      onPanUpdate: (details) => _handleDragUpdate(details.globalPosition),
      onPanEnd: (details) => _handleDragEnd(),
      onTap: () {
        // 드래그 중이 아닐 때 탭하면 취소
        if (_isDragging) {
          setState(() {
            _isDragging = false;
            _lastDragPosition = null;
            _sliderScore = 3;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('해피 인사이드'),
          centerTitle: true,
          elevation: 0,
        ),
        // Stack을 사용하여 위젯들을 겹치게 함
        body: Stack(
          children: [
            // --- 기본 UI ---
            Positioned.fill(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildRecentRecords(context, state),
                      ),
                      if (state.recentRecords.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: _buildPageIndicator(state),
                        ),
                      const SizedBox(height: 24),
                      const Divider(indent: 32, endIndent: 32),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: _buildQuoteOfTheDay(),
                      ),
                      SizedBox(height: 96 + bottomPadding), // FAB와 하단 여백 공간
                    ],
                  ),
                ),
              ),
            ),

            // --- FAB ---
            // Positioned를 사용하여 FAB를 화면 하단 중앙에 배치
            Positioned(
              bottom: 32 + bottomPadding, // 하단 패딩 적용
              left: 0,
              right: 0,
              child: Opacity(
                opacity: _isDragging ? 0.0 : 1.0,
                child: _buildFAB(context, state),
              ),
            ),

            // --- Score Slider (오버레이) ---
            if (_isDragging)
              Positioned(
                bottom: 32 + bottomPadding, // 하단 패딩 적용
                left: 0,
                right: 0,
                child: Center(
                  child: ScoreSlider(
                    score: _sliderScore,
                    sliderWidth: _sliderWidth,
                    opacity: const AlwaysStoppedAnimation(1), // 항상 표시
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRecords(BuildContext context, HomeState state) {
    if (state.recentRecords.isEmpty) {
      return SizedBox(
        height: 160, // 높이 증가
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
    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      child: SizedBox(
        height: 160, // 높이 증가
        width: double.infinity,
        child: PageView.builder(
          clipBehavior: Clip.none,
          itemCount: state.recentRecords.length,
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            final record = state.recentRecords[index];
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
                      BoxShadow(
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
                        maxLines: 3, // 3줄로 복원
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
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
  }

  Widget _buildPageIndicator(HomeState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(state.recentRecords.length, (index) {
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

  Widget _buildQuoteOfTheDay() {
    return Column(
      children: [
        Text(
          '“${_dailyQuote['quote']!}”',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '- ${_dailyQuote['author']!} -',
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

  Widget _buildFAB(BuildContext context, HomeState state) {
    // 이제 GestureDetector는 필요 없음
    return SizedBox(
      key: _fabKey,
      child: AnimatedScoreButton(
        selectedScore: _isDragging ? _sliderScore : null,
      ),
    );
  }
}

// 웹에서도 마우스 드래그로 스와이프가 가능하도록 설정
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
