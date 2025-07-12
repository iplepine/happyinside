import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:happyinside/shared/services/quote_service.dart';

import 'controllers/home_controller.dart';
import 'intent/home_intent.dart';
import 'state/home_state.dart';
import 'widgets/animated_score_button.dart';
import 'widgets/recent_records_section.dart';
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

class _HomeViewState extends State<_HomeView> {
  late final HomeController _controller;
  bool _shouldScrollToTop = false;

  // --- 명언 ---
  late final QuoteService _quoteService;
  late final Map<String, String> _dailyQuote;

  // --- 오버레이 및 제스처 상태 ---
  int _sliderScore = 4;
  final double _sliderWidth = 220;
  bool _isDragging = false; // 현재 드래그/선택 중인지 상태

  // --- 애니메이션 상태 ---
  final GlobalKey _fabKey = GlobalKey(); // FAB 위치 추적용

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.addListener(_onStateChanged);
    _controller.onIntent(LoadRecentRecords());

    _quoteService = QuoteService();
    _dailyQuote = _quoteService.getQuoteOfTheDay();
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onStateChanged() => setState(() {});

  void _goToWritePage(BuildContext context, int score) {
    context.push('/write', extra: score).then((result) {
      if (result == true) {
        setState(() {
          _shouldScrollToTop = true;
        });
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
      });
      _updateScoreFromLocal(startPosition);
    }
  }

  void _handleDragUpdate(Offset currentPosition) {
    if (!_isDragging) return;
    _updateScoreFromLocal(currentPosition);
  }

  void _handleDragEnd() {
    if (!_isDragging) return;

    // 드래그가 끝나면 항상 점수와 함께 쓰기 페이지로 이동
    _goToWritePage(context, _sliderScore);

    setState(() {
      _isDragging = false;
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

    // 화면 전체의 탭을 감지하여 드래그 취소
    return GestureDetector(
      onTap: () {
        // 드래그 중이 아닐 때 탭하면 취소
        if (_isDragging) {
          setState(() {
            _isDragging = false;
            _sliderScore = 3;
          });
        }
      },
      // Scaffold의 배경을 터치해도 onTap이 감지되도록 동작 설정
      behavior: HitTestBehavior.opaque,
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
                        child: RecentRecordsSection(
                          records: state.recentRecords,
                          shouldScrollToTop: _shouldScrollToTop,
                          onDidScrollToTop: () {
                            setState(() {
                              _shouldScrollToTop = false;
                            });
                          },
                        ),
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
                child: GestureDetector(
                  onTapDown: (details) =>
                      _handleDragStart(details.globalPosition),
                  onTapUp: (details) => _handleDragEnd(),
                  onPanUpdate: (details) =>
                      _handleDragUpdate(details.globalPosition),
                  onPanEnd: (details) => _handleDragEnd(),
                  dragStartBehavior: DragStartBehavior.down,
                  child: _buildFAB(context, state),
                ),
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
