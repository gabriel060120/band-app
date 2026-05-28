import 'package:band_app/domain/models/chords/chordpro_line.dart';
import 'package:band_app/utils/chord_transposer.dart';
import 'package:band_app/utils/chordpro_parser.dart';
import 'package:flutter/material.dart';

/// Renders a ChordPro-formatted [content] string with chords displayed above
/// the corresponding lyric text. Supports transposition via [transpose].
class ChordProRenderWidget extends StatelessWidget {
  const ChordProRenderWidget({
    super.key,
    required this.content,
    this.transpose = 0,
    this.lyricStyle,
    this.chordStyle,
    this.sectionStyle,
  });

  final String content;
  final int transpose;
  final TextStyle? lyricStyle;
  final TextStyle? chordStyle;
  final TextStyle? sectionStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveLyricStyle =
        lyricStyle ??
        theme.textTheme.bodyLarge?.copyWith(
          fontFamily: 'monospace',
          height: 1.4,
        );

    final effectiveChordStyle =
        chordStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
          height: 1.2,
        );

    final effectiveSectionStyle =
        sectionStyle ??
        theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.secondary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        );

    final lines = ChordProParser.parse(content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        return switch (line) {
          SectionLine(:final name) => Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withValues(
                  alpha: 0.45,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(name.toUpperCase(), style: effectiveSectionStyle),
            ),
          ),
          EmptyLine() => const SizedBox(height: 10),
          LyricLine(:final tokens, :final hasChords, :final isChordsOnly) =>
            isChordsOnly
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _ChordsOnlyRow(
                      tokens: tokens,
                      transpose: transpose,
                      chordStyle: effectiveChordStyle,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(bottom: hasChords ? 6 : 2),
                    child: _LyricRow(
                      tokens: tokens,
                      transpose: transpose,
                      lyricStyle: effectiveLyricStyle,
                      chordStyle: effectiveChordStyle,
                      hasChords: hasChords,
                    ),
                  ),
        };
      }).toList(),
    );
  }
}

class _LyricRow extends StatelessWidget {
  const _LyricRow({
    required this.tokens,
    required this.transpose,
    required this.lyricStyle,
    required this.chordStyle,
    required this.hasChords,
  });

  final List<ChordToken> tokens;
  final int transpose;
  final TextStyle? lyricStyle;
  final TextStyle? chordStyle;
  final bool hasChords;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: tokens.map((token) {
        final chord = token.chord != null
            ? ChordTransposer.transposeChord(token.chord!, transpose)
            : null;

        if (chord == null && token.text.isEmpty) return const SizedBox.shrink();

        return _ChordLyricCell(
          chord: chord,
          text: token.text,
          lyricStyle: lyricStyle,
          chordStyle: chordStyle,
          showChordRow: hasChords,
        );
      }).toList(),
    );
  }
}

class _ChordLyricCell extends StatelessWidget {
  const _ChordLyricCell({
    required this.chord,
    required this.text,
    required this.lyricStyle,
    required this.chordStyle,
    required this.showChordRow,
  });

  final String? chord;
  final String text;
  final TextStyle? lyricStyle;
  final TextStyle? chordStyle;
  final bool showChordRow;

  @override
  Widget build(BuildContext context) {
    final chordWidget = chord != null
        ? Text(chord!, style: chordStyle)
        : showChordRow
        // Invisible placeholder to keep lyric baseline aligned
        ? Text('', style: chordStyle)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (chordWidget != null) chordWidget,
        if (text.isNotEmpty) Text(text, style: lyricStyle),
      ],
    );
  }
}

class _ChordsOnlyRow extends StatelessWidget {
  const _ChordsOnlyRow({
    required this.tokens,
    required this.transpose,
    required this.chordStyle,
  });

  final List<ChordToken> tokens;
  final int transpose;
  final TextStyle? chordStyle;

  @override
  Widget build(BuildContext context) {
    final chords = tokens
        .where((t) => t.chord != null)
        .map((t) => ChordTransposer.transposeChord(t.chord!, transpose))
        .toList();

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: chords.map((chord) => Text(chord, style: chordStyle)).toList(),
    );
  }
}
