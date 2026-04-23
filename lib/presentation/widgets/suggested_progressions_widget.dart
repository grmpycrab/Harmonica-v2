import 'package:flutter/material.dart';

import '../../../core/utils/app_spacing.dart';
import '../../../domain/entities/key_analysis.dart';

/// Lists 2–3 suggested progressions for the selected key.
///
/// Tapping a row highlights it and marks it as the active progression for
/// the "Send to Piano Roll" action.
class SuggestedProgressionsWidget extends StatelessWidget {
  const SuggestedProgressionsWidget({
    super.key,
    required this.analysis,
    required this.activeIndex,
    required this.onSelect,
  });

  final KeyAnalysis analysis;
  final int? activeIndex;
  final void Function(int index) onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final progressions = analysis.suggestedProgressions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Progressions',
          style: theme.textTheme.titleSmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapSm,
        ...List.generate(progressions.length, (i) {
          final prog = progressions[i];
          final isActive = activeIndex == i;

          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? cs.primary.withAlpha(30)
                    : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isActive ? cs.primary.withAlpha(160) : cs.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prog.name,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isActive ? cs.primary : cs.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          prog.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isActive
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 16,
                    color: isActive ? cs.primary : cs.outlineVariant,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
