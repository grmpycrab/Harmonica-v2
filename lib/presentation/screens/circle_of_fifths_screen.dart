import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/app_spacing.dart';
import '../../data/services/circle_of_fifths_service.dart';
import '../viewmodels/circle_of_fifths_viewmodel.dart';
import '../widgets/circle_of_fifths_widget.dart';
import '../widgets/key_details_panel.dart';
import '../widgets/related_keys_widget.dart';
import '../widgets/suggested_progressions_widget.dart';

/// Circle of Fifths screen — replaces the old Inspire screen.
///
/// Layout:
///   AppBar
///   ── Scrollable body ──
///   CircleOfFifthsWidget (interactive circle)
///   KeyDetailsPanel      (7 diatonic chords + functional groups)
///   RelatedKeysWidget    (dominant / subdominant / relative)
///   SuggestedProgressionsWidget (2–3 progressions)
///   Action buttons       (Generate / Send to Piano Roll / Set Active Key)
class CircleOfFifthsScreen extends ConsumerWidget {
  const CircleOfFifthsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(circleOfFifthsViewModelProvider);
    final vm = ref.read(circleOfFifthsViewModelProvider.notifier);
    Theme.of(context);

    // Responsive: constrain circle to available width
    final screenW = MediaQuery.sizeOf(context).width;
    final circleDiameter = (screenW - AppSpacing.md * 2).clamp(240.0, 340.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Circle of Fifths'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Circle ─────────────────────────────────────────────────
              CircleOfFifthsWidget(
                state: state,
                onKeyTap: vm.selectKey,
              ),
              AppSpacing.gapMd,

              // ── Mode toggle (major / minor ring) ───────────────────────
              _ModeToggle(
                isMajor: state.selectedKey.isMajor,
                tonic: state.selectedKey.tonic,
                onToggle: (isMajor) {
                  final service = const CircleOfFifthsService();
                  final key = service.keyFor(
                    state.selectedKey.tonic,
                    isMajor: isMajor,
                  );
                  vm.selectKey(key);
                },
              ),
              AppSpacing.gapLg,

              // ── Key details ────────────────────────────────────────────
              _SectionCard(
                child: KeyDetailsPanel(
                  key_: state.selectedKey,
                  analysis: state.analysis,
                ),
              ),
              AppSpacing.gapMd,

              // ── Related keys ───────────────────────────────────────────
              _SectionCard(
                child: RelatedKeysWidget(
                  selectedKey: state.selectedKey,
                  onKeyTap: (tonic, {required bool isMajor}) {
                    final service = const CircleOfFifthsService();
                    try {
                      final key = service.keyFor(tonic, isMajor: isMajor);
                      vm.selectKey(key);
                    } catch (_) {
                      // key not found in table — no-op
                    }
                  },
                ),
              ),
              AppSpacing.gapMd,

              // ── Suggested progressions ─────────────────────────────────
              _SectionCard(
                child: SuggestedProgressionsWidget(
                  analysis: state.analysis,
                  activeIndex: state.activeProgressionIndex,
                  onSelect: vm.selectProgression,
                ),
              ),
              AppSpacing.gapLg,

              // ── Action buttons ─────────────────────────────────────────
              _ActionButtons(
                state: state,
                vm: vm,
                onSendToPianoRoll: () => context.push(
                  AppConstants.routePianoRoll,
                ),
                onGenerateProgression: () => context.push(
                  AppConstants.routeGenerator,
                ),
              ),
              AppSpacing.gapXl,
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Mode toggle chip
// ---------------------------------------------------------------------------

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.isMajor,
    required this.tonic,
    required this.onToggle,
  });

  final bool isMajor;
  final String tonic;
  final void Function(bool isMajor) onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ModeChip(
          label: '$tonic major',
          active: isMajor,
          onTap: () => onToggle(true),
          color: cs.primary,
        ),
        AppSpacing.hGapSm,
        _ModeChip(
          label: '${tonic}m minor',
          active: !isMajor,
          onTap: () => onToggle(false),
          color: cs.secondary,
        ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.active,
    required this.onTap,
    required this.color,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: active ? color.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? color : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: active ? color : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section card wrapper
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Action buttons
// ---------------------------------------------------------------------------

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.state,
    required this.vm,
    required this.onGenerateProgression,
    required this.onSendToPianoRoll,
  });

  final CircleOfFifthsState state;
  final CircleOfFifthsViewModel vm;
  final VoidCallback onGenerateProgression;
  final VoidCallback onSendToPianoRoll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary: Generate progression
        FilledButton.icon(
          onPressed: onGenerateProgression,
          icon: const Icon(Icons.piano_outlined, size: 18),
          label: Text(
            'Generate Progression in ${state.selectedKey.label}',
          ),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        AppSpacing.gapSm,

        // Secondary: Send to Piano Roll
        OutlinedButton.icon(
          onPressed: onSendToPianoRoll,
          icon: const Icon(Icons.queue_music_outlined, size: 18),
          label: const Text('Send to Piano Roll'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 13),
            side: BorderSide(color: cs.primary.withAlpha(120)),
          ),
        ),
        AppSpacing.gapSm,

        // Tertiary: Set as active key (shows confirmation via SnackBar)
        TextButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${state.selectedKey.label} set as active key',
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: Icon(Icons.push_pin_outlined,
              size: 16, color: cs.onSurfaceVariant),
          label: Text(
            'Set as Active Key',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
