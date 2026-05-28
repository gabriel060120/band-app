import 'package:band_app/domain/models/chords/chordpro_line.dart';

/// Parses a ChordPro-formatted string into a list of [ChordProLine] objects.
class ChordProParser {
  static final _sectionRegex = RegExp(r'^\{section:\s*(.+?)\s*\}$', caseSensitive: false);
  static final _chordRegex = RegExp(r'\[([^\]]+)\]');

  /// Returns true if the [content] appears to be in ChordPro format.
  static bool isChordPro(String content) {
    return _sectionRegex.hasMatch(content) || _chordRegex.hasMatch(content);
  }

  /// Parses [content] and returns the list of structured lines.
  static List<ChordProLine> parse(String content) {
    final lines = content.split('\n');
    final result = <ChordProLine>[];

    for (final raw in lines) {
      final line = raw.trimRight();

      // Section directive: {section: Name}
      final sectionMatch = _sectionRegex.firstMatch(line);
      if (sectionMatch != null) {
        result.add(SectionLine(sectionMatch.group(1)!));
        continue;
      }

      // Ignore other directives (e.g. {title:}, {artist:})
      if (line.trimLeft().startsWith('{') && line.trimRight().endsWith('}')) {
        continue;
      }

      // Empty line
      if (line.trim().isEmpty) {
        result.add(EmptyLine());
        continue;
      }

      // Lyric line with optional inline chords [Chord]text
      result.add(_parseLyricLine(line));
    }

    return result;
  }

  static LyricLine _parseLyricLine(String line) {
    final tokens = <ChordToken>[];
    int cursor = 0;

    for (final match in _chordRegex.allMatches(line)) {
      // Text before this chord
      final textBefore = line.substring(cursor, match.start);
      if (tokens.isEmpty && textBefore.isNotEmpty) {
        // No preceding chord – plain text token
        tokens.add(ChordToken(text: textBefore));
      } else if (tokens.isNotEmpty) {
        // Append text to the last token's chord segment
        final last = tokens.removeLast();
        tokens.add(ChordToken(chord: last.chord, text: last.text + textBefore));
      } else {
        // chord right at start, no preceding text
      }

      // Start a new token for this chord (text will be filled by next iteration)
      tokens.add(ChordToken(chord: match.group(1)!, text: ''));
      cursor = match.end;
    }

    // Remaining text after the last chord
    if (cursor < line.length) {
      final remaining = line.substring(cursor);
      if (tokens.isNotEmpty) {
        final last = tokens.removeLast();
        tokens.add(ChordToken(chord: last.chord, text: last.text + remaining));
      } else {
        tokens.add(ChordToken(text: remaining));
      }
    }

    return LyricLine(tokens.isEmpty ? [ChordToken(text: line)] : tokens);
  }
}
