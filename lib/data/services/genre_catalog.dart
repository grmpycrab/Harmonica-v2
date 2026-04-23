import '../../domain/entities/chord_degree.dart';
import '../../domain/entities/genre_profile.dart';
import '../../domain/entities/genre_type.dart';
import '../../domain/entities/scale_type.dart';

/// Maps every [GenreType] to its [GenreProfile].
///
/// **Editing guide**
/// * `preferredScales` — which modal colours belong to this genre
/// * `progressionPatterns` — genre-typical degree sequences (3–6 chords)
/// * `patternWeights` — must sum to 1.0; higher = more frequent
/// * `tensionBias` — genre's desired tension (0.0 triads → 1.0 max dissonance)
/// * `tensionBlend` — how strongly genre steers away from emotion tension
///   - 0.3 = subtle genre tint / 0.7 = genre dominates
/// * `rhythmDensity` — 0.0 sparse…1.0 dense (future sequencer use)
/// * `repetitionFactor` — how much genre patterns dominate the pool
/// * `extensionLevel` — 9th chord probability (>0.5 needed to activate)
/// * `variationBias` — genre's substitution rate (30% weight in blend)
/// * `descriptionTags` — one is shown in the UI per generation run
class GenreCatalog {
  GenreCatalog._();

  static GenreProfile profileFor(GenreType genre) => _catalog[genre]!;

  static const Map<GenreType, GenreProfile> _catalog = {
    // =========================================================================
    // ── POP ───────────────────────────────────────────────────────────────────
    // Catchy, predictable, bright — built on major tonality and the "4-chord
    // song". Minimal tension; triads dominate; high repetition for hooks.
    // =========================================================================
    GenreType.pop: GenreProfile(
      preferredScales: [ScaleType.major, ScaleType.lydianMode],
      progressionPatterns: [
        // The "4-chord song" — I–V–vi–IV
        [ChordDegree.i, ChordDegree.v, ChordDegree.vi, ChordDegree.iv],
        // Classic pop cadence — I–IV–V–I
        [ChordDegree.i, ChordDegree.iv, ChordDegree.v, ChordDegree.i],
        // Axis progression — vi–IV–I–V
        [ChordDegree.vi, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
        // Upbeat pop shuffle — I–V–IV–I
        [ChordDegree.i, ChordDegree.v, ChordDegree.iv, ChordDegree.i],
        // Pre-chorus build — I–IV–ii–V
        [ChordDegree.i, ChordDegree.iv, ChordDegree.ii, ChordDegree.v],
      ],
      patternWeights: [0.35, 0.25, 0.2, 0.12, 0.08],
      tensionBias: 0.15,
      tensionBlend: 0.35,
      rhythmDensity: 0.65,
      repetitionFactor: 0.75,
      extensionLevel: 0.1,
      variationBias: 0.2,
      descriptionTags: [
        'Catchy and singable — chart-ready harmony.',
        'Hook-driven pop structure — designed to repeat.',
        'Bright and accessible — feels instantly familiar.',
        'Feel-good pop movement — nothing surprises, everything satisfies.',
        'The sound of a radio hit taking shape.',
      ],
    ),

    // =========================================================================
    // ── EDM ───────────────────────────────────────────────────────────────────
    // Driving, hypnotic, high-energy — minor tonality with Mixolydian
    // colour. Extremely high repetition; moderate tension for drop builds.
    // =========================================================================
    GenreType.edm: GenreProfile(
      preferredScales: [
        ScaleType.naturalMinor,
        ScaleType.melodicMinor,
        ScaleType.mixolydianMode,
      ],
      progressionPatterns: [
        // Classic EDM minor loop — i–VI–III–VII
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iii, ChordDegree.vii],
        // Andalusian drop — i–VII–VI–V
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.v],
        // Anthem build — I–IV–V–I (in a major/mixo context)
        [ChordDegree.i, ChordDegree.iv, ChordDegree.v, ChordDegree.i],
        // Pre-drop tension — VI–VII–i–i
        [ChordDegree.vi, ChordDegree.vii, ChordDegree.i, ChordDegree.i],
        // 5-chord evolving sweep — i–VI–III–VII–IV
        [
          ChordDegree.i,
          ChordDegree.vi,
          ChordDegree.iii,
          ChordDegree.vii,
          ChordDegree.iv
        ],
      ],
      patternWeights: [0.35, 0.25, 0.18, 0.12, 0.1],
      tensionBias: 0.42,
      tensionBlend: 0.45,
      rhythmDensity: 0.85,
      repetitionFactor: 0.9,
      extensionLevel: 0.15,
      variationBias: 0.25,
      descriptionTags: [
        'Driving and hypnotic — built for the drop.',
        'Dance-floor energy in chord form.',
        'Looping minor tension — synth-ready progression.',
        'EDM anthem structure — build, drop, repeat.',
        'High-energy harmonic loop that never gets old.',
      ],
    ),

