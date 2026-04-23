/// Roman-numeral scale degrees used to describe chord positions abstractly.
///
/// Using degree notation (I, IV, V) keeps progression patterns
/// key-agnostic — the [ScaleMapper] resolves them to actual chords.
enum ChordDegree {
  i,
  ii,
  iii,
  iv,
  v,
  vi,
  vii;

  /// Returns the uppercase Roman numeral display string, e.g. `ChordDegree.vii` → `"VII"`.
  String get roman => name.toUpperCase();
}
