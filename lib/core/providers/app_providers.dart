import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/theory_local_datasource.dart';
import '../../data/repositories/theory_repository_impl.dart';
import '../../data/services/chord_generator_service.dart';
import '../../data/services/progression_generator.dart';
import '../../data/services/scale_mapper.dart';
import '../../domain/repositories/theory_repository.dart';
import '../../domain/usecases/generate_progression_usecase.dart';
import '../../domain/usecases/get_theory_lesson_usecase.dart';

part 'app_providers.g.dart';

// ---------------------------------------------------------------------------
// Services — innermost layer, no dependencies on other providers
// ---------------------------------------------------------------------------

@riverpod
ScaleMapper scaleMapper(ScaleMapperRef ref) => const ScaleMapper();

@riverpod
ProgressionGenerator progressionGenerator(ProgressionGeneratorRef ref) {
  return ProgressionGenerator(scaleMapper: ref.watch(scaleMapperProvider));
}

@riverpod
ChordGeneratorService chordGeneratorService(ChordGeneratorServiceRef ref) {
  return ChordGeneratorService(ref.watch(progressionGeneratorProvider));
}

@riverpod
TheoryLocalDatasource theoryLocalDatasource(TheoryLocalDatasourceRef ref) {
  return const TheoryLocalDatasource();
}

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

@riverpod
TheoryRepository theoryRepository(TheoryRepositoryRef ref) {
  return TheoryRepositoryImpl(
    datasource: ref.watch(theoryLocalDatasourceProvider),
    generator: ref.watch(chordGeneratorServiceProvider),
  );
}

// ---------------------------------------------------------------------------
// Use cases
// ---------------------------------------------------------------------------

@riverpod
GenerateProgressionUseCase generateProgressionUseCase(
  GenerateProgressionUseCaseRef ref,
) {
  return GenerateProgressionUseCase(ref.watch(chordGeneratorServiceProvider));
}

@riverpod
GetTheoryLessonUseCase getTheoryLessonUseCase(GetTheoryLessonUseCaseRef ref) {
  return GetTheoryLessonUseCase(ref.watch(theoryLocalDatasourceProvider));
}
