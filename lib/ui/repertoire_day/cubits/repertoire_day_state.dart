import 'package:band_app/domain/models/lyrics/lyrics.dart';
import 'package:band_app/domain/models/repertoire_day/repertoire_day.dart';

class RepertoireDayState {}

class RepertoireDayInitial extends RepertoireDayState {}

class RepertoireDayLoading extends RepertoireDayState {}

class RepertoireDaySelectTypeState extends RepertoireDayState {
  final RepertoireDay repertoireDay;
  RepertoireDaySelectTypeState(this.repertoireDay);

  RepertoireDaySelectTypeState copyWith({RepertoireDay? repertoireDay}) {
    return RepertoireDaySelectTypeState(repertoireDay ?? this.repertoireDay);
  }
}

class RepertoireDayLyricsState extends RepertoireDayState {
  final List<Lyrics> lyrics;
  final int index;
  RepertoireDayLyricsState(this.lyrics, this.index);

  RepertoireDayLyricsState copyWith({List<Lyrics>? lyrics, int? index}) {
    return RepertoireDayLyricsState(lyrics ?? this.lyrics, index ?? this.index);
  }
}

class RepertoireDayCipherState extends RepertoireDayState {
  final List<String> cipher;
  final int index;
  RepertoireDayCipherState(this.cipher, this.index);

  RepertoireDayCipherState copyWith({List<String>? cipher, int? index}) {
    return RepertoireDayCipherState(cipher ?? this.cipher, index ?? this.index);
  }
}

class RepertoireDayError extends RepertoireDayState {
  final String message;
  RepertoireDayError(this.message);
}
