/// Represents the emotional character of a chord progression.
///
/// Each value maps to an [EmotionProfile] in [EmotionCatalog] which
/// defines the musical rules (scales, patterns, tension) used during
/// generation — emotion drives theory, not chord lookup tables.
enum EmotionType {
  happy,
  sad,
  dark,
  hopeful,
  energetic,
  calm,
  nostalgic,
  tense;

  String get label => switch (this) {
        EmotionType.happy => 'Happy',
        EmotionType.sad => 'Sad',
        EmotionType.dark => 'Dark',
        EmotionType.hopeful => 'Hopeful',
        EmotionType.energetic => 'Energetic',
        EmotionType.calm => 'Calm',
        EmotionType.nostalgic => 'Nostalgic',
        EmotionType.tense => 'Tense',
      };

  String get emoji => switch (this) {
        EmotionType.happy => '😊',
        EmotionType.sad => '😢',
        EmotionType.dark => '🌑',
        EmotionType.hopeful => '🌅',
        EmotionType.energetic => '⚡',
        EmotionType.calm => '🌊',
        EmotionType.nostalgic => '🎞️',
        EmotionType.tense => '😤',
      };
}
