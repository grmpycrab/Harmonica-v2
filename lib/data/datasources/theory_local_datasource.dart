/// Local mock datasource for music theory lessons.
///
/// Replace with a real data source (JSON assets, Isar, etc.) when needed.
class TheoryLocalDatasource {
  const TheoryLocalDatasource();

  Future<List<Map<String, dynamic>>> getLessons() async {
    // Simulating async data fetch
    await Future.delayed(const Duration(milliseconds: 100));
    return lessons;
  }

  /// Exposed as a static getter so the home screen can access lessons
  /// synchronously without going through the async repository chain.
  static List<Map<String, dynamic>> get lessons => _lessons;

  static const List<Map<String, dynamic>> _lessons = [
    {
      'id': 'chords_101',
      'title': 'What is a Chord?',
      'category': 'Chords',
      'content':
          'A chord is three or more notes played simultaneously. The most basic is the triad: root, third, and fifth.',
      'examples': ['C Major: C - E - G', 'A Minor: A - C - E'],
    },
    {
      'id': 'scales_101',
      'title': 'Major vs Minor Scales',
      'category': 'Scales',
      'content':
          'Major scales sound bright and happy. Minor scales sound darker and more emotional. '
              'The difference lies in the 3rd, 6th, and 7th degrees.',
      'examples': [
        'C Major: C D E F G A B C',
        'A Natural Minor: A B C D E F G A',
      ],
    },
    {
      'id': 'progressions_101',
      'title': 'Chord Progressions',
      'category': 'Progressions',
      'content':
          'A chord progression is a sequence of chords. Roman numerals (I, IV, V, vi) describe chord '
              'relationships within a key regardless of what key you\'re in.',
      'examples': [
        'I - V - vi - IV (C - G - Am - F)',
        'ii - V - I (jazz standard)',
      ],
    },
    {
      'id': 'intervals_101',
      'title': 'Intervals',
      'category': 'Theory',
      'content':
          'An interval is the distance between two notes. Knowing intervals helps you build '
              'any chord from scratch.',
      'examples': [
        'Unison, Minor 2nd, Major 2nd, Minor 3rd...',
        'Perfect 5th = 7 semitones',
      ],
    },
    {
      'id': 'modes_101',
      'title': 'Introduction to Modes',
      'category': 'Advanced',
      'content':
          'Modes are scales derived from the major scale starting on different degrees. '
              'Dorian is used widely in jazz and funk. Phrygian has a dark, Spanish character.',
      'examples': ['Dorian: D E F G A B C D', 'Phrygian: E F G A B C D E'],
    },
  ];
}
