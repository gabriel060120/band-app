abstract class EventSelectedState {
  EventSelectedState();
}

class EventSelectedInitialState extends EventSelectedState {
  final String repertoireId;
  EventSelectedInitialState(this.repertoireId);
}

class EventSelectLyricsState extends EventSelectedState {
  final String repertoireId;
  EventSelectLyricsState(this.repertoireId);
}

class EventSelectCipherState extends EventSelectedState {
  EventSelectCipherState();
}
