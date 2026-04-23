import 'dart:math';

import '../../domain/entities/chord_degree.dart';
import '../../domain/entities/emotion_type.dart';
import '../../domain/entities/genre_type.dart';
import '../../domain/entities/progression.dart';
import '../../domain/entities/scale_type.dart';
import 'emotion_catalog.dart';
import 'genre_catalog.dart';
import 'scale_mapper.dart';

/// Core service that generates musically meaningful [Progression]s.
///
/// **Generation flow (emotion only):**
///   EmotionType → EmotionProfile → pattern → variation → scale → chords
///
/// **Generation flow (emotion + genre):**
///   EmotionType + GenreType
///     → EmotionProfile + GenreProfile
///     → Profile merge  (scale pool, pattern pool, tension, variation, ninths)
///     → Weighted pattern selection
///     → Variation pass (diatonic substitutions)
///     → Scale resolution (tension / ninth -aware degree → chord mapping)
///     → Progression
///
/// **Merge contract:**
/// * Scale pool  — intersection of genre and emotion scales (emotion fallback)
/// * Pattern pool — emotion patterns + genre patterns in a shared weighted pool
///                  weighted by [GenreProfile.repetitionFactor]
/// * Tension     — `emotionTension × (1 − blend) + genreTension × blend`
/// * Variation   — 70 % emotion / 30 % genre
/// * 9th chords  — activated when [GenreProfile.extensionLevel] > 0.5
///
/// Zero Flutter / Riverpod dependencies — fully unit-testable.
class ProgressionGenerator {
  ProgressionGenerator({required ScaleMapper scaleMapper})
      : _scaleMapper = scaleMapper,
        _random = Random();

  final ScaleMapper _scaleMapper;
  final Random _random;

  /// Generates a [Progression] governed by [emotion] and optionally shaped
  /// by [genre]. When [genre] is null the output is identical to the
  /// emotion-only behaviour.
  Progression generate({
    required EmotionType emotion,
    GenreType? genre,
  }) {
    final emotionProfile = EmotionCatalog.profileFor(emotion);

    // ── Merge profiles when a genre is active ──────────────────────────────
    final List<ChordDegree> Function() selectPattern;
    final double effectiveTension;
    final double effectiveVariation;
    final List<ScaleType> scalePool;
    bool withNinth = false;

    if (genre != null) {
      final genreProfile = GenreCatalog.profileFor(genre);

      // Scale pool: genre ∩ emotion; fallback to emotion if intersection empty
      final intersection = genreProfile.preferredScales
          .where((s) => emotionProfile.allowedScales.contains(s))
          .toList();
      scalePool =
          intersection.isNotEmpty ? intersection : emotionProfile.allowedScales;

      // Pattern pool: emotion patterns weighted down by genre's repFactor,
      // genre patterns weighted up — higher repFactor → genre dominates.
      final eWeight = 1.0 - genreProfile.repetitionFactor * 0.5;
      final gWeight = genreProfile.repetitionFactor * 0.5;
      final combinedPatterns = [
        ...emotionProfile.preferredPatterns,
        ...genreProfile.progressionPatterns,
      ];
      final combinedWeights = [
        ...emotionProfile.patternWeights.map((w) => w * eWeight),
        ...genreProfile.patternWeights.map((w) => w * gWeight),
      ];
      selectPattern =
          () => _selectWeightedPattern(combinedPatterns, combinedWeights);

      // Tension: genre pulls the emotion's value toward its own bias
      effectiveTension =
          emotionProfile.tensionLevel * (1.0 - genreProfile.tensionBlend) +
              genreProfile.tensionBias * genreProfile.tensionBlend;

      // Variation: light genre influence (70 % emotion, 30 % genre)
      effectiveVariation =
          emotionProfile.variation * 0.7 + genreProfile.variationBias * 0.3;

      // 9th chords: genre-driven; activates when extensionLevel > 0.5
      withNinth = genreProfile.extensionLevel > 0.5 &&
          _random.nextDouble() < genreProfile.extensionLevel;
    } else {
      scalePool = emotionProfile.allowedScales;
      selectPattern = () => _selectWeightedPattern(
            emotionProfile.preferredPatterns,
            emotionProfile.patternWeights,
          );
      effectiveTension = emotionProfile.tensionLevel;
      effectiveVariation = emotionProfile.variation;
    }

    // A — Weighted pattern selection
    final pattern = selectPattern();

    // D — Variation: apply diatonic chord substitutions
    final varied = _applyVariation(pattern, effectiveVariation);

    // Pick scale for this generation run
    final scale = scalePool[_random.nextInt(scalePool.length)];

    // C — Tension control: decide once per progression whether to use
    //     7th chord variants. 9th chords (when active) include the 7th,
    //     so tension is suppressed to avoid conflicts.
    final useTension = !withNinth &&
        effectiveTension > 0.5 &&
        _random.nextDouble() < (effectiveTension - 0.5) * 2.0;

    // Resolve each degree to a concrete chord
    final chords = varied
        .map(
          (d) => _scaleMapper.resolve(
            d,
            scale,
            withTension: useTension,
            withNinth: withNinth,
          ),
        )
        .toList();

    final description = emotionProfile
        .descriptions[_random.nextInt(emotionProfile.descriptions.length)];

    return Progression(
      chords: chords,
      emotion: emotion,
      genreType: genre,
      description: description,
      key: _scaleMapper.keyLabel(scale),
      genre: genre?.label ?? '',
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
        // VI → IV: relative substitution
        ChordDegree.vi when _random.nextDouble() < 0.4 => ChordDegree.iv,
        // III → I: mediant to tonic
        ChordDegree.iii when _random.nextDouble() < 0.3 => ChordDegree.i,
        // II → IV: pre-dominant swap
        ChordDegree.ii when _random.nextDouble() < 0.3 => ChordDegree.iv,
        // VII → V: tension interchange
        ChordDegree.vii when _random.nextDouble() < 0.3 => ChordDegree.v,
        _ => degree,
      };
}
