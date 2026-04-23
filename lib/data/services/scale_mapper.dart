import '../../domain/entities/chord.dart';
import '../../domain/entities/chord_degree.dart';
import '../../domain/entities/scale_type.dart';

/// Resolves a [ChordDegree] within a [ScaleType] to a concrete [Chord].
///
/// **Key of C** — all nine scales are currently rooted in C (or their natural
/// relative, e.g. A minor).  Multi-key support can be added later by
/// parameterising the root and transposing the note lists.
///
/// **Tension system** — each degree may declare a [_ChordData.tensionVariant].
/// When [withTension] is `true` and a variant exists, [resolve] returns the
/// richer chord (dominant 7th, major 7th, minor 7th…) including the correct
/// four-note voicing.  The caller ([ProgressionGenerator]) decides whether to
/// enable tension for a given progression run based on [EmotionProfile.tensionLevel].
///
/// **Note convention** — all note names inside [_ChordData.notes] /
/// [_ChordData.tensionNotes] use `#` (sharp) notation throughout so they
/// resolve correctly against the piano roll's chromatic row list.
class ScaleMapper {
  const ScaleMapper();

  Chord resolve(
    ChordDegree degree,
    ScaleType scale, {
    bool withTension = false,
  }) {
    final data = _scales[scale]![degree]!;
    if (withTension && data.tensionVariant != null) {
      return Chord(
        name: data.tensionVariant!,
        notes: data.tensionNotes ?? data.notes,
        quality: data.tensionQuality ?? data.quality,
      );
    }
    return Chord(name: data.name, notes: data.notes, quality: data.quality);
  }

  String keyLabel(ScaleType scale) => scale.label;

  // ---------------------------------------------------------------------------
  // Scale definitions
  // ---------------------------------------------------------------------------
  //
  // Degree mapping reminder:
  //   ChordDegree.i   = scale degree 1 (tonic)
  //   ChordDegree.ii  = scale degree 2
  //   ChordDegree.iii = scale degree 3
  //   ChordDegree.iv  = scale degree 4
  //   ChordDegree.v   = scale degree 5
  //   ChordDegree.vi  = scale degree 6
  //   ChordDegree.vii = scale degree 7
  //
  // For modes the degrees map to the modal degrees in order, so
  // ChordDegree.vii is always the 7th chord of that mode's diatonic stack,
  // not necessarily a leading-tone.
  // ---------------------------------------------------------------------------

