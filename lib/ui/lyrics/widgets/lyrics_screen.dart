import 'package:band_app/domain/models/lyrics/lyrics.dart';
import 'package:flutter/material.dart';

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key, required this.lyrics});
  final Lyrics lyrics;

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
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
              Text(widget.lyrics.content),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
