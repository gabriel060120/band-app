import 'package:band_app/domain/models/chords/chords.dart';
import 'package:flutter/material.dart';

class ChordsWidget extends StatelessWidget {
  const ChordsWidget({super.key, required this.chords});
  final Chords chords;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(chords.content, style: TextStyle(fontSize: 20)),
          SizedBox(height: 150),
        ],
      ),
    );
  }
}
