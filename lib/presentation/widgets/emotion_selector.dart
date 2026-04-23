// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../domain/entities/emotion_type.dart';

/// A scrollable grid of emotion selection chips.
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: EmotionType.values.map((emotion) {
        final isSelected = emotion == selected;
        return FilterChip(
          selected: isSelected,
          label: Text('${emotion.emoji} ${emotion.label}'),
          onSelected: (_) => onSelect(emotion),
          showCheckmark: false,
          selectedColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.25),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.white24,
          ),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}
