import '../../domain/entities/music_key.dart';

/// Static registry of all 24 keys (12 major + 12 relative minors) laid out
/// on the Circle of Fifths.
///
/// **Layout (clockwise from position 0):**
/// ```
///  Pos  Major  Relative minor
///   0   C      Am
///   1   G      Em
///   2   D      Bm
///   3   A      F#m
///   4   E      C#m
///   5   B/Cb   G#m/Abm
///   6   F#/Gb  D#m/Ebm
///   7   Db/C#  Bbm/A#m
///   8   Ab     Fm
///   9   Eb     Cm
///  10   Bb     Gm
///  11   F      Dm
/// ```
///
/// The 12 major keys and their 12 relative minors are each stored as
/// separate [MusicKey] objects.  Position ties a major key and its relative
/// minor at the same slot on the circle.
class CircleOfFifthsService {
  const CircleOfFifthsService();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// All 12 major keys in clockwise order.
  List<MusicKey> get majorKeys => _majorKeys;

  /// All 12 relative minor keys in clockwise order.
  List<MusicKey> get minorKeys => _minorKeys;

  /// Returns the [MusicKey] for [tonic] / [isMajor].
  MusicKey keyFor(String tonic, {required bool isMajor}) {
    final list = isMajor ? _majorKeys : _minorKeys;
    return list.firstWhere((k) => k.tonic == tonic);
  }

  /// Returns the default selected key (C major).
  MusicKey get defaultKey => _majorKeys[0];

  // ---------------------------------------------------------------------------
  // Circle data
  // ---------------------------------------------------------------------------
  //
  // Each row: (position, major tonic, relative minor tonic)
  // dominant  = next clockwise  = (pos+1) % 12
  // subdominant = next counter-clockwise = (pos+11) % 12
  //
  static const _data = [
    (0, 'C', 'A'), // C major / A minor
    (1, 'G', 'E'), // G major / E minor
    (2, 'D', 'B'), // D major / B minor
    (3, 'A', 'F#'), // A major / F# minor
    (4, 'E', 'C#'), // E major / C# minor
    (5, 'B', 'G#'), // B major / G# minor
    (6, 'F#', 'D#'), // F#/Gb major / D#/Eb minor
    (7, 'Db', 'Bb'), // Db/C# major / Bb minor
    (8, 'Ab', 'F'), // Ab major / F minor
    (9, 'Eb', 'C'), // Eb major / C minor
    (10, 'Bb', 'G'), // Bb major / G minor
    (11, 'F', 'D'), // F major / D minor
  ];

  static final List<MusicKey> _majorKeys = List.unmodifiable(
    List.generate(12, (i) {
      final (pos, major, minor) = _data[i];
      final domPos = (i + 1) % 12;
      final subPos = (i + 11) % 12;
      return MusicKey(
        tonic: major,
        isMajor: true,
        position: pos,
        relativeKey: minor,
        dominantKey: _data[domPos].$2,
        subdominantKey: _data[subPos].$2,
      );
    }),
  );

  static final List<MusicKey> _minorKeys = List.unmodifiable(
    List.generate(12, (i) {
      final (pos, major, minor) = _data[i];
      final domPos = (i + 1) % 12;
      final subPos = (i + 11) % 12;
      return MusicKey(
        tonic: minor,
        isMajor: false,
        position: pos,
        relativeKey: major,
        dominantKey: _data[domPos].$3,
        subdominantKey: _data[subPos].$3,
      );
    }),
  );
}
