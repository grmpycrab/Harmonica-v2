import '../../domain/entities/chord_degree.dart';
import '../../domain/entities/emotion_profile.dart';
import '../../domain/entities/emotion_type.dart';
import '../../domain/entities/scale_type.dart';

/// Single source of truth that maps each [EmotionType] to its [EmotionProfile].
///
/// **Architecture principle**: patterns are written as scale degrees (I, IV, V…),
/// never as chord names. [ScaleMapper] resolves them at generation time.
/// This keeps all theory logic isolated in the service layer.
///
/// **Editing guide** (what to tune per emotion):
/// * `allowedScales` — which modal/scale colours are appropriate
/// * `preferredPatterns` — 4–6 chord degree sequences ordered by probability
/// * `patternWeights` — must sum to 1.0; higher weight = more frequent
/// * `tensionLevel` — 0.0 = pure triads; above 0.5 starts triggering 7ths
///   - tensionLevel = 0.55 → ~10 % chance of 7th chords per progression
///   - tensionLevel = 0.65 → ~30 % chance
///   - tensionLevel = 0.75 → ~50 % chance
///   - tensionLevel = 0.90 → ~80 % chance
/// * `variation` — 0.0 = identical output every run; higher = more substitutions
/// * `descriptions` — displayed to the user; one is chosen per generation
class EmotionCatalog {
  EmotionCatalog._();

  static EmotionProfile profileFor(EmotionType emotion) => _catalog[emotion]!;

  static const Map<EmotionType, EmotionProfile> _catalog = {
    // =========================================================================
    // ── ORIGINAL EIGHT ────────────────────────────────────────────────────────
    // =========================================================================

    // ── HAPPY ─────────────────────────────────────────────────────────────────
    EmotionType.happy: EmotionProfile(
      allowedScales: [ScaleType.major],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.v, ChordDegree.vi, ChordDegree.iv],
        [ChordDegree.i, ChordDegree.iv, ChordDegree.v, ChordDegree.i],
        [ChordDegree.i, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
        [ChordDegree.i, ChordDegree.ii, ChordDegree.iv, ChordDegree.v],
        [ChordDegree.iv, ChordDegree.i, ChordDegree.v, ChordDegree.i],
      ],
      patternWeights: [0.35, 0.25, 0.2, 0.12, 0.08],
      tensionLevel: 0.15,
      variation: 0.25,
      descriptions: [
        'Bright and uplifting — perfect for feel-good tracks.',
        'Warm, sunny vibes with a pop bounce.',
        'Carefree energy — made for smiles and good moments.',
        'Light-hearted and free — the sound of an uncomplicated day.',
        'Simple joy, no complications — just good chords and good vibes.',
      ],
    ),

