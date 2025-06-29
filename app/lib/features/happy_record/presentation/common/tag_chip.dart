import 'package:flutter/material.dart';

/// 태그 칩 위젯
class TagChip extends StatelessWidget {
  final String tag;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TagChip({
    super.key,
    required this.tag,
    this.selected = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: InputChip(
        label: Text(tag),
        selected: selected,
        onSelected: onTap != null ? (_) => onTap!() : null,
        onDeleted: onDelete,
        selectedColor: colorScheme.primary.withOpacity(0.2),
        backgroundColor: colorScheme.secondary.withOpacity(0.1),
        labelStyle: TextStyle(
          color: selected
              ? colorScheme.primary
              : colorScheme.onBackground,
        ),
        side: BorderSide(
          color: selected ? colorScheme.primary : colorScheme.secondary,
          width: selected ? 2 : 1,
        ),
        deleteIconColor: colorScheme.secondary,
      ),
    );
  }
} 