/// Represents a musical scale.
class Scale {
  const Scale({required this.name, required this.notes, this.type = ''});

  /// e.g. "A Minor", "C Major"
  final String name;

  /// Ordered list of notes in the scale
  final List<String> notes;

  /// e.g. "natural minor", "pentatonic"
  final String type;
}
