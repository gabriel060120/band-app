/// Represents a single token inside a lyric line: an optional chord and its
/// associated lyric text.
class ChordToken {
  final String? chord;
  final String text;

  const ChordToken({this.chord, required this.text});
}

/// Base class for a parsed ChordPro line.
sealed class ChordProLine {}

/// A `{section: Name}` directive.
class SectionLine extends ChordProLine {
  final String name;
  SectionLine(this.name);
}

/// A line with lyrics and/or inline chords.
class LyricLine extends ChordProLine {
  final List<ChordToken> tokens;
  LyricLine(this.tokens);

  bool get hasChords => tokens.any((t) => t.chord != null);
  bool get isEmpty => tokens.every((t) => t.text.trim().isEmpty && t.chord == null);

  /// True when the line contains only chord markers with no actual lyric text
  /// (e.g. `[Gm] [Am7] [C]` — a chord-diagram row).
  bool get isChordsOnly =>
      hasChords && tokens.every((t) => t.text.trim().isEmpty);
}

/// A blank line used for spacing.
class EmptyLine extends ChordProLine {}
