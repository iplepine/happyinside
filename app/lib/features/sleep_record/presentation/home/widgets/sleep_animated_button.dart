import 'package:flutter/material.dart';

class SleepAnimatedButton extends StatelessWidget {
  final String? selectedMode; // 'night' 또는 'morning'

  const SleepAnimatedButton({super.key, this.selectedMode});

  static const _nightIcon = Icons.bedtime;
  static const _morningIcon = Icons.wb_sunny;
  static const _defaultIcon = Icons.bedtime;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color backgroundColor;
    String text;

    if (selectedMode == 'night') {
      icon = _nightIcon;
      backgroundColor = const Color(0xFF1a237e); // 진한 파란색 (밤)
      text = '잠들기 전';
    } else if (selectedMode == 'morning') {
      icon = _morningIcon;
      backgroundColor = const Color(0xFFff6f00); // 주황색 (아침)
      text = '일어난 후';
    } else {
      icon = _defaultIcon;
      backgroundColor = const Color(0xFF667eea); // 기본 그라데이션 색상
      text = '수면 기록';
    }

    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: selectedMode == 'night'
                ? [const Color(0xFF1a237e), const Color(0xFF3949ab)]
                : selectedMode == 'morning'
                ? [const Color(0xFFff6f00), const Color(0xFFff8f00)]
                : [const Color(0xFF667eea), const Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(70),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(70),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        icon,
                        key: ValueKey<IconData>(icon),
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      text,
                      key: ValueKey<String>(text),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '드래그하여 선택하세요',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
