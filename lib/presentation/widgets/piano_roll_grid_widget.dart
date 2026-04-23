import 'package:flutter/material.dart';

import '../../domain/entities/chord.dart';
import '../../domain/entities/piano_roll_event.dart';

/// DAW-style piano roll grid rendered via [CustomPaint] for efficiency.
///
/// Columns = chords (one per chord in the progression).
/// Rows    = chromatic notes in [noteRange] (top = highest pitch).
/// Active cells (where a chord tone lands) are filled with the primary
/// amber accent colour; inactive cells show the background.
class PianoRollGridWidget extends StatelessWidget {
  const PianoRollGridWidget({
    super.key,
    required this.events,
    required this.chords,
    required this.noteRange,
    required this.rowHeight,
    required this.columnWidth,
  });

  final List<PianoRollEvent> events;
  final List<Chord> chords;
  final List<String> noteRange;
  final double rowHeight;
  final double columnWidth;

  static bool _isBlack(String note) => note.contains('#');
  static bool _isOctaveC(String note) =>
      note.startsWith('C') && !note.contains('#');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final colors = _GridColors(
      background: isDark ? const Color(0xFF1F2338) : const Color(0xFFFAF8F3),
      blackKeyRow: isDark ? const Color(0xFF191D2D) : const Color(0xFFEDE9DF),
      altColumnOverlay:
          isDark ? const Color(0x0DFFFFFF) : const Color(0x0A000000),
      activeNote: cs.primary,
      gridLine: cs.outline.withAlpha(55),
      chordDivider: cs.outline.withAlpha(130),
      octaveLine: cs.primary.withAlpha(90),
    );

    // Build active-note lookup: "chordIndex_note" → present
    final activeSet = <String>{};
    for (final e in events) {
      activeSet.add('${e.chordIndex}_${e.note}');
    }

    // Black/octave flags per row — computed once, passed to painter
    final isBlackRow = noteRange.map(_isBlack).toList(growable: false);
    final isOctaveCRow = noteRange.map(_isOctaveC).toList(growable: false);

    final totalW = columnWidth * chords.length;
    final totalH = rowHeight * noteRange.length;

    return SizedBox(
      width: totalW,
      height: totalH,
      child: CustomPaint(
        size: Size(totalW, totalH),
        painter: _GridPainter(
          numChords: chords.length,
          noteRange: noteRange,
          isBlackRow: isBlackRow,
          isOctaveCRow: isOctaveCRow,
          activeSet: activeSet,
          rowHeight: rowHeight,
          columnWidth: columnWidth,
          colors: colors,
        ),
      ),
    );
  }
}

// ── Color bundle ─────────────────────────────────────────────────────────────

class _GridColors {
  const _GridColors({
    required this.background,
    required this.blackKeyRow,
    required this.altColumnOverlay,
    required this.activeNote,
    required this.gridLine,
    required this.chordDivider,
    required this.octaveLine,
  });

  final Color background;
  final Color blackKeyRow;
  final Color altColumnOverlay;
  final Color activeNote;
  final Color gridLine;
  final Color chordDivider;
  final Color octaveLine;
}

// ── CustomPainter ─────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  const _GridPainter({
    required this.numChords,
    required this.noteRange,
    required this.isBlackRow,
    required this.isOctaveCRow,
    required this.activeSet,
    required this.rowHeight,
    required this.columnWidth,
    required this.colors,
  });

  final int numChords;
  final List<String> noteRange;
  final List<bool> isBlackRow;
  final List<bool> isOctaveCRow;
  final Set<String> activeSet;
  final double rowHeight;
  final double columnWidth;
  final _GridColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final notePaint = Paint()..style = PaintingStyle.fill;

    // ── 1. Row backgrounds ─────────────────────────────────────────────────
    for (var r = 0; r < noteRange.length; r++) {
      final y = r * rowHeight;
      bgPaint.color = isBlackRow[r] ? colors.blackKeyRow : colors.background;
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, rowHeight),
        bgPaint,
      );

      // Octave boundary line (top edge of each C note row)
      if (isOctaveCRow[r]) {
        linePaint.color = colors.octaveLine;
        linePaint.strokeWidth = 1;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
      } else {
        // Standard row separator
        linePaint.color = colors.gridLine;
        linePaint.strokeWidth = 0.5;
        canvas.drawLine(
          Offset(0, y + rowHeight),
          Offset(size.width, y + rowHeight),
          linePaint,
        );
      }
    }

    // ── 2. Alternate column overlay (subtle depth cue) ─────────────────────
    bgPaint.color = colors.altColumnOverlay;
    for (var c = 0; c < numChords; c++) {
      if (c.isOdd) {
        canvas.drawRect(
          Rect.fromLTWH(c * columnWidth, 0, columnWidth, size.height),
          bgPaint,
        );
      }
    }

    // ── 3. Active note blocks ──────────────────────────────────────────────
    const padH = 3.0; // horizontal inset inside a cell
    const padV = 2.5; // vertical inset inside a cell

    notePaint.color = colors.activeNote;

    for (var c = 0; c < numChords; c++) {
      for (var r = 0; r < noteRange.length; r++) {
        if (!activeSet.contains('${c}_${noteRange[r]}')) continue;

        final rect = Rect.fromLTWH(
          c * columnWidth + padH,
          r * rowHeight + padV,
          columnWidth - padH * 2,
          rowHeight - padV * 2,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(3)),
          notePaint,
        );
      }
    }

    // ── 4. Vertical chord dividers ─────────────────────────────────────────
    linePaint
      ..color = colors.chordDivider
      ..strokeWidth = 1;
    for (var c = 1; c < numChords; c++) {
      final x = c * columnWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.activeSet != activeSet ||
      old.numChords != numChords ||
      old.colors.background != colors.background;
}
