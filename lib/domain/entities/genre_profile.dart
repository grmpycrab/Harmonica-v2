import 'chord_degree.dart';
import 'scale_type.dart';

/// Encapsulates all harmonic rules associated with a musical genre.
///
/// A [GenreProfile] is never used alone — it is *merged* with the active
/// [EmotionProfile] inside [ProgressionGenerator]. The merge algorithm
/// blends tension, variation, scale pools, and pattern pools so that the
/// generated chord progression is simultaneously emotionally accurate and
/// genre-stylistically convincing.
///
/// **Merge contract** (as applied in [ProgressionGenerator]):
/// * `preferredScales` narrows the emotion's scale pool via intersection;
///   if the intersection is empty the emotion's list is used as fallback.
/// * `progressionPatterns` enter a shared weighted pool alongside the
///   emotion's patterns; `repetitionFactor` controls their influence weight.
/// * `tensionBias + tensionBlend` pull the effective tension toward the
///   genre's characteristic harmonic density.
/// * `extensionLevel` unlocks 9th-chord voicings (5 notes) in [ScaleMapper]
///   for genres that use extended harmony (jazz, lo-fi, R&B).
class GenreProfile {
  const GenreProfile({
    required this.preferredScales,
    required this.progressionPatterns,
    required this.patternWeights,
    required this.tensionBias,
    required this.tensionBlend,
    required this.rhythmDensity,
    required this.repetitionFactor,
    required this.extensionLevel,
    required this.variationBias,
    required this.descriptionTags,
  });

  /// Scales that characterise this genre's harmonic palette.
  ///
  /// The generator uses the intersection of this list and the emotion's
  /// `allowedScales`. An empty intersection falls back to the emotion list.
  final List<ScaleType> preferredScales;

  /// Genre-typical chord progression templates expressed as scale degrees.
  ///
  /// These compete with emotion patterns in a shared weighted pool.
  /// A higher [repetitionFactor] gives these patterns more weight.
  final List<List<ChordDegree>> progressionPatterns;

  /// Relative weight for each pattern in [progressionPatterns].
  /// Must be index-aligned with [progressionPatterns].
  final List<double> patternWeights;

  /// Genre's preferred tension level (0.0 = triads only, 1.0 = max dissonance).
  /// Blended into the emotion's tension value using [tensionBlend].
  final double tensionBias;

  /// How strongly this genre overrides the emotion's tension value.
  /// 0.0 = no genre influence, 1.0 = genre fully determines tension.
  /// Typical: 0.3 (subtle colouring) – 0.7 (dominant genre character).
  final double tensionBlend;

  /// Rhythmic density hint for future DAW / sequencer integration.
  /// 0.0 = sparse/slow (ambient), 1.0 = dense/fast (techno).
  /// Not yet consumed in chord generation logic.
  final double rhythmDensity;

  /// Controls the weight of genre patterns in the combined pool.
  /// Also models the genre's structural repetition tendency:
  /// high values → genre loops dominate; low values → emotion patterns lead.
  final double repetitionFactor;

  /// Probability (0.0–1.0) of resolving chords to 9th (5-note) voicings
  /// when a ninth variant is available in [ScaleMapper].
  ///
  /// * < 0.5 → triads and 7ths only
  /// * 0.5–0.8 → 9th chords appear occasionally
  /// * > 0.8 → 9ths are the default colour (jazz, lo-fi, R&B)
  final double extensionLevel;

  /// Genre's preferred variation level blended lightly (30 %) with the
  /// emotion's own variation to produce the final substitution rate.
  final double variationBias;

  /// Short genre-flavoured descriptor strings. One is shown per generation.
  final List<String> descriptionTags;
}
