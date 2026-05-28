import 'package:band_app/domain/models/chords/chords.dart';
import 'package:band_app/utils/chordpro_parser.dart';
import 'package:flutter/material.dart';

import 'chordpro_render_widget.dart';

class ChordsWidget extends StatelessWidget {
  const ChordsWidget({super.key, required this.chords, this.transpose = 0});

  final Chords chords;
  final int transpose;

  @override
  Widget build(BuildContext context) {
    final isChordPro = ChordProParser.isChordPro(chords.content);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          if (isChordPro)
            ChordProRenderWidget(content: chords.content, transpose: transpose)
          else
            Text(
              chords.content,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }
}
