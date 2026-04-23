/// Represents a single musical chord.
class Chord {
  const Chord({required this.name, required this.notes, this.quality = ''});

  /// e.g. "Am", "F", "Cmaj7"
  final String name;

  /// e.g. ["A", "C", "E"]
  final List<String> notes;

  /// e.g. "minor", "major", "dominant7"
  final String quality;

  @override
  String toString() => name;
}
