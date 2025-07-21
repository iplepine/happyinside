import 'package:flutter/material.dart';

class SleepDragHandler {
  final Function(String?) onModeChanged;
  final GlobalKey buttonKey;

  SleepDragHandler({required this.onModeChanged, required this.buttonKey});

  void handleDragStart(Offset startPosition) {
    final buttonRenderBox =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (buttonRenderBox == null) return;

    final buttonRect =
        buttonRenderBox.localToGlobal(Offset.zero) & buttonRenderBox.size;

    // 버튼 영역에서 드래그가 시작되었는지 확인
    if (buttonRect.contains(startPosition)) {
      _updateModeFromPosition(startPosition);
    }
  }

  void handleDragUpdate(Offset currentPosition) {
    _updateModeFromPosition(currentPosition);
  }

  void _updateModeFromPosition(Offset globalPosition) {
    final screenWidth = MediaQuery.of(buttonKey.currentContext!).size.width;
    final centerX = screenWidth / 2;

    // 화면 중앙을 기준으로 왼쪽은 밤, 오른쪽은 아침
    String mode;
    if (globalPosition.dx < centerX - 20) {
      mode = 'night'; // 왼쪽 - 밤
    } else if (globalPosition.dx > centerX + 20) {
      mode = 'morning'; // 오른쪽 - 아침
    } else {
      mode = 'default'; // 중앙 - 기본
    }

    onModeChanged(mode == 'default' ? null : mode);
  }
}
