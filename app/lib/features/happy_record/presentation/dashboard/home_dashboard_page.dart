import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/challenge_progress.dart';
import '../../domain/models/emotion_record.dart';
import '../home/widgets/drag_gesture_handler.dart';
import '../home/widgets/score_slider.dart';
import 'widgets/challenge_card_list_widget.dart';
import 'widgets/coaching_question_widget.dart';
import 'widgets/floating_write_button.dart';
import 'widgets/greeting_header_widget.dart';
import 'widgets/insight_quote_widget.dart';
import 'widgets/today_emotion_status_widget.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  // Dummy data for testing
  late List<ChallengeProgress> _challenges;
  late EmotionRecord? _todayEmotion;
  late String _coachingQuestion;
  late String _insightQuote;

  // Score slider state
  int _sliderScore = 4;
  final double _sliderWidth = 220;
  bool _isDragging = false;
  final GlobalKey _fabKey = GlobalKey();
  late final DragGestureHandler _dragHandler;

  @override
  void initState() {
    super.initState();
    _loadDummyData();

    _dragHandler = DragGestureHandler(
      sliderWidth: _sliderWidth,
      onScoreChanged: (score) {
        setState(() {
          _sliderScore = score;
        });
      },
      onDragEnd: _handleDragEnd,
      fabKey: _fabKey,
    );
  }

  void _loadDummyData() {
    // Dummy challenges
    _challenges = [
      ChallengeProgress(
        id: '1',
        title: '매일 감정 기록하기',
        description: '30일 동안 매일 감정을 기록하는 챌린지',
        progress: 0.7,
        todayTask: '오늘의 감정을 기록해보세요',
        startDate: DateTime.now().subtract(const Duration(days: 21)),
      ),
      ChallengeProgress(
        id: '2',
        title: '감사 일기 쓰기',
        description: '매일 감사한 일 3가지를 기록하기',
        progress: 0.4,
        todayTask: '오늘 감사한 일을 찾아보세요',
        startDate: DateTime.now().subtract(const Duration(days: 12)),
      ),
      ChallengeProgress(
        id: '3',
        title: '긍정적 사고 연습',
        description: '부정적인 상황에서 긍정적 관점 찾기',
        progress: 0.2,
        todayTask: '어려운 상황에서 긍정적 면을 찾아보세요',
        startDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];

    // Dummy today emotion (null for no record, or actual record)
    _todayEmotion = EmotionRecord(
      id: '1',
      score: 8,
      emotion: '행복',
      emoji: '😊',
      recordedAt: DateTime.now(),
      note: '오늘은 정말 좋은 하루였어요!',
    );

    // Dummy coaching question
    _coachingQuestion = '오늘 당신을 미소짓게 만든 것은 무엇인가요?';

    // Dummy insight quote
    _insightQuote = '행복은 외부에서 오는 것이 아니라 내면에서 시작됩니다.';
  }

  void _onRecordEmotion() {
    // 점수 슬라이더로 이동
    context.push('/write');
  }

  void _onAnswerCoachingQuestion() {
    // 코칭 질문 답변 페이지로 이동
    context.push('/write');
  }

  void _onMoreChallenges() {
    // 챌린지 목록 페이지로 이동
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('챌린지 목록 페이지로 이동합니다')));
  }

  void _handleDragEnd() {
    setState(() {
      _isDragging = false;
    });
    _goToWritePage(_sliderScore);
  }

  void _goToWritePage(int score) {
    context.push('/write', extra: score).then((result) {
      if (result == true) {
        setState(() {
          // 기록 완료 후 상태 업데이트
          _loadDummyData();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // 1. 상단 인사말
                      GreetingHeaderWidget(
                        username: '영도자',
                        todayEmotionCount: _todayEmotion != null ? 1 : 0,
                        challengeCount: _challenges.length,
                      ),

                      const SizedBox(height: 20),

                      // 2. 오늘 감정 기록 영역
                      TodayEmotionStatusWidget(
                        emotionRecord: _todayEmotion,
                        onRecordTap: _onRecordEmotion,
                      ),

                      const SizedBox(height: 32),

                      // 3. 진행 중인 챌린지 리스트
                      ChallengeCardListWidget(
                        challenges: _challenges,
                        onMoreTap: _onMoreChallenges,
                      ),

                      const SizedBox(height: 32),

                      // 4. 오늘의 질문 (코칭 질문)
                      CoachingQuestionWidget(
                        questionText: _coachingQuestion,
                        onAnswerTap: _onAnswerCoachingQuestion,
                      ),

                      const SizedBox(height: 24),

                      // 5. 인사이트 명언 카드
                      InsightQuoteWidget(
                        quoteText: _insightQuote,
                        author: '마음의 소리',
                      ),

                      // 하단 여백 (플로팅 버튼과 겹치지 않도록)
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
            // 점수 슬라이더 오버레이
            if (_isDragging)
              Positioned.fill(
                child: GestureDetector(
                  onPanStart: (details) {
                    _dragHandler.handleDragStart(details.globalPosition);
                  },
                  onPanUpdate: (details) {
                    _dragHandler.handleDragUpdate(details.globalPosition);
                  },
                  onPanEnd: (details) {
                    _dragHandler.handleDragEnd();
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: ScoreSlider(
                        score: _sliderScore,
                        sliderWidth: _sliderWidth,
                        opacity: const AlwaysStoppedAnimation(1.0),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingWriteButton(
        key: _fabKey,
        onTap: () {
          setState(() {
            _isDragging = true;
          });
        },
      ),
    );
  }
}
