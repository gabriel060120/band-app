import 'package:band_app/domain/models/repertoire_day/repertoire_day.dart';

class RepertoireDayState {}

class RepertoireDayInitial extends RepertoireDayState {}

class RepertoireDayLoading extends RepertoireDayState {}

class RepertoireDayListState extends RepertoireDayState {
  final List<RepertoireDay> repertoireDays;
  RepertoireDayListState(this.repertoireDays);
}

class RepertoireDaySelectTypeState extends RepertoireDayState {
  final RepertoireDay repertoireDay;
  RepertoireDaySelectTypeState(this.repertoireDay);

  RepertoireDaySelectTypeState copyWith({RepertoireDay? repertoireDay}) {
    return RepertoireDaySelectTypeState(repertoireDay ?? this.repertoireDay);
  }
}

class RepertoireDaySelectLyricsState extends RepertoireDayState {
  final String repertoireId;
  RepertoireDaySelectLyricsState(this.repertoireId);
}

class RepertoireDaySelectCipherState extends RepertoireDayState {
  final String repertoireId;
  RepertoireDaySelectCipherState(this.repertoireId);
}

class RepertoireDayError extends RepertoireDayState {
  final String message;
  RepertoireDayError(this.message);
}
