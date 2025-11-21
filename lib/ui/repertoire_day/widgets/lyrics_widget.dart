import 'package:band_app/domain/models/lyrics/lyrics.dart';
import 'package:flutter/material.dart';

class LyricsWidget extends StatefulWidget {
  const LyricsWidget({super.key, required this.lyrics, this.fontSize = 20});
  final Lyrics lyrics;
  final int fontSize;

  @override
  State<LyricsWidget> createState() => _LyricsWidgetState();
}

class _LyricsWidgetState extends State<LyricsWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              Text(
                widget.lyrics.title,
                style: TextStyle(
                  fontSize: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 16),
              Text(widget.lyrics.content, style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
