import '../../domain/entities/emotion_type.dart';
import '../../domain/entities/progression.dart';
import '../../domain/repositories/theory_repository.dart';
import '../datasources/theory_local_datasource.dart';
import '../services/chord_generator_service.dart';

/// Concrete implementation of [TheoryRepository] backed by local data.
class TheoryRepositoryImpl implements TheoryRepository {
  const TheoryRepositoryImpl({
    required TheoryLocalDatasource datasource,
    required ChordGeneratorService generator,
  }) : _datasource = datasource,
       _generator = generator;

  final TheoryLocalDatasource _datasource;
  final ChordGeneratorService _generator;

  @override
  Future<List<Map<String, dynamic>>> getLessons() => _datasource.getLessons();

  @override
  Future<List<Progression>> getProgressionsByEmotion(
    EmotionType emotion,
  ) async {
    // Generate 4 sample progressions for the given emotion
    return List.generate(4, (_) => _generator.generate(emotion: emotion));
  }
}
