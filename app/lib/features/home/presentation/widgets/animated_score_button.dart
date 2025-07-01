import 'package:flutter/material.dart';

class AnimatedScoreButton extends StatelessWidget {
  final int? selectedScore;

  const AnimatedScoreButton({super.key, this.selectedScore});

  static const _emojis = ['😢', '😕', '😐', '🙂', '😄'];
  static const _defaultEmoji = '😊';

  @override
  Widget build(BuildContext context) {
    final score = selectedScore;
    final emoji = score != null && score >= 1 && score <= 5
        ? _emojis[score - 1]
        : _defaultEmoji;

    return Material(
      type: MaterialType.transparency,
      child: CircleAvatar(
        radius: 36,
        backgroundColor: Colors.amber,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Text(
            emoji,
            key: ValueKey<String>(emoji),
            style: const TextStyle(fontSize: 36),
          ),
        ),
      ),
    );
  }
} 