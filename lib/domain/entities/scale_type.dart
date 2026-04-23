/// The musical scale used to resolve chord degrees into concrete chords.
///
/// All scales are rooted in C for simplicity. Extend [ScaleMapper] with
/// additional root keys when multi-key support is needed.
///
/// Mode theory note: Dorian, Phrygian, Lydian, and Mixolydian are the
/// most harmonically distinct modes and each produces a markedly different
/// emotional palette even from the same root note.
enum ScaleType {
  // ── Diatonic foundations ──────────────────────────────────────────────────

  /// C Major — bright, resolved, happy
  major,

  /// A Natural Minor — introspective, emotional, unresolved
  naturalMinor,

  /// A Harmonic Minor — tense, dramatic, cinematic (raised 7th)
  harmonicMinor,

  // ── Extended scales / modes ───────────────────────────────────────────────

  /// C Melodic Minor (ascending form) — sophisticated, bittersweet.
  /// Major IV and V over a minor tonic produce a uniquely modern colour.
  melodicMinor,

  /// C Dorian — minor with a raised 6th; smooth and soulful.
  /// The raised 6th (A natural) gives it warmth absent from natural minor.
  dorianMode,

  /// C Phrygian — minor with a lowered 2nd; dark, flamenco, intense.
  /// The bII chord is the defining marker of Phrygian aggression.
  phrygianMode,

  /// C Lydian — major with a raised 4th; dreamy, floating, cinematic.
  /// The #4 (tritone above root) creates a luminous, suspended quality.
  lydianMode,

  /// C Mixolydian — major with a lowered 7th; rock, bluesy, open.
  /// The bVII chord lends an earthy, unresolved brightness.
  mixolydianMode,

  /// C Diminished (chromatic/octatonic) — highly chromatic and dark.
  /// Built from half-whole diminished relationships; symmetric and dissonant.
  diminishedScale;

  String get label => switch (this) {
        ScaleType.major => 'C major',
        ScaleType.naturalMinor => 'A minor',
        ScaleType.harmonicMinor => 'A harmonic minor',
        ScaleType.melodicMinor => 'C melodic minor',
        ScaleType.dorianMode => 'C Dorian',
        ScaleType.phrygianMode => 'C Phrygian',
        ScaleType.lydianMode => 'C Lydian',
        ScaleType.mixolydianMode => 'C Mixolydian',
        ScaleType.diminishedScale => 'C diminished',
      };
}
