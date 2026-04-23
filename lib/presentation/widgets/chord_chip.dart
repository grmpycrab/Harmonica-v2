// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../domain/entities/chord.dart';

/// A styled chip displaying a single chord name.
class ChordChip extends StatelessWidget {
  const ChordChip({super.key, required this.chord});

  final Chord chord;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.4)),
      ),
      child: Text(
        chord.name,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