    // ── SAD ───────────────────────────────────────────────────────────────────
    EmotionType.sad: EmotionProfile(
      allowedScales: [ScaleType.naturalMinor],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.iii],
        [ChordDegree.vi, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
        [ChordDegree.i, ChordDegree.iv, ChordDegree.vii, ChordDegree.iii],
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iii, ChordDegree.vii],
        [
          ChordDegree.iii,
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.i,
          ChordDegree.vii,
          ChordDegree.v
        ],
      ],
      patternWeights: [0.35, 0.25, 0.18, 0.12, 0.1],
      tensionLevel: 0.3,
      variation: 0.3,
      descriptions: [
        'Tender and aching — great for emotional ballads.',
        'Quiet longing, like looking back on memories.',
        'A soft ache in the chest — beauty in sorrow.',
        'Melting sadness, honest and unadorned.',
        'The minor key that says everything words cannot.',
      ],
    ),

    // ── DARK ──────────────────────────────────────────────────────────────────
    EmotionType.dark: EmotionProfile(
      allowedScales: [ScaleType.harmonicMinor, ScaleType.phrygianMode],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.v],
        [ChordDegree.i, ChordDegree.ii, ChordDegree.v, ChordDegree.i],
        [ChordDegree.i, ChordDegree.iv, ChordDegree.vii, ChordDegree.v],
        [ChordDegree.i, ChordDegree.ii, ChordDegree.vi, ChordDegree.v],
        [
          ChordDegree.i,
          ChordDegree.vii,
          ChordDegree.ii,
          ChordDegree.v,
          ChordDegree.i,
          ChordDegree.vi
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.8,
      variation: 0.35,
      descriptions: [
        'Heavy and brooding — sets a cinematic tension.',
        'Shadowy and intense — ideal for dark trap or film scores.',
        'Cold and unsettling — the kind of dark that grips you.',
        'Phrygian darkness — half-step threat that never resolves.',
        'Diminished edges everywhere — nothing feels safe.',
      ],
    ),

    // ── HOPEFUL ───────────────────────────────────────────────────────────────
    EmotionType.hopeful: EmotionProfile(
      allowedScales: [ScaleType.major],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iv, ChordDegree.v],
        [ChordDegree.i, ChordDegree.iii, ChordDegree.iv, ChordDegree.v],
        [ChordDegree.vi, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
        [
          ChordDegree.i,
          ChordDegree.v,
          ChordDegree.vi,
          ChordDegree.iii,
          ChordDegree.iv,
          ChordDegree.v
        ],
        [ChordDegree.ii, ChordDegree.iv, ChordDegree.v, ChordDegree.i],
      ],
      patternWeights: [0.35, 0.25, 0.2, 0.12, 0.08],
      tensionLevel: 0.2,
      variation: 0.25,
      descriptions: [
        'Reaching upward — a sense of possibility and light.',
        'Gentle optimism, like dawn after a long night.',
        'The feeling that things will be okay — warmth ahead.',
        'Forward motion with a hint of longing — hope in motion.',
        'Open and expansive — a horizon you believe in.',
      ],
    ),

    // ── ENERGETIC ─────────────────────────────────────────────────────────────
    EmotionType.energetic: EmotionProfile(
      allowedScales: [ScaleType.major, ScaleType.mixolydianMode],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.iv, ChordDegree.v, ChordDegree.iv],
        [ChordDegree.v, ChordDegree.iv, ChordDegree.i, ChordDegree.i],
        [ChordDegree.i, ChordDegree.ii, ChordDegree.iv, ChordDegree.v],
        [ChordDegree.i, ChordDegree.vii, ChordDegree.iv, ChordDegree.i],
        [
          ChordDegree.i,
          ChordDegree.iv,
          ChordDegree.vii,
          ChordDegree.v,
          ChordDegree.i
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.5,
      variation: 0.4,
      descriptions: [
        'Driving and powerful — push the energy forward.',
        'High-octane momentum, built for peak moments.',
        'Pure fuel — built for arenas and adrenaline.',
        'Locked-in groove — unstoppable forward motion.',
        'Maximum energy, no brakes — full-throttle harmonic drive.',
      ],
    ),

    // ── CALM ──────────────────────────────────────────────────────────────────
    EmotionType.calm: EmotionProfile(
      allowedScales: [ScaleType.major, ScaleType.naturalMinor],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.vi, ChordDegree.ii, ChordDegree.v],
        [ChordDegree.i, ChordDegree.iii, ChordDegree.vi, ChordDegree.iv],
        [ChordDegree.iv, ChordDegree.i, ChordDegree.v, ChordDegree.vi],
        [ChordDegree.i, ChordDegree.iv, ChordDegree.iii, ChordDegree.vi],
        [ChordDegree.ii, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
      ],
      patternWeights: [0.35, 0.25, 0.2, 0.12, 0.08],
      tensionLevel: 0.1,
      variation: 0.2,
      descriptions: [
        'Smooth and unhurried — music that breathes.',
        'Like a still lake at golden hour — peaceful warmth.',
        'Effortless and floating — the sound of letting go.',
        'Unhurried chord movement — space between every note.',
        'Quiet resolution — everything where it should be.',
      ],
    ),

    // ── NOSTALGIC ─────────────────────────────────────────────────────────────
    EmotionType.nostalgic: EmotionProfile(
      allowedScales: [ScaleType.naturalMinor, ScaleType.major],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iii, ChordDegree.vii],
        [ChordDegree.vi, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
        [ChordDegree.i, ChordDegree.iii, ChordDegree.vi, ChordDegree.vii],
        [
          ChordDegree.i,
          ChordDegree.v,
          ChordDegree.vi,
          ChordDegree.iii,
          ChordDegree.iv
        ],
        [
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.iii,
          ChordDegree.vii,
          ChordDegree.i
        ],
      ],
      patternWeights: [0.35, 0.25, 0.18, 0.12, 0.1],
      tensionLevel: 0.3,
      variation: 0.3,
      descriptions: [
        'Wistful and bittersweet — memories you can almost touch.',
        'Like flipping through old photographs with a smile and a sigh.',
        'The warmth of the past, filtered through the ache of time.',
        'Familiar chords that feel like somewhere you used to belong.',
        'A sound that makes you want to go back somewhere you cannot.',
      ],
    ),

    // ── TENSE ─────────────────────────────────────────────────────────────────
    EmotionType.tense: EmotionProfile(
      allowedScales: [ScaleType.harmonicMinor],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.ii, ChordDegree.v, ChordDegree.i],
        [ChordDegree.i, ChordDegree.vii, ChordDegree.v, ChordDegree.i],
        [ChordDegree.ii, ChordDegree.v, ChordDegree.i, ChordDegree.vi],
        [
          ChordDegree.i,
          ChordDegree.iv,
          ChordDegree.vii,
          ChordDegree.ii,
          ChordDegree.v
        ],
        [
          ChordDegree.vii,
          ChordDegree.ii,
          ChordDegree.v,
          ChordDegree.i,
          ChordDegree.vii
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.9,
      variation: 0.2,
      descriptions: [
        'On edge and unresolved — suspense you can feel in your chest.',
        'Like a held breath — the moment before everything breaks.',
        'Unstable and gripping — perfect for climactic moments.',
        'A coiled spring — tension that refuses to release.',
        'Every chord a step further from safety.',
      ],
    ),

    // =========================================================================
    // ── EXTENDED PALETTE ─────────────────────────────────────────────────────
    // =========================================================================

    // ── ROMANTIC ──────────────────────────────────────────────────────────────
    //   Lydian or Major — lush extended harmonies, IV–vi centred,
    //   tensionLevel 0.65 triggers maj7 / min7 colours ~30% of the time
    EmotionType.romantic: EmotionProfile(
      allowedScales: [ScaleType.lydianMode, ScaleType.major],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.iii, ChordDegree.vi, ChordDegree.iv],
        [
          ChordDegree.i,
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.v,
          ChordDegree.i
        ],
        [ChordDegree.iv, ChordDegree.i, ChordDegree.v, ChordDegree.vi],
        [ChordDegree.i, ChordDegree.ii, ChordDegree.vi, ChordDegree.iv],
        [
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.i,
          ChordDegree.iii,
          ChordDegree.vi,
          ChordDegree.iv
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.65,
      variation: 0.2,
      descriptions: [
        'Lush and tender — chords that feel like a warm embrace.',
        'Bittersweet longing, intimate and shimmering.',
        'Golden-hour romance — soft light, suspended moments.',
        'Like a slow dance — close and quietly electric.',
        'Floaty and warm, wrapped in harmonic colour.',
      ],
    ),

    // ── ANGRY ─────────────────────────────────────────────────────────────────
    //   Phrygian or Harmonic Minor — dissonant, aggressive, unrelenting
    EmotionType.angry: EmotionProfile(
      allowedScales: [ScaleType.phrygianMode, ScaleType.harmonicMinor],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.ii, ChordDegree.i, ChordDegree.v],
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.v],
        [ChordDegree.i, ChordDegree.ii, ChordDegree.vii, ChordDegree.i],
        [ChordDegree.v, ChordDegree.i, ChordDegree.ii, ChordDegree.i],
        [
          ChordDegree.i,
          ChordDegree.iv,
          ChordDegree.vii,
          ChordDegree.ii,
          ChordDegree.v
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.85,
      variation: 0.5,
      descriptions: [
        'Raw and confrontational — compressed fury in chord form.',
        'Aggressive and unrelenting — stomping Phrygian energy.',
        'A wall of sound — hostile harmonics and sharp edges.',
        'The musical equivalent of clenched fists.',
        'Explosive and volatile — no resolution, only pressure.',
      ],
    ),

    // ── MYSTERIOUS ────────────────────────────────────────────────────────────
    //   Dorian, Diminished, or Phrygian — ambiguous, chromatic, hovering
    EmotionType.mysterious: EmotionProfile(
      allowedScales: [
        ScaleType.dorianMode,
        ScaleType.diminishedScale,
        ScaleType.phrygianMode,
      ],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.iv, ChordDegree.vii, ChordDegree.i],
        [ChordDegree.i, ChordDegree.ii, ChordDegree.v, ChordDegree.vi],
        [ChordDegree.vi, ChordDegree.i, ChordDegree.ii, ChordDegree.iv],
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.v],
        [ChordDegree.ii, ChordDegree.iv, ChordDegree.i, ChordDegree.vi],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.6,
      variation: 0.5,
      descriptions: [
        'Shadowy and elusive — chords that ask questions without answers.',
        'Hovering between dark and light — modal ambiguity.',
        'A soundtrack to hidden rooms and unspoken secrets.',
        'Atmospheric and cryptic — suspense without resolution.',
        'Like fog at midnight — shapes you almost recognise.',
      ],
    ),

    // ── EUPHORIC ──────────────────────────────────────────────────────────────
    //   Lydian or Major — soaring, luminous, elated
    EmotionType.euphoric: EmotionProfile(
      allowedScales: [ScaleType.lydianMode, ScaleType.major],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.v, ChordDegree.ii, ChordDegree.iv],
        [ChordDegree.i, ChordDegree.iv, ChordDegree.v, ChordDegree.i],
        [ChordDegree.ii, ChordDegree.v, ChordDegree.i, ChordDegree.iv],
        [ChordDegree.i, ChordDegree.iii, ChordDegree.v, ChordDegree.iv],
        [
          ChordDegree.iv,
          ChordDegree.i,
          ChordDegree.ii,
          ChordDegree.v,
          ChordDegree.i
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.4,
      variation: 0.3,
      descriptions: [
        'Soaring and luminous — the sound of pure joy.',
        'Peak-moment energy — arms wide open.',
        'Elation without limits — chords that lift like wings.',
        'The musical equivalent of golden sunlight flooding in.',
        'Transcendent and free — floating above everything.',
      ],
    ),

    // ── MELANCHOLIC ───────────────────────────────────────────────────────────
    //   Natural Minor or Melodic Minor — deep, introspective sadness
    EmotionType.melancholic: EmotionProfile(
      allowedScales: [ScaleType.naturalMinor, ScaleType.melodicMinor],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iii, ChordDegree.vii],
        [ChordDegree.i, ChordDegree.iv, ChordDegree.vii, ChordDegree.iii],
        [ChordDegree.vi, ChordDegree.i, ChordDegree.v, ChordDegree.iv],
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.vii],
        [
          ChordDegree.iii,
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.i,
          ChordDegree.vii,
          ChordDegree.v
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.35,
      variation: 0.3,
      descriptions: [
        'Deep and introspective — sorrow that asks to be felt fully.',
        'A slow ache — beauty carved by loss.',
        'Quiet devastation, like rain against a window.',
        'Heavy with feeling — melancholy that does not rush to resolve.',
        'The weight of something beautiful that has passed.',
      ],
    ),

    // ── ANXIOUS ───────────────────────────────────────────────────────────────
    //   Phrygian or Harmonic Minor — restless, circling, never resolved
    EmotionType.anxious: EmotionProfile(
      allowedScales: [ScaleType.phrygianMode, ScaleType.harmonicMinor],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.ii, ChordDegree.i, ChordDegree.v],
        [ChordDegree.v, ChordDegree.i, ChordDegree.vii, ChordDegree.ii],
        [ChordDegree.i, ChordDegree.vii, ChordDegree.ii, ChordDegree.v],
        [ChordDegree.ii, ChordDegree.vii, ChordDegree.i, ChordDegree.v],
        [
          ChordDegree.i,
          ChordDegree.ii,
          ChordDegree.iv,
          ChordDegree.vii,
          ChordDegree.v
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.78,
      variation: 0.55,
      descriptions: [
        'Restless and unsettled — never quite landing anywhere safe.',
        'Coiled tension — the harmonic equivalent of racing thoughts.',
        'Jittery and unresolved, always reaching, never arriving.',
        'Like a loop you cannot break out of — circular and claustrophobic.',
        'Prickly and unstable — chords that refuse to settle.',
      ],
    ),

    // ── TRIUMPHANT ────────────────────────────────────────────────────────────
    //   Major, Lydian, or Mixolydian — heroic, large-scale, earned resolution
    EmotionType.triumphant: EmotionProfile(
      allowedScales: [
        ScaleType.major,
        ScaleType.lydianMode,
        ScaleType.mixolydianMode,
      ],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.iv, ChordDegree.v, ChordDegree.i],
        [ChordDegree.i, ChordDegree.v, ChordDegree.vi, ChordDegree.iv],
        [ChordDegree.iv, ChordDegree.v, ChordDegree.i, ChordDegree.vi],
        [
          ChordDegree.i,
          ChordDegree.iii,
          ChordDegree.iv,
          ChordDegree.v,
          ChordDegree.i
        ],
        [
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.i,
          ChordDegree.v,
          ChordDegree.i,
          ChordDegree.iv
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.45,
      variation: 0.2,
      descriptions: [
        'Grand and resolved — the sound of victory earned.',
        'Heroic and luminous — chords that fill a concert hall.',
        'Cinematic triumph — orchestral weight with forward momentum.',
        'The culmination of struggle — powerful and earned resolution.',
        'Like a final chord in a film score that says: we made it.',
      ],
    ),

    // ── DREAMY ────────────────────────────────────────────────────────────────
    //   Lydian or Melodic Minor — suspended, floaty, gauzy, hypnotic
    EmotionType.dreamy: EmotionProfile(
      allowedScales: [ScaleType.lydianMode, ScaleType.melodicMinor],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.ii, ChordDegree.v, ChordDegree.iv],
        [ChordDegree.iv, ChordDegree.i, ChordDegree.vi, ChordDegree.iii],
        [ChordDegree.i, ChordDegree.iii, ChordDegree.ii, ChordDegree.iv],
        [ChordDegree.vi, ChordDegree.iv, ChordDegree.ii, ChordDegree.i],
        [
          ChordDegree.i,
          ChordDegree.vi,
          ChordDegree.ii,
          ChordDegree.iv,
          ChordDegree.i,
          ChordDegree.v
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.6,
      variation: 0.3,
      descriptions: [
        'Floating and weightless — time feels suspended.',
        'Soft-focus harmonics — like dreaming in colour.',
        'Gauzy and luminous — chords that drift like clouds.',
        'Hypnotic and hazy — a loop you never want to leave.',
        'Half-awake and glowing — the sound between sleep and waking.',
      ],
    ),

    // ── LONELY ────────────────────────────────────────────────────────────────
    //   Natural Minor or Dorian — sparse, withdrawn, introspective
    EmotionType.lonely: EmotionProfile(
      allowedScales: [ScaleType.naturalMinor, ScaleType.dorianMode],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iii, ChordDegree.vii],
        [ChordDegree.i, ChordDegree.v, ChordDegree.vi, ChordDegree.iv],
        [ChordDegree.vi, ChordDegree.i, ChordDegree.iv, ChordDegree.vii],
        [ChordDegree.i, ChordDegree.iii, ChordDegree.vii, ChordDegree.vi],
        [
          ChordDegree.i,
          ChordDegree.vii,
          ChordDegree.vi,
          ChordDegree.v,
          ChordDegree.iv
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.25,
      variation: 0.2,
      descriptions: [
        'Empty and distant — chords that echo in a quiet room.',
        'The sound of being the only one awake at 3am.',
        'Sparse and aching — the space between the notes says everything.',
        'Like walking in an empty city — present but alone.',
        'Quiet withdrawal — music for solitude and stillness.',
      ],
    ),

    // ── PLAYFUL ───────────────────────────────────────────────────────────────
    //   Major or Mixolydian — light, bouncy, unexpected twists, high variation
    EmotionType.playful: EmotionProfile(
      allowedScales: [ScaleType.major, ScaleType.mixolydianMode],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.iv, ChordDegree.ii, ChordDegree.v],
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iv, ChordDegree.v],
        [ChordDegree.i, ChordDegree.vii, ChordDegree.iv, ChordDegree.i],
        [ChordDegree.iv, ChordDegree.v, ChordDegree.i, ChordDegree.ii],
        [
          ChordDegree.i,
          ChordDegree.iv,
          ChordDegree.v,
          ChordDegree.vii,
          ChordDegree.iv
        ],
      ],
      patternWeights: [0.3, 0.25, 0.2, 0.15, 0.1],
      tensionLevel: 0.25,
      variation: 0.5,
      descriptions: [
        'Light and bouncy — music that makes you want to skip.',
        'Mischievous and fun — unexpected twists that make you smile.',
        'Upbeat and carefree — the sound of a good mood.',
        'Skippy and bright — pop energy with a wink.',
        'Childlike wonder mixed with musical cleverness.',
      ],
    ),

    // ── SERENE ────────────────────────────────────────────────────────────────
    //   Major or Lydian — completely resolved, peaceful, minimal tension
    EmotionType.serene: EmotionProfile(
      allowedScales: [ScaleType.major, ScaleType.lydianMode],
      preferredPatterns: [
        [ChordDegree.i, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
        [ChordDegree.iv, ChordDegree.i, ChordDegree.vi, ChordDegree.iii],
        [ChordDegree.i, ChordDegree.vi, ChordDegree.ii, ChordDegree.v],
        [ChordDegree.ii, ChordDegree.iv, ChordDegree.i, ChordDegree.i],
        [
          ChordDegree.i,
          ChordDegree.iii,
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.i
        ],
      ],
      patternWeights: [0.35, 0.25, 0.2, 0.1, 0.1],
      tensionLevel: 0.08,
      variation: 0.15,
      descriptions: [
        'Still and resolved — pure harmonic peace.',
        'Like deep breathing set to chords — unhurried and open.',
        'The sound of early morning before the world wakes up.',
        'Complete and gentle — nothing needs to change.',
        'Music that holds you without asking anything of you.',
      ],
    ),

    // ── DRAMATIC ──────────────────────────────────────────────────────────────
    //   Harmonic Minor, Major, or Natural Minor — cinematic arcs,
    //   5–6 chord progressions, earned resolution after significant tension
    EmotionType.dramatic: EmotionProfile(
      allowedScales: [
        ScaleType.harmonicMinor,
        ScaleType.major,
        ScaleType.naturalMinor,
      ],
      preferredPatterns: [
        [
          ChordDegree.i,
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.v,
          ChordDegree.i
        ],
        [
          ChordDegree.i,
          ChordDegree.ii,
          ChordDegree.v,
          ChordDegree.vi,
          ChordDegree.iv,
          ChordDegree.v
        ],
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.v],
        [ChordDegree.vi, ChordDegree.iv, ChordDegree.v, ChordDegree.i],
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
      tensionLevel: 0.7,
      variation: 0.4,
      descriptions: [
        'Cinematic and sweeping — score-ready drama.',
        'Operatic scale — rises to peaks and crashes to depths.',
        'Breathtaking tension with earned resolution.',
        'Built for wide-screen moments and pivotal scenes.',
        'Orchestral weight — the sound of something that matters.',
      ],
    ),
  };
}
