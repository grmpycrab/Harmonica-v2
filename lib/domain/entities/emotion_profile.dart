import 'chord_degree.dart';
import 'scale_type.dart';

/// Encapsulates all musical rules associated with an emotion.
///
/// This is the bridge between "how something feels" and "how it sounds".
/// [ProgressionGenerator] reads these rules to generate musically
/// meaningful chord progressions rather than picking chords at random.
class EmotionProfile {
  const EmotionProfile({
    required this.allowedScales,
    required this.preferredPatterns,
    required this.patternWeights,
    required this.tensionLevel,
    required this.variation,
    required this.descriptions,
  });

  /// Scales that are musically appropriate for this emotion.
  /// When multiple are listed, the generator picks one at random.
  final List<ScaleType> allowedScales;

  /// Chord progression templates expressed as scale degrees.
  /// Index-aligned with [patternWeights].
  final List<List<ChordDegree>> preferredPatterns;

  /// Relative probability weight for each pattern in [preferredPatterns].
  /// Higher value = more likely to be chosen.
  final List<double> patternWeights;

  /// 0.0 = fully resolved/stable, 1.0 = maximum tension/dissonance.
  /// Controls whether dominant 7ths, diminished chords, etc. appear.
  final double tensionLevel;

  /// 0.0 = always the same patterns, 1.0 = highly substituted/varied.
  /// Controls how often chord substitutions are applied.
  final double variation;

  /// Human-readable descriptions of the mood. One is chosen per generation.
  final List<String> descriptions;
}