    // =========================================================================
    // ── LO-FI ─────────────────────────────────────────────────────────────────
    // Warm, jazzy, nostalgic — jazz-borrowed ii–V–I movement over dusty
    // hip-hop drums. Extended 9th chords are the defining colour here.
    // =========================================================================
    GenreType.loFi: GenreProfile(
      preferredScales: [
        ScaleType.major,
        ScaleType.naturalMinor,
        ScaleType.dorianMode,
        ScaleType.melodicMinor,
      ],
      progressionPatterns: [
        // Jazz loop — I–VI–II–V (lo-fi's harmonic home)
        [ChordDegree.i, ChordDegree.vi, ChordDegree.ii, ChordDegree.v],
        // Smooth mediant movement — I–III–VI–IV
        [ChordDegree.i, ChordDegree.iii, ChordDegree.vi, ChordDegree.iv],
        // Jazz ii–V–I descent — ii–V–I–VI
        [ChordDegree.ii, ChordDegree.v, ChordDegree.i, ChordDegree.vi],
        // Descending bass — IV–iii–ii–I
        [ChordDegree.iv, ChordDegree.iii, ChordDegree.ii, ChordDegree.i],
        // Minor lo-fi loop — i–VI–III–VII
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iii, ChordDegree.vii],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionBias: 0.35,
      tensionBlend: 0.55,
      rhythmDensity: 0.35,
      repetitionFactor: 0.7,
      extensionLevel: 0.85,
      variationBias: 0.45,
      descriptionTags: [
        'Warm and dusty — late-night jazz chords.',
        'Nostalgic and unhurried — study beats energy.',
        'Extended harmonies with a bedroom feel.',
        'Lo-fi 9th chord texture — rich but relaxed.',
        'Soft jazz movement over a slow groove.',
      ],
    ),

