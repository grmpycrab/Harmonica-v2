import 'package:flutter/material.dart';

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

  /// Material icon that represents this emotion — no emoji.
  IconData get icon => switch (this) {
        EmotionType.happy => Icons.wb_sunny_outlined,
        EmotionType.sad => Icons.water_drop_outlined,
        EmotionType.dark => Icons.nights_stay_outlined,
        EmotionType.hopeful => Icons.filter_drama_outlined,
        EmotionType.energetic => Icons.bolt_outlined,
        EmotionType.calm => Icons.waves_outlined,
        EmotionType.nostalgic => Icons.history_outlined,
        EmotionType.tense => Icons.warning_amber_outlined,
      };
}
