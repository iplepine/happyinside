import 'package:flutter/material.dart';

class FloatingWriteButton extends StatelessWidget {
  final VoidCallback onTap;

  const FloatingWriteButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 8,
      icon: const Icon(Icons.add, size: 24),
      label: const Text(
        '감정 기록하기',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
} 