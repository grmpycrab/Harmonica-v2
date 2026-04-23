import 'package:flutter/material.dart';

/// Musical genre that biases the harmonic output of [ProgressionGenerator].
///
/// Genres shape *how* a progression feels without overriding *what* emotion
/// it expresses. The merge algorithm in [ProgressionGenerator] blends
/// [GenreProfile] values with [EmotionProfile] values so that the output is
/// simultaneously emotionally true and genre-accurate.
///
/// **Extensibility**: add a new value here and a corresponding entry in
/// [GenreCatalog._catalog] — no other plumbing required.
enum GenreType {
  pop,
  edm,
  loFi,
  hipHop,
  trap,
  rock,
  jazz,
  rnb,
  cinematic,
  ambient,
  house,
  techno;

  String get label => switch (this) {
        GenreType.pop => 'Pop',
        GenreType.edm => 'EDM',
        GenreType.loFi => 'Lo-Fi',
        GenreType.hipHop => 'Hip-Hop',
        GenreType.trap => 'Trap',
        GenreType.rock => 'Rock',
        GenreType.jazz => 'Jazz',
        GenreType.rnb => 'R&B',
        GenreType.cinematic => 'Cinematic',
        GenreType.ambient => 'Ambient',
        GenreType.house => 'House',
        GenreType.techno => 'Techno',
      };

  IconData get icon => switch (this) {
        GenreType.pop => Icons.star_outline,
        GenreType.edm => Icons.graphic_eq,
        GenreType.loFi => Icons.coffee_outlined,
        GenreType.hipHop => Icons.mic_none_outlined,
        GenreType.trap => Icons.noise_aware_outlined,
        GenreType.rock => Icons.electric_bolt_outlined,
        GenreType.jazz => Icons.piano_outlined,
        GenreType.rnb => Icons.album_outlined,
        GenreType.cinematic => Icons.movie_outlined,
        GenreType.ambient => Icons.blur_circular_outlined,
        GenreType.house => Icons.nightlife_outlined,
        GenreType.techno => Icons.tune_outlined,
      };
}
