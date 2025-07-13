import 'package:flutter/material.dart';

class ScoreSlider extends StatelessWidget {
  final int score;
  final double sliderWidth;
  final Animation<double> opacity;

  static const List<String> emojis = ['😢', '😕', '😐', '🙂', '😄'];

  const ScoreSlider({
    super.key,
    required this.score,
    required this.opacity,
    this.sliderWidth = 220,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: SizedBox(
        width: sliderWidth,
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (i) {
            final currentScore = i + 1;
            final isSelected = score == currentScore;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: isSelected ? 48 : 32,
              height: isSelected ? 48 : 32,
              decoration: BoxDecoration(
                color: isSelected ? Colors.amber : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 2),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.amber.withAlpha(77),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                '$currentScore',
                style: TextStyle(
                  fontSize: isSelected ? 24 : 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.amber,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
