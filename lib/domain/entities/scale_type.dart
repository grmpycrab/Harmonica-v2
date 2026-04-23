/// The musical scale used to resolve chord degrees into concrete chords.
///
/// Currently all scales are rooted in the key of C for simplicity.
/// Extend [ScaleMapper] with additional root keys when multi-key support
/// is needed.
enum ScaleType {
  /// C Major — bright, resolved, happy
  major,

  /// A Natural Minor — dark, emotional, introspective
  naturalMinor,

  /// A Harmonic Minor — tense, dramatic, cinematic (raised 7th)
  harmonicMinor;

  String get label => switch (this) {
        ScaleType.major => 'C major',
        ScaleType.naturalMinor => 'A minor',
        ScaleType.harmonicMinor => 'A harmonic minor',
      };
}
