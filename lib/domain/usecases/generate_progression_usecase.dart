import '../entities/progression.dart';
import '../entities/emotion_type.dart';
import '../../data/services/chord_generator_service.dart';

/// Input parameters for progression generation.
class GenerateProgressionParams {
  const GenerateProgressionParams({
    required this.emotion,
    this.key = '',
    this.genre = '',
  });

  final EmotionType emotion;
  final String key;
  final String genre;
}

/// Use case: generates a chord progression for the given parameters.
///
/// All heavy generation logic lives in [ChordGeneratorService],
/// keeping this class thin and testable.
class GenerateProgressionUseCase {
  const GenerateProgressionUseCase(this._generator);

  final ChordGeneratorService _generator;

  Progression execute(GenerateProgressionParams params) {
    return _generator.generate(
      emotion: params.emotion,
      key: params.key,
      genre: params.genre,
    );
  }
}
