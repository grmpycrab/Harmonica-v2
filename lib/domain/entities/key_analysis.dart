import 'package:flutter/foundation.dart';

import 'chord.dart';
import 'music_key.dart';

/// Functional role of a diatonic chord.
enum ChordFunction { tonic, predominant, dominant }

/// A diatonic chord with its scale-degree label and functional role.
@immutable
class DiatonicChord {
  const DiatonicChord({
    required this.degree,
    required this.chord,
    required this.function,
  });

  /// Roman numeral label, e.g. "I", "ii", "V", "vii°"
  final String degree;
  final Chord chord;
  final ChordFunction function;
}

/// Full harmonic analysis of a selected [MusicKey].
///
/// Produced by [KeyChordService] and consumed by the ViewModel.
@immutable
class KeyAnalysis {
  const KeyAnalysis({
    required this.key,
    required this.diatonicChords,
    required this.suggestedProgressions,
  });

  final MusicKey key;

  /// Seven diatonic chords in scale-degree order (I–vii°).
  final List<DiatonicChord> diatonicChords;

  /// 2–3 idiomatic progressions drawn from the key.
  final List<SuggestedProgression> suggestedProgressions;

  /// Convenience: chords grouped by function.
  List<DiatonicChord> get tonicChords =>
      diatonicChords.where((c) => c.function == ChordFunction.tonic).toList();

  List<DiatonicChord> get predominantChords => diatonicChords
      .where((c) => c.function == ChordFunction.predominant)
      .toList();

  List<DiatonicChord> get dominantChords => diatonicChords
      .where((c) => c.function == ChordFunction.dominant)
      .toList();
}

/// A named chord progression suggestion within a key.
@immutable
class SuggestedProgression {
  const SuggestedProgression({required this.name, required this.chords});

  /// Short descriptive name, e.g. "Classic I–V–vi–IV"
  final String name;
  final List<Chord> chords;

  String get label => chords.map((c) => c.name).join(' – ');
}
