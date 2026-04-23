import 'dart:math';

import '../../domain/entities/chord_degree.dart';
import '../../domain/entities/emotion_type.dart';
import '../../domain/entities/progression.dart';
import 'emotion_catalog.dart';
import 'scale_mapper.dart';

/// Core service that generates musically meaningful [Progression]s.
///
/// Generation flow:
///   EmotionType
///     → EmotionProfile  (rules: scales, patterns, tension, variation)
///     → Pattern selection  (A: weighted random)
///     → Variation pass     (D: chord substitutions)
///     → Scale resolution   (C: tension-aware degree → chord mapping)
///     → Progression
///
/// All music-theory decisions live here or in [EmotionCatalog]/[ScaleMapper].
/// Zero Flutter/Riverpod dependencies — fully unit-testable.
class ProgressionGenerator {
  ProgressionGenerator({required ScaleMapper scaleMapper})
      : _scaleMapper = scaleMapper,
        _random = Random();

  final ScaleMapper _scaleMapper;
  final Random _random;

  /// Generates a [Progression] governed by the musical rules for [emotion].
  Progression generate({required EmotionType emotion, String genre = ''}) {
    final profile = EmotionCatalog.profileFor(emotion);

    // A — Weighted pattern selection
    final pattern = _selectWeightedPattern(
      profile.preferredPatterns,
      profile.patternWeights,
    );

    // D — Variation: apply diatonic chord substitutions
    final varied = _applyVariation(pattern, profile.variation);

    // Pick scale for this generation run
    final scale =
        profile.allowedScales[_random.nextInt(profile.allowedScales.length)];

    // C — Tension control: decide once per progression whether to use
    //     tension variants (e.g. G→G7, E→E7) on applicable degrees.
    //     Probability scales with tensionLevel above 0.5 threshold.
    final useTension = profile.tensionLevel > 0.5 &&
        _random.nextDouble() < (profile.tensionLevel - 0.5) * 2.0;

    // Resolve each degree to a concrete chord
    final chords = varied
        .map((d) => _scaleMapper.resolve(d, scale, withTension: useTension))
        .toList();

    final description =
        profile.descriptions[_random.nextInt(profile.descriptions.length)];

    return Progression(
      chords: chords,
      emotion: emotion,
      description: description,
      key: _scaleMapper.keyLabel(scale),
      genre: genre,
    );
  }

  /// Generates a random [Progression] across all emotions (Inspiration Mode).
  Progression generateRandom() {
    final emotions = EmotionType.values;
    return generate(emotion: emotions[_random.nextInt(emotions.length)]);
  }

  // ---------------------------------------------------------------------------
  // A — Weighted pattern selection
  // ---------------------------------------------------------------------------

  /// Returns a pattern chosen proportionally to its weight.
  /// Higher-weight patterns appear more often without being exclusive.
  List<ChordDegree> _selectWeightedPattern(
    List<List<ChordDegree>> patterns,
    List<double> weights,
  ) {
    final total = weights.fold(0.0, (sum, w) => sum + w);
    var roll = _random.nextDouble() * total;
    for (int i = 0; i < patterns.length; i++) {
      roll -= weights[i];
      if (roll <= 0) return List.of(patterns[i]);
    }
    return List.of(patterns.last);
  }

  // ---------------------------------------------------------------------------
  // D — Variation: diatonic chord substitutions
  // ---------------------------------------------------------------------------

  /// Applies chord substitutions with probability proportional to [variation].
  ///
  /// Substitutions are musically justified:
  ///   IV  →  II   (subdominant substitution — shares two common tones)
  ///   I   →  VI   (tonic substitution — VI is the relative minor of I)
  ///   V   →  VII  (leading-tone substitution — lighter resolution)
  List<ChordDegree> _applyVariation(
    List<ChordDegree> pattern,
    double variation,
  ) {
    if (variation < 0.3) return List.of(pattern);

    return pattern.map((degree) {
      // Per-chord substitution probability = variation × 0.35
      if (_random.nextDouble() < variation * 0.35) {
        return _substitute(degree);
      }
      return degree;
    }).toList();
  }

  ChordDegree _substitute(ChordDegree degree) => switch (degree) {
        // IV → II: subdominant substitution
        ChordDegree.iv => ChordDegree.ii,
        // I → VI: tonic substitution (adds longing), only 35% of the time
        ChordDegree.i when _random.nextDouble() < 0.35 => ChordDegree.vi,
        // V → VII: leading-tone substitution, only 25% of the time
        ChordDegree.v when _random.nextDouble() < 0.25 => ChordDegree.vii,
        _ => degree,
      };
}
