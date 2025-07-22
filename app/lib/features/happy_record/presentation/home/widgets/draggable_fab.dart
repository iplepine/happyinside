import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'animated_score_button.dart';

class DraggableFAB extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDragging ? 0.0 : 1.0,
      child: GestureDetector(
        onTapDown: (details) => onDragStart(details.globalPosition),
        onTapUp: (details) => onDragEnd(),
        onPanUpdate: (details) => onDragUpdate(details.globalPosition),
        onPanEnd: (details) => onDragEnd(),
        dragStartBehavior: DragStartBehavior.down,
        child: SizedBox(
          key: fabKey,
          width: 80, // 터치 영역 넓힘
          height: 80, // 터치 영역 넓힘
          child: Center(
            child: AnimatedScoreButton(
              selectedScore: isDragging ? selectedScore : null,
            ),
          ),
        ),
      ),
    );
  }
}
