import 'package:flutter/material.dart';

import '../../../core/utils/app_spacing.dart';
import '../../../domain/entities/music_key.dart';

/// Shows the dominant, subdominant, and relative keys for the selected key.
class RelatedKeysWidget extends StatelessWidget {
  const RelatedKeysWidget({
    super.key,
    required this.selectedKey,
    required this.onKeyTap,
  });

  final MusicKey selectedKey;
  final void Function(String tonic, {required bool isMajor}) onKeyTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Keys',
          style: theme.textTheme.titleSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapSm,
        Row(
          children: [
            _RelatedChip(
              relationship: 'Subdominant',
              tonic: selectedKey.subdominantKey,
              isMajor: selectedKey.isMajor,
              color: cs.secondary,
              onTap: () => onKeyTap(
                selectedKey.subdominantKey,
                isMajor: selectedKey.isMajor,
              ),
            ),
            AppSpacing.hGapSm,
            _RelatedChip(
              relationship: 'Dominant',
              tonic: selectedKey.dominantKey,
              isMajor: selectedKey.isMajor,
              color: cs.tertiary,
              onTap: () => onKeyTap(
                selectedKey.dominantKey,
                isMajor: selectedKey.isMajor,
              ),
            ),
            AppSpacing.hGapSm,
            _RelatedChip(
              relationship: 'Relative',
              tonic: selectedKey.relativeKey,
              isMajor: !selectedKey.isMajor,
              color: cs.primary,
              onTap: () => onKeyTap(
                selectedKey.relativeKey,
                isMajor: !selectedKey.isMajor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RelatedChip extends StatelessWidget {
  const _RelatedChip({
    required this.relationship,
    required this.tonic,
    required this.isMajor,
    required this.color,
    required this.onTap,
  });

  final String relationship;
  final String tonic;
  final bool isMajor;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = '$tonic ${isMajor ? 'maj' : 'min'}';

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withAlpha(80)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                relationship,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
                  letterSpacing: 0.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
