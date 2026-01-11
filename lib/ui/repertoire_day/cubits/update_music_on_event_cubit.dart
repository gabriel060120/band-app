import 'package:band_app/domain/models/repertoire_day/music.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits.dart';

class UpdateMusicOnEventCubit extends Cubit<UpdateMusicOnEventState> {
  UpdateMusicOnEventCubit() : super(UpdateMusicOnEventInitial());

  List<Music> allMusics = [];

  // void getMusics
}
