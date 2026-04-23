import '../../domain/entities/emotion_type.dart';
import '../../domain/entities/genre_type.dart';
import '../../domain/entities/progression.dart';
import 'progression_generator.dart';

/// Thin adapter that exposes [ProgressionGenerator] via the interface
/// expected by [GenerateProgressionUseCase] and [TheoryRepositoryImpl].
///
/// All generation logic lives in [ProgressionGenerator]. This class only
/// exists to preserve the existing dependency graph without cascading renames.
class ChordGeneratorService {
  const ChordGeneratorService(this._generator);

  final ProgressionGenerator _generator;

  /// [key] is accepted for API compatibility but is ignored at this stage —
  /// the generator derives the key from the emotion's allowed scales.
  Progression generate({
    required EmotionType emotion,
    String key = '',
    GenreType? genreType,
  }) {
    return _generator.generate(emotion: emotion, genre: genreType);
  }

  Progression generateRandom() => _generator.generateRandom();
}
