import 'package:flutter/material.dart';

import '../../../core/utils/app_spacing.dart';
import '../../../domain/entities/key_analysis.dart';
import '../../../domain/entities/music_key.dart';

/// Displays the seven diatonic chords and their functional groupings for a
/// selected [MusicKey].
class KeyDetailsPanel extends StatelessWidget {
  const KeyDetailsPanel({
    super.key,
    required this.key_,
    required this.analysis,
  });

  final MusicKey key_;
  final KeyAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Heading ────────────────────────────────────────────────────────
        Text(
          'Chords in ${key_.label}',
          style: theme.textTheme.titleSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapSm,

        // ── All 7 degrees in a wrap ────────────────────────────────────────
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children:
              analysis.diatonicChords.map((dc) => _DegreeChip(dc: dc)).toList(),
        ),
        AppSpacing.gapMd,

        // ── Functional groups ─────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FunctionGroup(
              label: 'Tonic',
              chords: analysis.tonicChords,
              color: cs.primary,
            ),
            AppSpacing.hGapMd,
            _FunctionGroup(
              label: 'Predominant',
              chords: analysis.predominantChords,
              color: cs.secondary,
            ),
            AppSpacing.hGapMd,
            _FunctionGroup(
              label: 'Dominant',
              chords: analysis.dominantChords,
              color: cs.tertiary,
            ),
          ],
        ),
      ],
    );
  }
}

class _DegreeChip extends StatelessWidget {
  const _DegreeChip({required this.dc});

  final DiatonicChord dc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dc.degree,
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontSize: 9,
            ),
          ),
          Text(
            dc.chord.name,
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FunctionGroup extends StatelessWidget {
  const _FunctionGroup({
    required this.label,
    required this.chords,
    required this.color,
  });

  final String label;
  final List<DiatonicChord> chords;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          ...chords.map(
            (dc) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                '${dc.degree}  ${dc.chord.name}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
