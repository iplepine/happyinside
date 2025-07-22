import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'animated_score_button.dart';

class DraggableFAB extends StatefulWidget {
  final int? selectedScore;
  final bool isDragging;
  final GlobalKey fabKey;
  final Function(Offset) onDragStart;
  final Function(Offset) onDragUpdate;
  final VoidCallback onDragEnd;

  const DraggableFAB({
    super.key,
    required this.selectedScore,
    required this.isDragging,
    required this.fabKey,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  State<DraggableFAB> createState() => _DraggableFABState();
}

class _DraggableFABState extends State<DraggableFAB> {
  Offset? _panStartPosition;
  bool _dragStarted = false;
  static const double _dragThreshold = 10.0;

  void _handlePanStart(DragStartDetails details) {
    _panStartPosition = details.globalPosition;
    _dragStarted = false;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_panStartPosition == null) return;
    if (!_dragStarted) {
      final distance = (details.globalPosition - _panStartPosition!).distance;
      if (distance > _dragThreshold) {
        _dragStarted = true;
        widget.onDragStart(_panStartPosition!);
      } else {
        return;
      }
    }
    widget.onDragUpdate(details.globalPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_dragStarted) {
      widget.onDragEnd();
    }
    _panStartPosition = null;
    _dragStarted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.isDragging ? 0.0 : 1.0,
      child: GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        dragStartBehavior: DragStartBehavior.down,
        child: SizedBox(
          key: widget.fabKey,
          width: 80, // 터치 영역 넓힘
          height: 80, // 터치 영역 넓힘
          child: Center(
            child: AnimatedScoreButton(
              selectedScore: widget.isDragging ? widget.selectedScore : null,
            ),
          ),
        ),
      ),
    );
  }
}
