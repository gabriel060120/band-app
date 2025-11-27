import 'package:band_app/domain/models/lyrics/lyrics.dart';
import 'package:flutter/material.dart';

class LyricsWidget extends StatelessWidget {
  const LyricsWidget({super.key, required this.lyrics});
  final Lyrics lyrics;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(lyrics.content, style: TextStyle(fontSize: 20)),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
