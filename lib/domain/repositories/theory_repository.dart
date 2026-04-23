import '../entities/progression.dart';
import '../entities/emotion_type.dart';

/// Abstract repository contract for music theory data.
abstract interface class TheoryRepository {
  /// Returns all available lessons in structured form.
  Future<List<Map<String, dynamic>>> getLessons();

  /// Returns cached or mock progressions by emotion.
  Future<List<Progression>> getProgressionsByEmotion(EmotionType emotion);
}
