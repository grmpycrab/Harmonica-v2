import '../../domain/entities/chord.dart';
import '../../domain/entities/piano_roll_event.dart';
import '../../domain/entities/progression.dart';

/// Maps [Chord] note names to octave-qualified strings and converts a full
/// [Progression] into a list of [PianoRollEvent]s for the piano roll display.
///
/// **Voicing algorithm** (close-position ascending from root):
/// * Root is placed in octave 3 for pitch classes F–B (higher), octave 4
///   for C–E (lower), keeping all generated voicings in the C3–B4 range.
/// * Each subsequent chord tone uses the same octave if its pitch class is
///   >= the root's, otherwise wraps to `base + 1`.
///
/// All chords produced by [ScaleMapper] (C major / A minor family) have
/// exactly three notes and resolve comfortably within C3–B4.
class ChordNoteMapper {
  ChordNoteMapper._();

  // Chromatic pitch-class index (C = 0 … B = 11). Enharmonic pairs included.
  static const Map<String, int> _pc = {
    'C': 0,
    'C#': 1,
    'Db': 1,
    'D': 2,
    'D#': 3,
    'Eb': 3,
    'E': 4,
    'F': 5,
    'F#': 6,
    'Gb': 6,
    'G': 7,
    'G#': 8,
    'Ab': 8,
    'A': 9,
    'A#': 10,
    'Bb': 10,
    'B': 11,
  };

  static int _pitchClass(String note) => _pc[note] ?? 0;

  /// Root octave: F and above → octave 3 so chord tones stay in C3–B4.
  static int _baseOctave(String root) =>
      _pitchClass(root) >= 5 ? 3 : 4; // F(5)…B(11) → oct 3; C(0)…E(4) → oct 4

  /// Returns octave-qualified note names for [chord] in close ascending voicing.
  ///
  /// * Triads (3 notes): root octave determined by [_baseOctave].
  /// * 7th chords (4 notes): always rooted at octave 3 so all four tones
  ///   stay within the C3–B4 piano roll display range.
  /// * 9th chords (5 notes): rooted at octave 3; the 9th (index 4) is
  ///   always placed one octave higher than root (base + 1) to avoid a
  ///   pitch-class comparison collision with the root's octave.
  static List<String> octaveNotes(Chord chord) {
    if (chord.notes.isEmpty) return const [];
    final root = chord.notes.first;
    final rootPc = _pitchClass(root);
    // 7th and 9th chords: root always in oct 3 so all notes fit in C3–B4
    final base = chord.notes.length >= 4 ? 3 : _baseOctave(root);

    return List.generate(chord.notes.length, (i) {
      final n = chord.notes[i];
      // 9th (5th note, index 4) always placed at base+1 — it sits above the
      // 7th regardless of pitch class, preventing wrap-around confusion.
      final oct = (chord.notes.length >= 5 && i == 4)
          ? base + 1
          : (_pitchClass(n) >= rootPc ? base : base + 1);
      return '$n$oct';
    });
  }

  /// Converts an entire [Progression] into a flat list of [PianoRollEvent]s.
  static List<PianoRollEvent> toEvents(Progression progression) {
    final events = <PianoRollEvent>[];
    for (var i = 0; i < progression.chords.length; i++) {
      for (final note in octaveNotes(progression.chords[i])) {
        events.add(PianoRollEvent(note: note, chordIndex: i));
      }
    }
    return events;
  }
}
