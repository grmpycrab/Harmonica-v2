import 'package:flutter/material.dart';

/// Static, non-interactive piano keyboard reference strip.
///
/// Renders one row per note in [noteRange] (first entry = highest pitch).
/// Black-key rows use a darker background; only octave-boundary C notes
/// display a label (e.g. "C4") in the primary amber accent colour.
class PianoKeyboardWidget extends StatelessWidget {
  const PianoKeyboardWidget({
    super.key,
    required this.noteRange,
    required this.rowHeight,
  });

  final List<String> noteRange;
  final double rowHeight;

  static bool _isBlack(String note) => note.contains('#');
  static bool _isOctaveC(String note) =>
      note.startsWith('C') && !note.contains('#');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final whiteKeyBg =
        isDark ? const Color(0xFF1F2338) : const Color(0xFFFFFFFF);
    final blackKeyBg =
        isDark ? const Color(0xFF141726) : const Color(0xFFD4D0C4);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: noteRange.map((note) {
        final isBlack = _isBlack(note);
        final isC = _isOctaveC(note);

        return SizedBox(
          height: rowHeight,
          child: Stack(
            children: [
              // Row background
              Container(
                width: double.infinity,
                color: isBlack ? blackKeyBg : whiteKeyBg,
              ),
              // Label (only C notes)
              if (isC)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        note,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                          height: 1,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              // Bottom border
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 0.5,
                  color: cs.outline.withAlpha(70),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
