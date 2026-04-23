import 'package:flutter/material.dart';

import '../../domain/entities/emotion_type.dart';

/// A scrollable wrap of emotion selection chips.
///
/// Each chip renders a Material icon alongside the emotion label.
/// Styling is driven entirely by the ambient [ChipThemeData] set in
/// [AppTheme] — no hardcoded colours here.
class EmotionSelector extends StatelessWidget {
  const EmotionSelector({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final EmotionType? selected;
  final ValueChanged<EmotionType> onSelect;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: EmotionType.values.map((emotion) {
        final isSelected = emotion == selected;
        return FilterChip(
          selected: isSelected,
          avatar: Icon(
            emotion.icon,
            size: 15,
            color:
                isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
          label: Text(emotion.label),
          onSelected: (_) => onSelect(emotion),
          showCheckmark: false,
          selectedColor: colorScheme.primaryContainer,
          side: BorderSide(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
          labelStyle: TextStyle(
            color:
                isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 13,
          ),
        );
      }).toList(),
    );
  }
}
