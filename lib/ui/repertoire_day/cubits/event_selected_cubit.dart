import 'package:band_app/ui/repertoire_day/cubits/event_selected_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventSelectedCubit extends Cubit<EventSelectedState> {
  EventSelectedCubit() : super(EventSelectedInitialState(''));
}
