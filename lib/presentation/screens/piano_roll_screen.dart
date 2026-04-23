import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/app_spacing.dart';
import '../../domain/entities/chord.dart';
import '../viewmodels/piano_roll_viewmodel.dart';
import '../widgets/piano_keyboard_widget.dart';
import '../widgets/piano_roll_grid_widget.dart';

// ── Layout constants ──────────────────────────────────────────────────────────
const double _kRowHeight = 20.0;
const double _kColWidth = 100.0;
const double _kKeyboardWidth = 56.0;
const double _kHeaderHeight = 36.0;

/// Read-only piano roll visualization of the active chord progression.
///
/// The screen is split into two columns:
///  - **Left** (fixed): chromatic piano keyboard reference (C3–B4).
///  - **Right** (scrollable): chord name header + note grid.
///
/// The right side scrolls horizontally as a single unit so chord names
/// always align with their respective note columns.
class PianoRollScreen extends ConsumerWidget {
  const PianoRollScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pianoRollViewModelProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF191D2D) : const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF191D2D) : const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        leading: const BackButton(),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Piano Roll',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            if (state.progressionLabel.isNotEmpty)
              Text(
                state.progressionLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.primary,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: cs.outline),
        ),
      ),
      body: state.isEmpty
          ? _EmptyState(cs: cs)
          : SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Left: keyboard reference column ────────────────────
                  SizedBox(
                    width: _kKeyboardWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Blank corner aligned with the chord header row
                        Container(
                          height: _kHeaderHeight,
                          color: isDark
                              ? const Color(0xFF191D2D)
                              : const Color(0xFFF5F3EE),
                        ),
                        Container(height: 1, color: cs.outline),
                        PianoKeyboardWidget(
                          noteRange: state.noteRange,
                          rowHeight: _kRowHeight,
                        ),
                      ],
                    ),
                  ),
                  // Vertical divider between keyboard and grid
                  Container(width: 1, color: cs.outline),
                  // ── Right: chord header + note grid (scrolls horizontally)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ChordHeaderRow(
                            chords: state.chords,
                            colWidth: _kColWidth,
                            height: _kHeaderHeight,
                            theme: theme,
                          ),
                          Divider(height: 1, color: cs.outline),
                          PianoRollGridWidget(
                            events: state.events,
                            chords: state.chords,
                            noteRange: state.noteRange,
                            rowHeight: _kRowHeight,
                            columnWidth: _kColWidth,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// ── Chord header row ──────────────────────────────────────────────────────────

class _ChordHeaderRow extends StatelessWidget {
  const _ChordHeaderRow({
    required this.chords,
    required this.colWidth,
    required this.height,
    required this.theme,
  });

  final List<Chord> chords;
  final double colWidth;
  final double height;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: height,
      color: isDark ? const Color(0xFF262B40) : const Color(0xFFF0EDE5),
      child: Row(
        children: chords.asMap().entries.map((entry) {
          final idx = entry.key;
          final chord = entry.value;
          final isEven = idx.isEven;

          return SizedBox(
            width: colWidth,
            child: Container(
              color: isEven
                  ? Colors.transparent
                  : (isDark
                      ? const Color(0x0DFFFFFF)
                      : const Color(0x0A000000)),
              alignment: Alignment.center,
              child: Text(
                chord.name,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.piano_outlined,
              size: 56,
              color: cs.onSurfaceVariant,
            ),
            AppSpacing.gapLg,
            Text(
              'No progression loaded',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            AppSpacing.gapSm,
            Text(
              'Generate a chord progression first,\nthen open the piano roll.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
