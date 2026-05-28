/// Utility to transpose guitar chord names by a given number of semitones.
class ChordTransposer {
  // Prefer sharps when going up, flats when going down
  static const _sharps = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  static const _flats  = ['C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B'];

  static final _rootRegex = RegExp(r'^([A-G][#b]?)(.*)$');

  /// Transposes an individual chord name by [semitones] (can be negative).
  static String transposeChord(String chord, int semitones) {
    if (semitones == 0) return chord;

    final match = _rootRegex.firstMatch(chord);
    if (match == null) return chord;

    final root = match.group(1)!;
    final suffix = match.group(2)!;

    // Find root index
    int index = _sharps.indexOf(root);
    if (index == -1) index = _flats.indexOf(root);
    if (index == -1) return chord;

    final newIndex = ((index + semitones) % 12 + 12) % 12;
    final useFlats = semitones < 0 || root.contains('b');
    final newRoot = useFlats ? _flats[newIndex] : _sharps[newIndex];
    return '$newRoot$suffix';
  }

  /// Transposes all chords embedded in a ChordPro line (e.g. `[Am]text [G]more`).
  static String transposeChordProLine(String line, int semitones) {
    if (semitones == 0) return line;
    return line.replaceAllMapped(
      RegExp(r'\[([^\]]+)\]'),
      (m) => '[${transposeChord(m.group(1)!, semitones)}]',
    );
  }
}