  static const Map<ScaleType, Map<ChordDegree, _ChordData>> _scales = {
    // ── C Major ───────────────────────────────────────────────────────────────
    //   I=C  II=Dm  III=Em  IV=F  V=G  VI=Am  VII=Bdim
    ScaleType.major: {
      ChordDegree.i: _ChordData(
        'C',
        ['C', 'E', 'G'],
        'major',
        'Cmaj7',
        ['C', 'E', 'G', 'B'],
        'major7',
      ),
      ChordDegree.ii: _ChordData(
        'Dm',
        ['D', 'F', 'A'],
        'minor',
        'Dm7',
        ['D', 'F', 'A', 'C'],
        'minor7',
      ),
      ChordDegree.iii: _ChordData(
        'Em',
        ['E', 'G', 'B'],
        'minor',
        'Em7',
        ['E', 'G', 'B', 'D'],
        'minor7',
      ),
      ChordDegree.iv: _ChordData(
        'F',
        ['F', 'A', 'C'],
        'major',
        'Fmaj7',
        ['F', 'A', 'C', 'E'],
        'major7',
      ),
      ChordDegree.v: _ChordData(
        'G',
        ['G', 'B', 'D'],
        'major',
        'G7',
        ['G', 'B', 'D', 'F'],
        'dominant7',
      ),
      ChordDegree.vi: _ChordData(
        'Am',
        ['A', 'C', 'E'],
        'minor',
        'Am7',
        ['A', 'C', 'E', 'G'],
        'minor7',
      ),
      ChordDegree.vii: _ChordData('Bdim', ['B', 'D', 'F'], 'diminished'),
    },

    // ── A Natural Minor ───────────────────────────────────────────────────────
    //   I=Am  II=Bdim  III=C  IV=Dm  V=Em  VI=F  VII=G
    ScaleType.naturalMinor: {
      ChordDegree.i: _ChordData(
        'Am',
        ['A', 'C', 'E'],
        'minor',
        'Am7',
        ['A', 'C', 'E', 'G'],
        'minor7',
      ),
      ChordDegree.ii: _ChordData('Bdim', ['B', 'D', 'F'], 'diminished'),
      ChordDegree.iii: _ChordData(
        'C',
        ['C', 'E', 'G'],
        'major',
        'Cmaj7',
        ['C', 'E', 'G', 'B'],
        'major7',
      ),
      ChordDegree.iv: _ChordData(
        'Dm',
        ['D', 'F', 'A'],
        'minor',
        'Dm7',
        ['D', 'F', 'A', 'C'],
        'minor7',
      ),
      // V stays diatonic Em; tension borrows major V from harmonic minor
      ChordDegree.v: _ChordData(
        'Em',
        ['E', 'G', 'B'],
        'minor',
        'E',
        ['E', 'G#', 'B'],
        'major',
      ),
      ChordDegree.vi: _ChordData(
        'F',
        ['F', 'A', 'C'],
        'major',
        'Fmaj7',
        ['F', 'A', 'C', 'E'],
        'major7',
      ),
      ChordDegree.vii: _ChordData(
        'G',
        ['G', 'B', 'D'],
        'major',
        'G7',
        ['G', 'B', 'D', 'F'],
        'dominant7',
      ),
    },

    // ── A Harmonic Minor ──────────────────────────────────────────────────────
    //   I=Am  II=Bdim  III=Caug  IV=Dm  V=E  VI=F  VII=G#dim
    ScaleType.harmonicMinor: {
      ChordDegree.i: _ChordData(
        'Am',
        ['A', 'C', 'E'],
        'minor',
        'Am7',
        ['A', 'C', 'E', 'G'],
        'minor7',
      ),
      ChordDegree.ii: _ChordData('Bdim', ['B', 'D', 'F'], 'diminished'),
      ChordDegree.iii: _ChordData('Caug', ['C', 'E', 'G#'], 'augmented'),
      ChordDegree.iv: _ChordData(
        'Dm',
        ['D', 'F', 'A'],
        'minor',
        'Dm7',
        ['D', 'F', 'A', 'C'],
        'minor7',
      ),
      // V = major (raised 7th G# → strong harmonic resolution)
      ChordDegree.v: _ChordData(
        'E',
        ['E', 'G#', 'B'],
        'major',
        'E7',
        ['E', 'G#', 'B', 'D'],
        'dominant7',
      ),
      ChordDegree.vi: _ChordData(
        'F',
        ['F', 'A', 'C'],
        'major',
        'Fmaj7',
        ['F', 'A', 'C', 'E'],
        'major7',
      ),
      ChordDegree.vii: _ChordData('G#dim', ['G#', 'B', 'D'], 'diminished'),
    },

    // ── C Melodic Minor (ascending form) ─────────────────────────────────────
    //   Scale: C D Eb F G A B
    //   i=Cm  ii=Dm  bIII=Ebaug  IV=F  V=G  vi=Adim  vii=Bdim
    ScaleType.melodicMinor: {
      ChordDegree.i: _ChordData(
        'Cm',
        ['C', 'D#', 'G'],
        'minor',
        'Cm7',
        ['C', 'D#', 'G', 'A#'],
        'minor7',
      ),
      ChordDegree.ii: _ChordData(
        'Dm',
        ['D', 'F', 'A'],
        'minor',
        'Dm7',
        ['D', 'F', 'A', 'C'],
        'minor7',
      ),
      // bIII — augmented triad (raised 7th interacts with the b3)
      ChordDegree.iii: _ChordData('Ebaug', ['D#', 'G', 'B'], 'augmented'),
      ChordDegree.iv: _ChordData(
        'F',
        ['F', 'A', 'C'],
        'major',
        'Fmaj7',
        ['F', 'A', 'C', 'E'],
        'major7',
      ),
      // V = major (raised 7th creates strong dominant function)
      ChordDegree.v: _ChordData(
        'G',
        ['G', 'B', 'D'],
        'major',
        'G7',
        ['G', 'B', 'D', 'F'],
        'dominant7',
      ),
      ChordDegree.vi: _ChordData('Adim', ['A', 'C', 'D#'], 'diminished'),
      ChordDegree.vii: _ChordData('Bdim', ['B', 'D', 'F'], 'diminished'),
    },

    // ── C Dorian ──────────────────────────────────────────────────────────────
    //   Scale: C D Eb F G A Bb
    //   i=Cm  ii=Dm  bIII=Eb  IV=F  v=Gm  vi=Adim  bVII=Bb
    ScaleType.dorianMode: {
      ChordDegree.i: _ChordData(
        'Cm',
        ['C', 'D#', 'G'],
        'minor',
        'Cm7',
        ['C', 'D#', 'G', 'A#'],
        'minor7',
      ),
      ChordDegree.ii: _ChordData(
        'Dm',
        ['D', 'F', 'A'],
        'minor',
        'Dm7',
        ['D', 'F', 'A', 'C'],
        'minor7',
      ),
      ChordDegree.iii: _ChordData('Eb', ['D#', 'G', 'A#'], 'major'),
      ChordDegree.iv: _ChordData(
        'F',
        ['F', 'A', 'C'],
        'major',
        'F7',
        ['F', 'A', 'C', 'D#'],
        'dominant7',
      ),
      ChordDegree.v: _ChordData('Gm', ['G', 'A#', 'D'], 'minor'),
      ChordDegree.vi: _ChordData('Adim', ['A', 'C', 'D#'], 'diminished'),
      ChordDegree.vii: _ChordData(
        'Bb',
        ['A#', 'D', 'F'],
        'major',
        'Bb7',
        ['A#', 'D', 'F', 'G#'],
        'dominant7',
      ),
    },

    // ── C Phrygian ────────────────────────────────────────────────────────────
    //   Scale: C Db Eb F G Ab Bb
    //   i=Cm  bII=Db  bIII=Eb  iv=Fm  vdim=Gdim  bVI=Ab  bVIIm=Bbm
    ScaleType.phrygianMode: {
      ChordDegree.i: _ChordData(
        'Cm',
        ['C', 'D#', 'G'],
        'minor',
        'Cm7',
        ['C', 'D#', 'G', 'A#'],
        'minor7',
      ),
      // bII — the defining Phrygian chord (half-step above tonic)
      ChordDegree.ii: _ChordData(
        'Db',
        ['C#', 'F', 'G#'],
        'major',
        'Db7',
        ['C#', 'F', 'G#', 'B'],
        'dominant7',
      ),
      ChordDegree.iii: _ChordData('Eb', ['D#', 'G', 'A#'], 'major'),
      ChordDegree.iv: _ChordData('Fm', ['F', 'G#', 'C'], 'minor'),
      ChordDegree.v: _ChordData('Gdim', ['G', 'A#', 'C#'], 'diminished'),
      ChordDegree.vi: _ChordData('Ab', ['G#', 'C', 'D#'], 'major'),
      ChordDegree.vii: _ChordData('Bbm', ['A#', 'C#', 'F'], 'minor'),
    },

    // ── C Lydian ──────────────────────────────────────────────────────────────
    //   Scale: C D E F# G A B
    //   I=C  II=D  iii=Em  #ivdim=F#dim  V=G  vi=Am  viim=Bm
    ScaleType.lydianMode: {
      ChordDegree.i: _ChordData(
        'C',
        ['C', 'E', 'G'],
        'major',
        'Cmaj7',
        ['C', 'E', 'G', 'B'],
        'major7',
      ),
      // II = major (distinctive Lydian colour — major chord a whole step up)
      ChordDegree.ii: _ChordData(
        'D',
        ['D', 'F#', 'A'],
        'major',
        'Dmaj7',
        ['D', 'F#', 'A', 'C#'],
        'major7',
      ),
      ChordDegree.iii: _ChordData('Em', ['E', 'G', 'B'], 'minor'),
      // #IV — tritone from tonic; used sparingly, adds Lydian sharpness
      ChordDegree.iv: _ChordData('F#dim', ['F#', 'A', 'C'], 'diminished'),
      ChordDegree.v: _ChordData(
        'G',
        ['G', 'B', 'D'],
        'major',
        'G7',
        ['G', 'B', 'D', 'F'],
        'dominant7',
      ),
      ChordDegree.vi: _ChordData('Am', ['A', 'C', 'E'], 'minor'),
      ChordDegree.vii: _ChordData('Bm', ['B', 'D', 'F#'], 'minor'),
    },

    // ── C Mixolydian ──────────────────────────────────────────────────────────
    //   Scale: C D E F G A Bb
    //   I=C  ii=Dm  iiidim=Edim  IV=F  vm=Gm  vi=Am  bVII=Bb
    ScaleType.mixolydianMode: {
      // I = major but bVII creates the characteristic unresolved rock sound
      ChordDegree.i: _ChordData(
        'C',
        ['C', 'E', 'G'],
        'major',
        'C7',
        ['C', 'E', 'G', 'A#'],
        'dominant7',
      ),
      ChordDegree.ii: _ChordData('Dm', ['D', 'F', 'A'], 'minor'),
      ChordDegree.iii: _ChordData('Edim', ['E', 'G', 'A#'], 'diminished'),
      ChordDegree.iv: _ChordData('F', ['F', 'A', 'C'], 'major'),
      ChordDegree.v: _ChordData('Gm', ['G', 'A#', 'D'], 'minor'),
      ChordDegree.vi: _ChordData('Am', ['A', 'C', 'E'], 'minor'),
      // bVII — the defining Mixolydian chord
      ChordDegree.vii: _ChordData(
        'Bb',
        ['A#', 'D', 'F'],
        'major',
        'Bb7',
        ['A#', 'D', 'F', 'G#'],
        'dominant7',
      ),
    },

    // ── C Diminished (chromatic/octatonic palette) ────────────────────────────
    //   Draws from half-whole diminished relationships.
    //   Symmetric, chromatic, dissonant — used for dark/mysterious progressions.
    //   Chords are selected for practical musical interest, not strict
    //   diatonic derivation from the 8-note scale.
    ScaleType.diminishedScale: {
      ChordDegree.i: _ChordData('Cdim', ['C', 'D#', 'F#'], 'diminished'),
      // bII (Neapolitan / Phrygian-flavored major chord)
      ChordDegree.ii: _ChordData('Db', ['C#', 'F', 'G#'], 'major'),
      ChordDegree.iii: _ChordData('D#m', ['D#', 'F#', 'A#'], 'minor'),
      // E major — tritone substitution area; bright contrast in dark context
      ChordDegree.iv: _ChordData('E', ['E', 'G#', 'B'], 'major'),
      // F#dim — symmetric partner of Cdim (tritone away)
      ChordDegree.v: _ChordData('F#dim', ['F#', 'A', 'C'], 'diminished'),
      // G major — natural resolution escape chord
      ChordDegree.vi: _ChordData('G', ['G', 'B', 'D'], 'major'),
      // Bbm — chromatic minor neighbor completing the symmetric loop
      ChordDegree.vii: _ChordData('Bbm', ['A#', 'C#', 'F'], 'minor'),
    },
  };
}

// ---------------------------------------------------------------------------
// Private data container — not part of the public API
// ---------------------------------------------------------------------------

class _ChordData {
  final String name;
  final List<String> notes;
  final String quality;

  /// Chord name to use when high tension is requested (e.g. "G7", "Cmaj7").
  final String? tensionVariant;

  /// Note list for the tension variant — includes the 7th.
  /// If null, the base [notes] are reused (backward-compatible).
  final List<String>? tensionNotes;

  /// Quality string for the tension variant (e.g. "dominant7", "major7").
  /// If null, the base [quality] is reused.
  final String? tensionQuality;

  const _ChordData(
    this.name,
    this.notes,
    this.quality, [
    this.tensionVariant,
    this.tensionNotes,
    this.tensionQuality,
  ]);
}
