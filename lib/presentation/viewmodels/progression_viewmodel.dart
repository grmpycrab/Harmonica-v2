import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/app_providers.dart';
import '../../domain/entities/emotion_type.dart';
import '../../domain/entities/genre_type.dart';
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
    this.selectedGenre,
  });

  final EmotionType? selectedEmotion;
  final Progression? progression;
  final bool isLoading;
  final String? error;
  final String key;
  final GenreType? selectedGenre;

  ProgressionState copyWith({
    EmotionType? selectedEmotion,
    Progression? progression,
    bool? isLoading,
    String? error,
    String? key,
    GenreType? selectedGenre,
    bool clearGenre = false,
  }) {
    return ProgressionState(
      selectedEmotion: selectedEmotion ?? this.selectedEmotion,
      progression: progression ?? this.progression,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      key: key ?? this.key,
      selectedGenre: clearGenre ? null : (selectedGenre ?? this.selectedGenre),
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

  /// Sets the active genre. Pass [null] to return to emotion-only mode.
  void updateGenre(GenreType? genre) {
    if (genre == null) {
      state = state.copyWith(clearGenre: true);
    } else {
      state = state.copyWith(selectedGenre: genre);
    }
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
        genreType: state.selectedGenre,
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
