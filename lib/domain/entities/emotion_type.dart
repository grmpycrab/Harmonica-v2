import 'package:flutter/material.dart';

/// Represents the emotional character of a chord progression.
///
/// Each value maps to an [EmotionProfile] in [EmotionCatalog] which
/// defines the musical rules (scales, patterns, tension) used during
/// generation — emotion drives theory, not chord lookup tables.
///
/// The enum is intentionally closed: all music theory intelligence lives in
/// [EmotionCatalog] and [EmotionProfile], keeping this type a pure tag.
enum EmotionType {
  // ── Original eight ────────────────────────────────────────────────────────
  happy,
  sad,
  dark,
  hopeful,
  energetic,
  calm,
  nostalgic,
  tense,

  // ── Extended palette ──────────────────────────────────────────────────────
  romantic,
  angry,
  mysterious,
  euphoric,
  melancholic,
  anxious,
  triumphant,
  dreamy,
  lonely,
  playful,
  serene,
  dramatic;

  String get label => switch (this) {
        EmotionType.happy => 'Happy',
        EmotionType.sad => 'Sad',
        EmotionType.dark => 'Dark',
        EmotionType.hopeful => 'Hopeful',
        EmotionType.energetic => 'Energetic',
        EmotionType.calm => 'Calm',
        EmotionType.nostalgic => 'Nostalgic',
        EmotionType.tense => 'Tense',
        EmotionType.romantic => 'Romantic',
        EmotionType.angry => 'Angry',
        EmotionType.mysterious => 'Mysterious',
        EmotionType.euphoric => 'Euphoric',
        EmotionType.melancholic => 'Melancholic',
        EmotionType.anxious => 'Anxious',
        EmotionType.triumphant => 'Triumphant',
        EmotionType.dreamy => 'Dreamy',
        EmotionType.lonely => 'Lonely',
        EmotionType.playful => 'Playful',
        EmotionType.serene => 'Serene',
        EmotionType.dramatic => 'Dramatic',
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
        EmotionType.romantic => Icons.favorite_border,
        EmotionType.angry => Icons.whatshot_outlined,
        EmotionType.mysterious => Icons.blur_on,
        EmotionType.euphoric => Icons.celebration_outlined,
        EmotionType.melancholic => Icons.cloud_outlined,
        EmotionType.anxious => Icons.loop_outlined,
        EmotionType.triumphant => Icons.military_tech_outlined,
        EmotionType.dreamy => Icons.auto_awesome_outlined,
        EmotionType.lonely => Icons.person_outlined,
        EmotionType.playful => Icons.sports_esports_outlined,
        EmotionType.serene => Icons.self_improvement_outlined,
        EmotionType.dramatic => Icons.theaters_outlined,
      };
}
