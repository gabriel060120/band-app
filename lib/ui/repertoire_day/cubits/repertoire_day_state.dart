import 'package:band_app/domain/models/repertoire_day/repertoire_day.dart';

class RepertoireDayState {}

class RepertoireDayInitial extends RepertoireDayState {}

class RepertoireDayLoading extends RepertoireDayState {}

class RepertoireDayListState extends RepertoireDayState {
  final List<RepertoireDay> repertoireDays;
  RepertoireDayListState(this.repertoireDays);
}

class RepertoireDayError extends RepertoireDayState {
  final String message;
  RepertoireDayError(this.message);
}
