import '../../domain/entities/chord_degree.dart';
import '../../domain/entities/emotion_profile.dart';
import '../../domain/entities/emotion_type.dart';
import '../../domain/entities/scale_type.dart';

/// Single source of truth that maps each [EmotionType] to its [EmotionProfile].
///
/// This is the only file you need to edit to:
///   - Tune which chord patterns appear for a given emotion
///   - Adjust tension and variation levels
///   - Add or remove progression templates
///
/// Design principle: patterns are written as scale degrees (I, IV, V…),
/// not as chord names. [ScaleMapper] resolves them to actual chords.
class EmotionCatalog {
  EmotionCatalog._();

  static EmotionProfile profileFor(EmotionType emotion) => _catalog[emotion]!;

  static const Map<EmotionType, EmotionProfile> _catalog = {
    // -------------------------------------------------------------------------
    // HAPPY — C Major, low tension, pop-friendly patterns
    // -------------------------------------------------------------------------
    EmotionType.happy: EmotionProfile(
      allowedScales: [ScaleType.major],
      preferredPatterns: [
        // I–V–vi–IV  →  C – G – Am – F  (the "4-chord song")
        [ChordDegree.i, ChordDegree.v, ChordDegree.vi, ChordDegree.iv],
        // I–IV–V–I  →  C – F – G – C  (classic cadence)
        [ChordDegree.i, ChordDegree.iv, ChordDegree.v, ChordDegree.i],
        // I–IV–I–V  →  C – F – C – G  (upbeat shuffle feel)
        [ChordDegree.i, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
      ],
      patternWeights: [0.5, 0.3, 0.2],
      tensionLevel: 0.15,
      variation: 0.25,
      descriptions: [
        'Bright and uplifting — perfect for feel-good tracks.',
        'Warm, sunny vibes with a pop bounce.',
        'Carefree energy — made for smiles and good moments.',
      ],
    ),

    // -------------------------------------------------------------------------
    // SAD — A Natural Minor, moderate tension, descending emotional patterns
    // -------------------------------------------------------------------------
    EmotionType.sad: EmotionProfile(
      allowedScales: [ScaleType.naturalMinor],
      preferredPatterns: [
        // I–VII–VI–III  →  Am – G – F – C  (descending emotional arc)
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.iii],
        // VI–IV–I–V  →  F – Dm – Am – Em  (modal sadness)
        [ChordDegree.vi, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
        // I–IV–VII–III  →  Am – Dm – G – C  (natural minor resolution)
        [ChordDegree.i, ChordDegree.iv, ChordDegree.vii, ChordDegree.iii],
      ],
      patternWeights: [0.45, 0.35, 0.2],
      tensionLevel: 0.3,
      variation: 0.3,
      descriptions: [
        'Tender and aching — great for emotional ballads.',
        'Quiet longing, like looking back on memories.',
        'A soft ache in the chest — beauty in sorrow.',
      ],
    ),

    // -------------------------------------------------------------------------
    // DARK — A Harmonic Minor, high tension, diminished and leading-tone chords
    // -------------------------------------------------------------------------
    EmotionType.dark: EmotionProfile(
      allowedScales: [ScaleType.harmonicMinor],
      preferredPatterns: [
        // I–VII–VI–V  →  Am – G#dim – F – E  (Andalusian-style descent)
        [ChordDegree.i, ChordDegree.vii, ChordDegree.vi, ChordDegree.v],
        // I–II–V–I  →  Am – Bdim – E – Am  (minor ii–V–i resolution)
        [ChordDegree.i, ChordDegree.ii, ChordDegree.v, ChordDegree.i],
        // I–IV–VII–V  →  Am – Dm – G#dim – E  (maximum tension/dissonance)
        [ChordDegree.i, ChordDegree.iv, ChordDegree.vii, ChordDegree.v],
      ],
      patternWeights: [0.4, 0.35, 0.25],
      tensionLevel: 0.8,
      variation: 0.35,
      descriptions: [
        'Heavy and brooding — sets a cinematic tension.',
        'Shadowy and intense — ideal for dark trap or film scores.',
        'Cold and unsettling — the kind of dark that grips you.',
      ],
    ),

    // -------------------------------------------------------------------------
    // HOPEFUL — C Major, slight longing via VI, low tension
    // -------------------------------------------------------------------------
    EmotionType.hopeful: EmotionProfile(
      allowedScales: [ScaleType.major],
      preferredPatterns: [
        // I–VI–IV–V  →  C – Am – F – G  (the "longing but optimistic" pattern)
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iv, ChordDegree.v],
        // I–III–IV–V  →  C – Em – F – G  (mediant adds colour)
        [ChordDegree.i, ChordDegree.iii, ChordDegree.iv, ChordDegree.v],
        // VI–IV–I–V  →  Am – F – C – G  (axis progression, starts reflective)
        [ChordDegree.vi, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
      ],
      patternWeights: [0.45, 0.3, 0.25],
      tensionLevel: 0.2,
      variation: 0.25,
      descriptions: [
        'Reaching upward — a sense of possibility and light.',
        'Gentle optimism, like dawn after a long night.',
        'The feeling that things will be okay — warmth ahead.',
      ],
    ),

    // -------------------------------------------------------------------------
    // ENERGETIC — C Major, moderate tension, driving rock/pop patterns
    // -------------------------------------------------------------------------
    EmotionType.energetic: EmotionProfile(
      allowedScales: [ScaleType.major],
      preferredPatterns: [
        // I–IV–V–IV  →  C – F – G – F  (driving loop)
        [ChordDegree.i, ChordDegree.iv, ChordDegree.v, ChordDegree.iv],
        // V–IV–I–I  →  G – F – C – C  (power chord rock feel)
        [ChordDegree.v, ChordDegree.iv, ChordDegree.i, ChordDegree.i],
        // I–II–IV–V  →  C – Dm – F – G  (building tension)
        [ChordDegree.i, ChordDegree.ii, ChordDegree.iv, ChordDegree.v],
      ],
      patternWeights: [0.4, 0.35, 0.25],
      tensionLevel: 0.5,
      variation: 0.4,
      descriptions: [
        'Driving and powerful — push the energy forward.',
        'High-octane momentum, built for peak moments.',
        'Pure fuel — built for arenas and adrenaline.',
      ],
    ),

    // -------------------------------------------------------------------------
    // CALM — Major or Natural Minor, very low tension, jazz-influenced
    // -------------------------------------------------------------------------
    EmotionType.calm: EmotionProfile(
      allowedScales: [ScaleType.major, ScaleType.naturalMinor],
      preferredPatterns: [
        // I–VI–II–V  →  C – Am – Dm – G  (I–vi–ii–V jazz loop)
        [ChordDegree.i, ChordDegree.vi, ChordDegree.ii, ChordDegree.v],
        // I–III–VI–IV  →  C – Em – Am – F  (smooth mediant movement)
        [ChordDegree.i, ChordDegree.iii, ChordDegree.vi, ChordDegree.iv],
        // IV–I–V–VI  →  F – C – G – Am  (plagal opening, unhurried)
        [ChordDegree.iv, ChordDegree.i, ChordDegree.v, ChordDegree.vi],
      ],
      patternWeights: [0.4, 0.35, 0.25],
      tensionLevel: 0.1,
      variation: 0.2,
      descriptions: [
        'Smooth and unhurried — music that breathes.',
        'Like a still lake at golden hour — peaceful warmth.',
        'Effortless and floating — the sound of letting go.',
      ],
    ),

    // -------------------------------------------------------------------------
    // NOSTALGIC — Natural Minor or Major, wistful patterns, medium variation
    // -------------------------------------------------------------------------
    EmotionType.nostalgic: EmotionProfile(
      allowedScales: [ScaleType.naturalMinor, ScaleType.major],
      preferredPatterns: [
        // I–VI–III–VII  →  Am – F – C – G  (axis progression — universally nostalgic)
        [ChordDegree.i, ChordDegree.vi, ChordDegree.iii, ChordDegree.vii],
        // VI–IV–I–V  →  F – Dm – Am – Em  (bittersweet minor feel)
        [ChordDegree.vi, ChordDegree.iv, ChordDegree.i, ChordDegree.v],
        // I–III–VI–VII  →  Am – C – F – G  (wistful rising movement)
        [ChordDegree.i, ChordDegree.iii, ChordDegree.vi, ChordDegree.vii],
      ],
      patternWeights: [0.45, 0.35, 0.2],
      tensionLevel: 0.3,
      variation: 0.3,
      descriptions: [
        'Wistful and bittersweet — memories you can almost touch.',
        'Like flipping through old photographs with a smile and a sigh.',
        'The warmth of the past, filtered through the ache of time.',
      ],
    ),

    // -------------------------------------------------------------------------
    // TENSE — A Harmonic Minor, maximum tension, unresolved dissonance
    // -------------------------------------------------------------------------
    EmotionType.tense: EmotionProfile(
      allowedScales: [ScaleType.harmonicMinor],
      preferredPatterns: [
        // I–II–V–I  →  Am – Bdim – E – Am  (minor ii°–V–i, very unstable)
        [ChordDegree.i, ChordDegree.ii, ChordDegree.v, ChordDegree.i],
        // I–VII–V–I  →  Am – G#dim – E – Am  (leading-tone squeeze)
        [ChordDegree.i, ChordDegree.vii, ChordDegree.v, ChordDegree.i],
        // II–V–I–VI  →  Bdim – E – Am – F  (unresolved landing on VI)
        [ChordDegree.ii, ChordDegree.v, ChordDegree.i, ChordDegree.vi],
      ],
      patternWeights: [0.4, 0.35, 0.25],
      tensionLevel: 0.9,
      variation: 0.2,
      descriptions: [
        'On edge and unresolved — suspense you can feel in your chest.',
        'Like a held breath — the moment before everything breaks.',
        'Unstable and gripping — perfect for climactic moments.',
      ],
    ),
  };
}
