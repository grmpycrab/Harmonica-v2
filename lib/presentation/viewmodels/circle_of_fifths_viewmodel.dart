import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/services/circle_of_fifths_service.dart';
import '../../data/services/key_chord_service.dart';
import '../../domain/entities/key_analysis.dart';
import '../../domain/entities/music_key.dart';

part 'circle_of_fifths_viewmodel.g.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

/// All UI-visible state for the Circle of Fifths screen.
class CircleOfFifthsState {
  const CircleOfFifthsState({
    required this.selectedKey,
    required this.analysis,
    required this.majorKeys,
    required this.minorKeys,
    this.activeProgressionIndex,
  });

  /// The currently selected key (tapped node on the circle).
  final MusicKey selectedKey;

  /// Full harmonic analysis of [selectedKey].
  final KeyAnalysis analysis;

  /// All 12 major keys for rendering the outer ring.
  final List<MusicKey> majorKeys;

  /// All 12 relative minor keys for rendering the inner ring.
  final List<MusicKey> minorKeys;

  /// Index into [analysis.suggestedProgressions] that the user last tapped,
  /// null when none is highlighted.
  final int? activeProgressionIndex;

  CircleOfFifthsState copyWith({
    MusicKey? selectedKey,
    KeyAnalysis? analysis,
    List<MusicKey>? majorKeys,
    List<MusicKey>? minorKeys,
    int? activeProgressionIndex,
    bool clearProgressionIndex = false,
  }) {
    return CircleOfFifthsState(
      selectedKey: selectedKey ?? this.selectedKey,
      analysis: analysis ?? this.analysis,
      majorKeys: majorKeys ?? this.majorKeys,
      minorKeys: minorKeys ?? this.minorKeys,
      activeProgressionIndex: clearProgressionIndex
          ? null
          : (activeProgressionIndex ?? this.activeProgressionIndex),
    );
  }

  // Derived helpers used by the UI ──────────────────────────────────────────

  /// True when [key] is the currently selected key.
  bool isSelected(MusicKey key) => selectedKey == key;

  /// True when [key] is the relative of the selected key.
  bool isRelative(MusicKey key) =>
      key.tonic == selectedKey.relativeKey &&
      key.isMajor != selectedKey.isMajor;

  /// True when [key] is the dominant of the selected key.
  bool isDominant(MusicKey key) =>
      key.tonic == selectedKey.dominantKey &&
      key.isMajor == selectedKey.isMajor;

  /// True when [key] is the subdominant of the selected key.
  bool isSubdominant(MusicKey key) =>
      key.tonic == selectedKey.subdominantKey &&
      key.isMajor == selectedKey.isMajor;
}

// ---------------------------------------------------------------------------
// ViewModel
// ---------------------------------------------------------------------------

@riverpod
class CircleOfFifthsViewModel extends _$CircleOfFifthsViewModel {
  late final CircleOfFifthsService _circleService;
  late final KeyChordService _chordService;

  @override
  CircleOfFifthsState build() {
    _circleService = const CircleOfFifthsService();
    _chordService = const KeyChordService();

    final defaultKey = _circleService.defaultKey;
    return CircleOfFifthsState(
      selectedKey: defaultKey,
      analysis: _chordService.analyseKey(defaultKey),
      majorKeys: _circleService.majorKeys,
      minorKeys: _circleService.minorKeys,
    );
  }

  // ---------------------------------------------------------------------------
  // User interactions
  // ---------------------------------------------------------------------------

  /// Called when the user taps a key node on the circle.
  void selectKey(MusicKey key) {
    state = state.copyWith(
      selectedKey: key,
      analysis: _chordService.analyseKey(key),
      clearProgressionIndex: true,
    );
  }

  /// Highlights a suggested progression row in the panel.
  void selectProgression(int index) {
    final newIndex = state.activeProgressionIndex == index ? null : index;
    if (newIndex == null) {
      state = state.copyWith(clearProgressionIndex: true);
    } else {
      state = state.copyWith(activeProgressionIndex: newIndex);
    }
  }

  // ---------------------------------------------------------------------------
  // Action handlers — integrate with the generation pipeline
  // ---------------------------------------------------------------------------

  /// Returns the selected [SuggestedProgression]'s chord list (or the first
  /// suggestion if none highlighted) as a comma-separated string for routing.
  ///
  /// The caller (screen) navigates to PianoRoll with this payload.
  List<String> chordsForPianoRoll() {
    final idx = state.activeProgressionIndex ?? 0;
    final progressions = state.analysis.suggestedProgressions;
    if (progressions.isEmpty) return [];
    final prog = progressions[idx.clamp(0, progressions.length - 1)];
    return prog.chords.map((c) => c.name).toList();
  }
}