    // =========================================================================
    // ── HIP-HOP ───────────────────────────────────────────────────────────────
    // Soulful, rhythmic, minor-leaning — dark melodies over boom-bap.
    // Moderate extension for R&B crossover, high repetition for samples.
    // =========================================================================
    GenreType.hipHop: GenreProfile(
      preferredScales: [
        ScaleType.naturalMinor,
        ScaleType.melodicMinor,
        ScaleType.dorianMode,
      ],
      progressionPatterns: [
        // Classic sample loop — i–VI–III–VII
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iii, ChordDegree.vii],
        // Minor bounce — i–iv–VII–iv
        [ChordDegree.i, ChordDegree.iv, ChordDegree.vii, ChordDegree.iv],
        // Soulful movement — VI–IV–i–V
        [ChordDegree.vi, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
        // Mediant colour — i–III–VI–IV
        [ChordDegree.i, ChordDegree.iii, ChordDegree.vi, ChordDegree.iv],
        // Dark 5-chord arc — i–VI–IV–V–i
        [
          ChordDegree.i,
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.v,
          ChordDegree.i
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionBias: 0.5,
      tensionBlend: 0.45,
      rhythmDensity: 0.7,
      repetitionFactor: 0.8,
      extensionLevel: 0.55,
      variationBias: 0.4,
      descriptionTags: [
        'Soulful and rhythmic — boom-bap chord movement.',
        'Beat-driven minor harmony — made to loop.',
        'Dark but melodic — the sound of a crate-dig sample.',
        'Hip-hop minor colour — gritty and expressive.',
        'Sample-worthy loop — repeats without wearing out.',
      ],
    ),

    // =========================================================================
    // ── TRAP ──────────────────────────────────────────────────────────────────
    // Dark, minimal, high-tension — Phrygian/harmonic minor dominance.
    // Extremely high repetition; almost no extended harmony; raw triads.
    // =========================================================================
    GenreType.trap: GenreProfile(
      preferredScales: [
        ScaleType.harmonicMinor,
        ScaleType.phrygianMode,
        ScaleType.naturalMinor,
      ],
      progressionPatterns: [
        // Andalusian menace — i–VII–VI–V
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.v],
        // Phrygian stomp — i–II–V–i (bII in Phrygian)
        [ChordDegree.i, ChordDegree.ii, ChordDegree.v, ChordDegree.i],
        // Chromatic squeeze — i–VII–II–V
        [ChordDegree.i, ChordDegree.vii, ChordDegree.ii, ChordDegree.v],
        // Trap minimal loop — i–i–VI–V
        [ChordDegree.i, ChordDegree.i, ChordDegree.vi, ChordDegree.v],
        // Phrygian threat arc — VII–i–II–i
        [ChordDegree.vii, ChordDegree.i, ChordDegree.ii, ChordDegree.i],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionBias: 0.82,
      tensionBlend: 0.65,
      rhythmDensity: 0.75,
      repetitionFactor: 0.9,
      extensionLevel: 0.1,
      variationBias: 0.25,
      descriptionTags: [
        'Dark and sparse — trap flavoured dissonance.',
        'Menacing harmonic loops — built to intimidate.',
        'Phrygian menace — half-step threat on every bar.',
        'Minimal but heavy — raw tension, no decoration.',
        'Stripped down and relentless — the anatomy of a trap beat.',
      ],
    ),

    // =========================================================================
    // ── ROCK ──────────────────────────────────────────────────────────────────
    // Powerful, open, driving — major and Mixolydian bVII–IV swagger.
    // Moderate tension; guitar-voiced triads; mid-level repetition.
    // =========================================================================
    GenreType.rock: GenreProfile(
      preferredScales: [
        ScaleType.major,
        ScaleType.mixolydianMode,
        ScaleType.naturalMinor,
      ],
      progressionPatterns: [
        // Classic rock cadence — I–IV–V–I
        [ChordDegree.i, ChordDegree.iv, ChordDegree.v, ChordDegree.i],
        // Mixolydian swagger — I–bVII–IV–I
        [ChordDegree.i, ChordDegree.vii, ChordDegree.iv, ChordDegree.i],
        // Minor rock descend — i–VII–VI–V
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.v],
        // Power rock — I–V–IV–I
        [ChordDegree.i, ChordDegree.v, ChordDegree.iv, ChordDegree.i],
        // 5-chord rock anthem — i–III–VII–VI–IV
        [
          ChordDegree.i,
          ChordDegree.iii,
          ChordDegree.vii,
          ChordDegree.vi,
          ChordDegree.iv
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionBias: 0.55,
      tensionBlend: 0.4,
      rhythmDensity: 0.75,
      repetitionFactor: 0.65,
      extensionLevel: 0.1,
      variationBias: 0.45,
      descriptionTags: [
        'Power and drive — guitar-friendly chord movement.',
        'Open and anthemic — made for big rooms.',
        'Mixolydian swagger — the bVII makes everything heavier.',
        'Rock energy built on simple, powerful triads.',
        'Unresolved tension — rock never fully sits still.',
      ],
    ),

    // =========================================================================
    // ── JAZZ ──────────────────────────────────────────────────────────────────
    // Sophisticated, extended, harmonically adventurous — ii–V–I vocabulary
    // across all jazz-compatible scales. Maximum 9th-chord extension.
    // Low repetition; high variation; genre heavily shapes tension.
    // =========================================================================
    GenreType.jazz: GenreProfile(
      preferredScales: [
        ScaleType.major,
        ScaleType.naturalMinor,
        ScaleType.melodicMinor,
        ScaleType.dorianMode,
        ScaleType.lydianMode,
      ],
      progressionPatterns: [
        // ii–V–I–VI (the jazz turnaround)
        [ChordDegree.ii, ChordDegree.v, ChordDegree.i, ChordDegree.vi],
        // I–VI–II–V (rhythm changes skeleton)
        [ChordDegree.i, ChordDegree.vi, ChordDegree.ii, ChordDegree.v],
        // iii–VI–ii–V (Bird changes feel)
        [ChordDegree.iii, ChordDegree.vi, ChordDegree.ii, ChordDegree.v],
        // Descending jazz bass — IV–iii–ii–I
        [ChordDegree.iv, ChordDegree.iii, ChordDegree.ii, ChordDegree.i],
        // 6-chord jazz arc — I–IV–iii–VI–ii–V
        [
          ChordDegree.i,
          ChordDegree.iv,
          ChordDegree.iii,
          ChordDegree.vi,
          ChordDegree.ii,
          ChordDegree.v
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionBias: 0.72,
      tensionBlend: 0.72,
      rhythmDensity: 0.55,
      repetitionFactor: 0.35,
      extensionLevel: 0.95,
      variationBias: 0.65,
      descriptionTags: [
        'Sophisticated extended harmony — ii–V–I jazz vocabulary.',
        'Rich 9th-chord colour — jazz at its most expressive.',
        'Complex and improvisational — never the same twice.',
        'Jazz turnaround texture — forward motion through tension.',
        'Maximum harmonic depth — lush and adventurous.',
      ],
    ),

    // =========================================================================
    // ── R&B ───────────────────────────────────────────────────────────────────
    // Smooth, soulful, extended — neo-soul warmth with Dorian colour.
    // High extension (9ths + 7ths); moderate variation; flowing patterns.
    // =========================================================================
    GenreType.rnb: GenreProfile(
      preferredScales: [
        ScaleType.naturalMinor,
        ScaleType.dorianMode,
        ScaleType.major,
        ScaleType.melodicMinor,
      ],
      progressionPatterns: [
        // Soul staple — I–VI–IV–V
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iv, ChordDegree.v],
        // Jazz-R&B — ii–V–I–IV
        [ChordDegree.ii, ChordDegree.v, ChordDegree.i, ChordDegree.iv],
        // Minor R&B — i–VI–IV–V
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iv, ChordDegree.v],
        // Smooth movement — IV–I–V–VI
        [ChordDegree.iv, ChordDegree.i, ChordDegree.v, ChordDegree.vi],
        // Neo-soul 5-chord — i–III–VII–VI–IV
        [
          ChordDegree.i,
          ChordDegree.iii,
          ChordDegree.vii,
          ChordDegree.vi,
          ChordDegree.iv
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionBias: 0.45,
      tensionBlend: 0.52,
      rhythmDensity: 0.55,
      repetitionFactor: 0.62,
      extensionLevel: 0.78,
      variationBias: 0.5,
      descriptionTags: [
        'Smooth and soulful — R&B extended chord luxury.',
        'Neo-soul warmth — 9ths and 7ths draped over every chord.',
        'Flowing and lush — the sound of silky groove.',
        '9th-chord soul movement — modern and timeless.',
        'The kind of harmony that makes you close your eyes.',
      ],
    ),

    // =========================================================================
    // ── CINEMATIC ─────────────────────────────────────────────────────────────
    // Epic, evolving, emotional arcs — harmonic minor drama with Lydian
    // luminosity. Low repetition; 5–6 chord sweeps; earned resolution.
    // =========================================================================
    GenreType.cinematic: GenreProfile(
      preferredScales: [
        ScaleType.harmonicMinor,
        ScaleType.naturalMinor,
        ScaleType.major,
        ScaleType.melodicMinor,
        ScaleType.lydianMode,
      ],
      progressionPatterns: [
        // 5-chord cinematic resolution — i–VI–IV–V–i
        [
          ChordDegree.i,
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.v,
          ChordDegree.i
        ],
        // 6-chord operatic sweep — i–II–V–VI–IV–V
        [
          ChordDegree.i,
          ChordDegree.ii,
          ChordDegree.v,
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.v
        ],
        // Andalusian dramatic descent — i–VII–VI–V
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.v],
        // Epic resolution — VI–IV–V–I
        [ChordDegree.vi, ChordDegree.iv, ChordDegree.v, ChordDegree.i],
        // 6-chord wide arc — i–IV–VII–V–i–VI
        [
          ChordDegree.i,
          ChordDegree.iv,
          ChordDegree.vii,
          ChordDegree.v,
          ChordDegree.i,
          ChordDegree.vi
        ],
      ],
      patternWeights: [0.25, 0.2, 0.25, 0.15, 0.15],
      tensionBias: 0.72,
      tensionBlend: 0.52,
      rhythmDensity: 0.45,
      repetitionFactor: 0.28,
      extensionLevel: 0.3,
      variationBias: 0.42,
      descriptionTags: [
        'Sweeping cinematic arc — score-ready drama.',
        'Film-score tension and release — built for wide screens.',
        'Orchestral chord movement — epic and evolving.',
        'Breathtaking rises and falls — earned resolution.',
        'The sound of something that matters on screen.',
      ],
    ),

    // =========================================================================
    // ── AMBIENT ───────────────────────────────────────────────────────────────
    // Floating, atmospheric, minimal tension — Lydian and Dorian colour.
    // Very high repetition; minimal variation; genre strongly shapes tension.
    // =========================================================================
    GenreType.ambient: GenreProfile(
      preferredScales: [
        ScaleType.major,
        ScaleType.lydianMode,
        ScaleType.melodicMinor,
        ScaleType.dorianMode,
      ],
      progressionPatterns: [
        // Floating jazz loop — I–VI–II–V
        [ChordDegree.i, ChordDegree.vi, ChordDegree.ii, ChordDegree.v],
        // Minimal resolved loop — I–IV–I–V
        [ChordDegree.i, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
        // Warm plagal warmth — IV–I–VI–III
        [ChordDegree.iv, ChordDegree.i, ChordDegree.vi, ChordDegree.iii],
        // Sustained gentle loop — II–IV–I–I
        [ChordDegree.ii, ChordDegree.iv, ChordDegree.i, ChordDegree.i],
        // Minor ambient drift — i–VI–III–VII
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iii, ChordDegree.vii],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionBias: 0.08,
      tensionBlend: 0.65,
      rhythmDensity: 0.15,
      repetitionFactor: 0.88,
      extensionLevel: 0.65,
      variationBias: 0.18,
      descriptionTags: [
        'Floating and atmospheric — harmonic space to breathe.',
        'Textural and unresolved — chords as colour washes.',
        'Slow and meditative — time dissolves between changes.',
        'Wide open and weightless — ambient at its purest.',
        'Drift and wash — music without urgency.',
      ],
    ),

    // =========================================================================
    // ── HOUSE ─────────────────────────────────────────────────────────────────
    // Uplifting, groovy, functional — four-to-the-floor energy with soulful
    // Dorian and Mixolydian colour. High repetition; moderate extension.
    // =========================================================================
    GenreType.house: GenreProfile(
      preferredScales: [
        ScaleType.major,
        ScaleType.naturalMinor,
        ScaleType.dorianMode,
        ScaleType.mixolydianMode,
      ],
      progressionPatterns: [
        // Uplifting house — I–IV–V–I
        [ChordDegree.i, ChordDegree.iv, ChordDegree.v, ChordDegree.i],
        // Soulful minor loop — i–VI–III–VII
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iii, ChordDegree.vii],
        // Jazz-house — I–IV–ii–V
        [ChordDegree.i, ChordDegree.iv, ChordDegree.ii, ChordDegree.v],
        // Classic uplifting — IV–I–V–VI
        [ChordDegree.iv, ChordDegree.i, ChordDegree.v, ChordDegree.vi],
        // Mixolydian house — i–VII–IV–i
        [ChordDegree.i, ChordDegree.vii, ChordDegree.iv, ChordDegree.i],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionBias: 0.35,
      tensionBlend: 0.38,
      rhythmDensity: 0.82,
      repetitionFactor: 0.88,
      extensionLevel: 0.38,
      variationBias: 0.3,
      descriptionTags: [
        'Four-to-the-floor groove — uplifting dance harmony.',
        'Functional house loop — built to move bodies.',
        'Soulful and repetitive — club-ready chord sequence.',
        'Dorian warmth over a kick drum — house music soul.',
        'The harmonic engine of the dance floor.',
      ],
    ),

    // =========================================================================
    // ── TECHNO ────────────────────────────────────────────────────────────────
    // Dark, mechanical, relentlessly repetitive — Phrygian and harmonic
    // minor colour. Maximum repetition; zero extension; minimal variation.
    // =========================================================================
    GenreType.techno: GenreProfile(
      preferredScales: [
        ScaleType.naturalMinor,
        ScaleType.phrygianMode,
        ScaleType.harmonicMinor,
        ScaleType.diminishedScale,
      ],
      progressionPatterns: [
        // Industrial descent — i–VII–VI–V
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.v],
        // Phrygian machine — i–II–VII–i
        [ChordDegree.i, ChordDegree.ii, ChordDegree.vii, ChordDegree.i],
        // Minimal loop — i–IV–VII–i
        [ChordDegree.i, ChordDegree.iv, ChordDegree.vii, ChordDegree.i],
        // Dark oscillation — VII–i–VI–V
        [ChordDegree.vii, ChordDegree.i, ChordDegree.vi, ChordDegree.v],
        // Techno 5-chord arc — i–VII–i–VI–V
        [
          ChordDegree.i,
          ChordDegree.vii,
          ChordDegree.i,
          ChordDegree.vi,
          ChordDegree.v
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionBias: 0.72,
      tensionBlend: 0.58,
      rhythmDensity: 0.95,
      repetitionFactor: 0.95,
      extensionLevel: 0.05,
      variationBias: 0.15,
      descriptionTags: [
        'Dark and mechanical — stripped to its harmonic bones.',
        'Hypnotic repetition — the loop IS the composition.',
        'Industrial tension — relentless and cold.',
        'Minimal techno texture — nothing wasted, nothing softened.',
        'The harmonic pulse of the machine.',
      ],
    ),
  };
}
