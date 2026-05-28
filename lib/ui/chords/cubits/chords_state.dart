import 'package:band_app/domain/models/chords/chords.dart';

abstract class ChordsState {
  final int index;
  final List<Chords> chords;
  final int transpose;

  ChordsState(this.index, this.chords, {this.transpose = 0});
}

class ChordsInitial extends ChordsState {
  ChordsInitial(List<Chords> chords) : super(0, chords);
}

class ChordsLoaded extends ChordsState {
  ChordsLoaded(super.index, super.chords, {super.transpose});
}

class ChordsError extends ChordsState {
  final String message;
  ChordsError(this.message) : super(0, []);
}
