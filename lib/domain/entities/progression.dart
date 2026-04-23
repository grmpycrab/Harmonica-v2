import 'chord.dart';
import 'emotion_type.dart';

/// A chord progression with metadata.
class Progression {
  const Progression({
    required this.chords,
    required this.emotion,
    required this.description,
    this.key = '',
    this.genre = '',
  });

  final List<Chord> chords;
  final EmotionType emotion;

  /// Human-readable description of the mood/feel.
  final String description;

  /// Musical key, e.g. "A minor", "C major"
  final String key;

  /// Optional genre tag, e.g. "lo-fi", "trap"
  final String genre;

  /// Returns chord names joined by " - ", e.g. "Am - F - C - G"
  String get label => chords.map((c) => c.name).join(' - ');
}
