import '../../domain/entities/chord.dart';
import '../../domain/entities/key_analysis.dart';
import '../../domain/entities/music_key.dart';

/// Derives the seven diatonic chords and suggested progressions for any
/// [MusicKey].
///
/// All chords are expressed in the key of the supplied [MusicKey].  Since
/// the Circle of Fifths currently works in fixed pitch classes (key of C / A),
/// transposition is handled by table lookup rather than interval arithmetic —
/// keeping this service pure Dart with no dependency on [ScaleMapper].
class KeyChordService {
  const KeyChordService();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  KeyAnalysis analyseKey(MusicKey key) {
    final diatonic = _buildDiatonic(key);
    final suggestions = _buildSuggestions(key, diatonic);
    return KeyAnalysis(
      key: key,
      diatonicChords: diatonic,
      suggestedProgressions: suggestions,
    );
  }

  // ---------------------------------------------------------------------------
  // Major diatonic templates (I–vii°) per tonic
  // ---------------------------------------------------------------------------
  //
  // Each row: [I, ii, iii, IV, V, vi, vii°]
  // stored as (name, quality) — notes are generated from the major scale.
  //
  static const Map<String, List<(String, String)>> _majorDiatonic = {
    'C': [
      ('C', 'major'),
      ('Dm', 'minor'),
      ('Em', 'minor'),
      ('F', 'major'),
      ('G', 'major'),
      ('Am', 'minor'),
      ('Bdim', 'diminished')
    ],
    'G': [
      ('G', 'major'),
      ('Am', 'minor'),
      ('Bm', 'minor'),
      ('C', 'major'),
      ('D', 'major'),
      ('Em', 'minor'),
      ('F#dim', 'diminished')
    ],
    'D': [
      ('D', 'major'),
      ('Em', 'minor'),
      ('F#m', 'minor'),
      ('G', 'major'),
      ('A', 'major'),
      ('Bm', 'minor'),
      ('C#dim', 'diminished')
    ],
    'A': [
      ('A', 'major'),
      ('Bm', 'minor'),
      ('C#m', 'minor'),
      ('D', 'major'),
      ('E', 'major'),
      ('F#m', 'minor'),
      ('G#dim', 'diminished')
    ],
    'E': [
      ('E', 'major'),
      ('F#m', 'minor'),
      ('G#m', 'minor'),
      ('A', 'major'),
      ('B', 'major'),
      ('C#m', 'minor'),
      ('D#dim', 'diminished')
    ],
    'B': [
      ('B', 'major'),
      ('C#m', 'minor'),
      ('D#m', 'minor'),
      ('E', 'major'),
      ('F#', 'major'),
      ('G#m', 'minor'),
      ('A#dim', 'diminished')
    ],
    'F#': [
      ('F#', 'major'),
      ('G#m', 'minor'),
      ('A#m', 'minor'),
      ('B', 'major'),
      ('C#', 'major'),
      ('D#m', 'minor'),
      ('E#dim', 'diminished')
    ],
    'Db': [
      ('Db', 'major'),
      ('Ebm', 'minor'),
      ('Fm', 'minor'),
      ('Gb', 'major'),
      ('Ab', 'major'),
      ('Bbm', 'minor'),
      ('Cdim', 'diminished')
    ],
    'Ab': [
      ('Ab', 'major'),
      ('Bbm', 'minor'),
      ('Cm', 'minor'),
      ('Db', 'major'),
      ('Eb', 'major'),
      ('Fm', 'minor'),
      ('Gdim', 'diminished')
    ],
    'Eb': [
      ('Eb', 'major'),
      ('Fm', 'minor'),
      ('Gm', 'minor'),
      ('Ab', 'major'),
      ('Bb', 'major'),
      ('Cm', 'minor'),
      ('Ddim', 'diminished')
    ],
    'Bb': [
      ('Bb', 'major'),
      ('Cm', 'minor'),
      ('Dm', 'minor'),
      ('Eb', 'major'),
      ('F', 'major'),
      ('Gm', 'minor'),
      ('Adim', 'diminished')
    ],
    'F': [
      ('F', 'major'),
      ('Gm', 'minor'),
      ('Am', 'minor'),
      ('Bb', 'major'),
      ('C', 'major'),
      ('Dm', 'minor'),
      ('Edim', 'diminished')
    ],
  };

