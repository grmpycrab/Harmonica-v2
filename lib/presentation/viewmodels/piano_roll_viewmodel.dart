import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/chord_note_mapper.dart';
import '../../domain/entities/chord.dart';
import '../../domain/entities/piano_roll_event.dart';
import 'progression_viewmodel.dart';

// ── Display range ────────────────────────────────────────────────────────────
//
// C3–B4: two chromatic octaves (24 rows), ordered top → bottom
// (highest pitch first, matching piano roll convention).
//
// All chords in the C-major / A-minor family fit comfortably in this range:
//   lowest note: F3 (F major root)  highest note: B4 (Em / E top)
//
const List<String> pianoRollNoteRange = [
  'B4',
  'A#4',
  'A4',
  'G#4',
  'G4',
  'F#4',
  'F4',
  'E4',
  'D#4',
  'D4',
  'C#4',
  'C4',
  'B3',
  'A#3',
  'A3',
  'G#3',
  'G3',
  'F#3',
  'F3',
  'E3',
  'D#3',
  'D3',
  'C#3',
  'C3',
];

// ── State ────────────────────────────────────────────────────────────────────

/// Immutable view-state consumed by the piano roll screen and widgets.
class PianoRollState {
  const PianoRollState({
    required this.events,
    required this.chords,
    required this.noteRange,
    this.progressionLabel = '',
  });

  /// Empty state — shown when no progression has been generated yet.
  const PianoRollState.empty()
      : events = const [],
        chords = const [],
        noteRange = pianoRollNoteRange,
        progressionLabel = '';

  /// Flat list of note events, one per chord tone per chord.
  final List<PianoRollEvent> events;

  /// Ordered chord list — one entry per column in the grid.
  final List<Chord> chords;

  /// Chromatic note names for the grid rows, top to bottom.
  final List<String> noteRange;

  /// Human-readable progression label, e.g. "Am - F - C - G".
  final String progressionLabel;

  bool get isEmpty => chords.isEmpty;
}

// ── Provider ─────────────────────────────────────────────────────────────────

/// Derives [PianoRollState] from the active [progressionViewModelProvider].
///
/// Uses a plain [Provider] (no code generation) since this is pure derived
/// state — it reacts automatically whenever the progression changes.
final pianoRollViewModelProvider = Provider<PianoRollState>((ref) {
  final progression = ref.watch(progressionViewModelProvider).progression;

  if (progression == null) return const PianoRollState.empty();

  return PianoRollState(
    events: ChordNoteMapper.toEvents(progression),
    chords: progression.chords,
    noteRange: pianoRollNoteRange,
    progressionLabel: progression.label,
  );
});
