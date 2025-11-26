// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:band_app/domain/models/repertoire_day/music.dart';
import 'package:band_app/domain/models/repertoire_day/repertoire_day.dart';

class EventData {
  final RepertoireDay eventDay;
  final List<Music> musics;
  EventData({required this.eventDay, required this.musics});

  factory EventData.fromMap(Map<String, dynamic> map) {
    return EventData(
      eventDay: RepertoireDay.fromMap(map),
      musics: List<Music>.from(
        (map['repertoire_music'] ?? []).map<Music>(
          (music) => Music.fromMap(music),
        ),
      ),
    );
  }
}