  // ---------------------------------------------------------------------------
  // Natural minor diatonic templates (i–vii) per tonic
  // ---------------------------------------------------------------------------
  //
  // Order: i, ii°, III, iv, v, VI, VII
  //
  static const Map<String, List<(String, String)>> _minorDiatonic = {
    'A': [
      ('Am', 'minor'),
      ('Bdim', 'diminished'),
      ('C', 'major'),
      ('Dm', 'minor'),
      ('Em', 'minor'),
      ('F', 'major'),
      ('G', 'major')
    ],
    'E': [
      ('Em', 'minor'),
      ('F#dim', 'diminished'),
      ('G', 'major'),
      ('Am', 'minor'),
      ('Bm', 'minor'),
      ('C', 'major'),
      ('D', 'major')
    ],
    'B': [
      ('Bm', 'minor'),
      ('C#dim', 'diminished'),
      ('D', 'major'),
      ('Em', 'minor'),
      ('F#m', 'minor'),
      ('G', 'major'),
      ('A', 'major')
    ],
    'F#': [
      ('F#m', 'minor'),
      ('G#dim', 'diminished'),
      ('A', 'major'),
      ('Bm', 'minor'),
      ('C#m', 'minor'),
      ('D', 'major'),
      ('E', 'major')
    ],
    'C#': [
      ('C#m', 'minor'),
      ('D#dim', 'diminished'),
      ('E', 'major'),
      ('F#m', 'minor'),
      ('G#m', 'minor'),
      ('A', 'major'),
      ('B', 'major')
    ],
    'G#': [
      ('G#m', 'minor'),
      ('A#dim', 'diminished'),
      ('B', 'major'),
      ('C#m', 'minor'),
      ('D#m', 'minor'),
      ('E', 'major'),
      ('F#', 'major')
    ],
    'D#': [
      ('D#m', 'minor'),
      ('E#dim', 'diminished'),
      ('F#', 'major'),
      ('G#m', 'minor'),
      ('A#m', 'minor'),
      ('B', 'major'),
      ('C#', 'major')
    ],
    'Bb': [
      ('Bbm', 'minor'),
      ('Cdim', 'diminished'),
      ('Db', 'major'),
      ('Ebm', 'minor'),
      ('Fm', 'minor'),
      ('Gb', 'major'),
      ('Ab', 'major')
    ],
    'F': [
      ('Fm', 'minor'),
      ('Gdim', 'diminished'),
      ('Ab', 'major'),
      ('Bbm', 'minor'),
      ('Cm', 'minor'),
      ('Db', 'major'),
      ('Eb', 'major')
    ],
    'C': [
      ('Cm', 'minor'),
      ('Ddim', 'diminished'),
      ('Eb', 'major'),
      ('Fm', 'minor'),
      ('Gm', 'minor'),
      ('Ab', 'major'),
      ('Bb', 'major')
    ],
    'G': [
      ('Gm', 'minor'),
      ('Adim', 'diminished'),
      ('Bb', 'major'),
      ('Cm', 'minor'),
      ('Dm', 'minor'),
      ('Eb', 'major'),
      ('F', 'major')
    ],
    'D': [
      ('Dm', 'minor'),
      ('Edim', 'diminished'),
      ('F', 'major'),
      ('Gm', 'minor'),
      ('Am', 'minor'),
      ('Bb', 'major'),
      ('C', 'major')
    ],
  };

  // Roman numeral labels for major and minor scales
  static const _majorDegrees = ['I', 'ii', 'iii', 'IV', 'V', 'vi', 'vii°'];
  static const _minorDegrees = ['i', 'ii°', 'III', 'iv', 'v', 'VI', 'VII'];

  // Functional roles aligned to degree index
  static const _majorFunctions = [
    ChordFunction.tonic, // I
    ChordFunction.predominant, // ii
    ChordFunction.tonic, // iii
    ChordFunction.predominant, // IV
    ChordFunction.dominant, // V
    ChordFunction.tonic, // vi
    ChordFunction.dominant, // vii°
  ];

  static const _minorFunctions = [
    ChordFunction.tonic, // i
    ChordFunction.predominant, // ii°
    ChordFunction.tonic, // III
    ChordFunction.predominant, // iv
    ChordFunction.dominant, // v
    ChordFunction.tonic, // VI
    ChordFunction.dominant, // VII
  ];

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  List<DiatonicChord> _buildDiatonic(MusicKey key) {
    final table = key.isMajor ? _majorDiatonic : _minorDiatonic;
    final degrees = key.isMajor ? _majorDegrees : _minorDegrees;
    final functions = key.isMajor ? _majorFunctions : _minorFunctions;

    final entries = table[key.tonic];
    if (entries == null) return [];

    return List.generate(entries.length, (i) {
      final (name, quality) = entries[i];
      return DiatonicChord(
        degree: degrees[i],
        chord: Chord(name: name, notes: const [], quality: quality),
        function: functions[i],
      );
    });
  }

  List<SuggestedProgression> _buildSuggestions(
    MusicKey key,
    List<DiatonicChord> diatonic,
  ) {
    if (diatonic.length < 7) return [];

    // Helpers — pick chord by degree index (0-based)
    Chord c(int i) => diatonic[i].chord;

    if (key.isMajor) {
      return [
        SuggestedProgression(
          name: 'Classic I – V – vi – IV',
          chords: [c(0), c(4), c(5), c(3)],
        ),
        SuggestedProgression(
          name: 'ii – V – I',
          chords: [c(1), c(4), c(0)],
        ),
        SuggestedProgression(
          name: 'I – IV – V – I',
          chords: [c(0), c(3), c(4), c(0)],
        ),
      ];
    } else {
      return [
        SuggestedProgression(
          name: 'i – VI – III – VII',
          chords: [c(0), c(5), c(2), c(6)],
        ),
        SuggestedProgression(
          name: 'i – iv – v – i',
          chords: [c(0), c(3), c(4), c(0)],
        ),
        SuggestedProgression(
          name: 'i – VII – VI – VII',
          chords: [c(0), c(6), c(5), c(6)],
        ),
      ];
    }
  }
}
