/// Represents a single highlighted note in the piano roll visualization.
///
/// Each [PianoRollEvent] maps one note of a chord to a horizontal column
/// (chord position) in the grid. The [note] includes the octave so the
/// renderer can place it on the correct row of the chromatic display range.
class PianoRollEvent {
  const PianoRollEvent({
    required this.note,
    required this.chordIndex,
    this.duration = 1,
  });

  /// Octave-qualified note name, e.g. "A4", "C#3", "G#4".
  final String note;

  /// Zero-based column index — which chord in the progression this note
  /// belongs to.
  final int chordIndex;

  /// Duration in grid steps. Always 1 in the current read-only MVP.
  final int duration;
}
