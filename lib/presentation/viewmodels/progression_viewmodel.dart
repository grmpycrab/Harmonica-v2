import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/app_providers.dart';
import '../../domain/entities/emotion_type.dart';
import '../../domain/entities/progression.dart';
import '../../domain/usecases/generate_progression_usecase.dart';

part 'progression_viewmodel.g.dart';

/// State for the chord progression generator screen.
class ProgressionState {
  const ProgressionState({
    this.selectedEmotion,
    this.progression,
    this.isLoading = false,
    this.error,
    this.key = '',
    this.genre = '',
  });

  final EmotionType? selectedEmotion;
  final Progression? progression;
  final bool isLoading;
  final String? error;
  final String key;
  final String genre;

  ProgressionState copyWith({
    EmotionType? selectedEmotion,
    Progression? progression,
    bool? isLoading,
    String? error,
    String? key,
    String? genre,
  }) {
    return ProgressionState(
      selectedEmotion: selectedEmotion ?? this.selectedEmotion,
      progression: progression ?? this.progression,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      key: key ?? this.key,
      genre: genre ?? this.genre,
    );
  }
}

@riverpod
class ProgressionViewModel extends _$ProgressionViewModel {
  @override
  ProgressionState build() => const ProgressionState();

  void selectEmotion(EmotionType emotion) {
    state = state.copyWith(selectedEmotion: emotion, progression: null);
  }

  void updateKey(String key) {
    state = state.copyWith(key: key);
  }

  void updateGenre(String genre) {
    state = state.copyWith(genre: genre);
  }

  void generate() {
    final emotion = state.selectedEmotion;
    if (emotion == null) {
      state = state.copyWith(error: 'Please select an emotion first.');
      return;
    }

    final useCase = ref.read(generateProgressionUseCaseProvider);
    final progression = useCase.execute(
      GenerateProgressionParams(
        emotion: emotion,
        key: state.key,
        genre: state.genre,
      ),
    );

    state = state.copyWith(progression: progression, error: null);
  }

  void generateRandom() {
    final generator = ref.read(chordGeneratorServiceProvider);
    final progression = generator.generateRandom();
    state = state.copyWith(
      selectedEmotion: progression.emotion,
      progression: progression,
      error: null,
    );
  }

  void reset() {
    state = const ProgressionState();
  }
}
