import 'package:flutter/material.dart';

class DragGestureHandler {
  final double sliderWidth;
  final Function(int) onScoreChanged;
  final VoidCallback onDragEnd;
  final GlobalKey fabKey;

  DragGestureHandler({
    required this.sliderWidth,
    required this.onScoreChanged,
    required this.onDragEnd,
    required this.fabKey,
  });

  void handleDragStart(Offset startPosition) {
    final fabRenderBox =
        fabKey.currentContext?.findRenderObject() as RenderBox?;
    if (fabRenderBox == null) return;

    final fabRect = fabRenderBox.localToGlobal(Offset.zero) & fabRenderBox.size;

    // FAB 영역에서 드래그가 시작되었는지 확인
    if (fabRect.contains(startPosition)) {
      _updateScoreFromLocal(startPosition);
    }
  }

  void handleDragUpdate(Offset currentPosition) {
    _updateScoreFromLocal(currentPosition);
  }

  void handleDragEnd() {
    onDragEnd();
  }

  void _updateScoreFromLocal(Offset globalPosition) {
    // 화면 중앙에 배치된 슬라이더의 위치를 기준으로 점수 계산
    final screenWidth = MediaQuery.of(fabKey.currentContext!).size.width;
    final sliderStartX = (screenWidth - sliderWidth) / 2;
    final sliderEndX = sliderStartX + sliderWidth;

    // 드래그 위치가 슬라이더 범위 내에 있는지 확인
    double dx = globalPosition.dx.clamp(sliderStartX, sliderEndX);

    // 슬라이더 내에서의 상대적 위치 계산 (0.0 ~ 1.0)
    double relativePosition = (dx - sliderStartX) / sliderWidth;

    // 5개 점수로 변환 (1~5)
    int score = (relativePosition * 5).floor() + 1;
    score = score.clamp(1, 5);

    onScoreChanged(score);
  }
}
