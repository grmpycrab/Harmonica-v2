import '../../domain/entities/chord.dart';
import '../../domain/entities/chord_degree.dart';
import '../../domain/entities/scale_type.dart';

/// Resolves a [ChordDegree] within a [ScaleType] to a concrete [Chord].
///
/// All scales are currently in the key of C (C major / A minor family).
/// To support additional keys in the future, add more entries to [_scales]
/// with a root-note parameter and update [ScaleType] accordingly.
///
/// [withTension] — when true and a tension variant exists for the degree
/// (e.g. G → G7, E → E7), the variant name is used. The caller
/// ([ProgressionGenerator]) decides probabilistically whether to apply this.
class ScaleMapper {
  const ScaleMapper();

  Chord resolve(
    ChordDegree degree,
    ScaleType scale, {
    bool withTension = false,
  }) {
    final data = _scales[scale]![degree]!;
    final name = withTension && data.tensionVariant != null
        ? data.tensionVariant!
        : data.name;
    return Chord(name: name, notes: data.notes, quality: data.quality);
  }

  String keyLabel(ScaleType scale) => scale.label;

  // ---------------------------------------------------------------------------
  // Scale definitions — key of C
  // ---------------------------------------------------------------------------
  //
  // C Major diatonic chords:
  //   I=C  II=Dm  III=Em  IV=F  V=G  VI=Am  VII=Bdim
  //
  // A Natural Minor (relative minor of C Major):
  //   I=Am  II=Bdim  III=C  IV=Dm  V=Em  VI=F  VII=G
  //
  // A Harmonic Minor (raised 7th → G#):
  //   I=Am  II=Bdim  III=Caug  IV=Dm  V=E  VI=F  VII=G#dim
  // ---------------------------------------------------------------------------

  static const Map<ScaleType, Map<ChordDegree, _ChordData>> _scales = {
    ScaleType.major: {
      ChordDegree.i: _ChordData('C', ['C', 'E', 'G'], 'major'),
      ChordDegree.ii: _ChordData('Dm', ['D', 'F', 'A'], 'minor'),
      ChordDegree.iii: _ChordData('Em', ['E', 'G', 'B'], 'minor'),
      ChordDegree.iv: _ChordData('F', ['F', 'A', 'C'], 'major'),
      ChordDegree.v: _ChordData('G', ['G', 'B', 'D'], 'major', 'G7'),
      ChordDegree.vi: _ChordData('Am', ['A', 'C', 'E'], 'minor'),
      ChordDegree.vii: _ChordData('Bdim', ['B', 'D', 'F'], 'diminished'),
    },
    ScaleType.naturalMinor: {
      ChordDegree.i: _ChordData('Am', ['A', 'C', 'E'], 'minor'),
      ChordDegree.ii: _ChordData('Bdim', ['B', 'D', 'F'], 'diminished'),
      ChordDegree.iii: _ChordData('C', ['C', 'E', 'G'], 'major'),
      ChordDegree.iv: _ChordData('Dm', ['D', 'F', 'A'], 'minor'),
      // V stays minor diatonic; tension variant borrows harmonic minor's major V
      ChordDegree.v: _ChordData('Em', ['E', 'G', 'B'], 'minor', 'E'),
      ChordDegree.vi: _ChordData('F', ['F', 'A', 'C'], 'major'),
      ChordDegree.vii: _ChordData('G', ['G', 'B', 'D'], 'major'),
    },
    ScaleType.harmonicMinor: {
      ChordDegree.i: _ChordData('Am', ['A', 'C', 'E'], 'minor'),
      ChordDegree.ii: _ChordData('Bdim', ['B', 'D', 'F'], 'diminished'),
      ChordDegree.iii: _ChordData('Caug', ['C', 'E', 'G#'], 'augmented'),
      ChordDegree.iv: _ChordData('Dm', ['D', 'F', 'A'], 'minor'),
      // V = major due to the raised 7th (G#), giving strong harmonic resolution
      ChordDegree.v: _ChordData('E', ['E', 'G#', 'B'], 'major', 'E7'),
      ChordDegree.vi: _ChordData('F', ['F', 'A', 'C'], 'major'),
      ChordDegree.vii: _ChordData('G#dim', ['G#', 'B', 'D'], 'diminished'),
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

  /// Optional chord name to use when high tension is requested.
  /// e.g. G → G7 (dominant 7th adds strong pull back to tonic)
  final String? tensionVariant;

  const _ChordData(this.name, this.notes, this.quality, [this.tensionVariant]);
}
