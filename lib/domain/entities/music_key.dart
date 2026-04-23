import 'package:flutter/foundation.dart';

/// Represents a musical key on the Circle of Fifths.
///
/// Every [MusicKey] knows its tonic note, whether it is major or minor,
/// its position in the circle (0 = C major / A minor, ascending clockwise),
/// its relative key, and its dominant/subdominant neighbours.
@immutable
class MusicKey {
  const MusicKey({
    required this.tonic,
    required this.isMajor,
    required this.position,
    required this.relativeKey,
    required this.dominantKey,
    required this.subdominantKey,
  });

  /// Root note name, e.g. "C", "G", "F#"
  final String tonic;

  /// True = major key, false = relative minor
  final bool isMajor;

  /// Position 0–11 clockwise from C major / A minor
  final int position;

  /// The relative minor (if major) or relative major (if minor)
  final String relativeKey;

  /// The key one step clockwise (dominant direction)
  final String dominantKey;

  /// The key one step counter-clockwise (subdominant direction)
  final String subdominantKey;

  /// Display label, e.g. "C major", "A minor"
  String get label => '$tonic ${isMajor ? 'major' : 'minor'}';

  /// Short label used on the circle node, e.g. "C" or "Am"
  String get shortLabel => isMajor ? tonic : '${tonic}m';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MusicKey && tonic == other.tonic && isMajor == other.isMajor);

  @override
  int get hashCode => Object.hash(tonic, isMajor);
}
