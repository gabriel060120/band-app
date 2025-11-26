import 'package:band_app/domain/models/repertoire_day/event_data.dart';

abstract class EventSelectedState {
  final String repertoireId;
  EventSelectedState(this.repertoireId);
}

class EventSelectedLoadingState extends EventSelectedState {
  EventSelectedLoadingState(super.repertoireId);
}

class EventSelectedInitialState extends EventSelectedState {
  EventSelectedInitialState(super.repertoireId);
}

class EventSelectedLoadedState extends EventSelectedState {
  final EventData eventData;
  EventSelectedLoadedState(super.repertoireId, this.eventData);
}

class EventSelectedErrorState extends EventSelectedState {
  final String errorMessage;
  EventSelectedErrorState(super.repertoireId, this.errorMessage);
}

class EventSelectLyricsState extends EventSelectedState {
  EventSelectLyricsState(super.repertoireId);
}

class EventSelectCipherState extends EventSelectedState {
  EventSelectCipherState(super.repertoireId);
}
