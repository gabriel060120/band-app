import 'package:band_app/data/repositories/repertoire_day/update_music_on_event_repository.dart';
import 'package:band_app/domain/models/repertoire_day/music.dart';
import 'package:band_app/domain/models/repertoire_day/music_in_repertoire.dart';
import 'package:band_app/utils/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits.dart';

class UpdateMusicOnEventCubit extends Cubit<UpdateMusicOnEventState> {
  UpdateMusicOnEventCubit(this.repository) : super(UpdateMusicOnEventInitial());

  final UpdateMusicOnEventRepository repository;

  List<MusicInRepertoire> allMusics = [];

  List<Music> initialMusicsSelected = [];
  List<Music> removeMusics = [];
  List<Music> addMusics = [];

  void getAllMusics(List<Music> initialMusicsSelected) async {
    emit(UpdateMusicOnEventLoading());
    this.initialMusicsSelected = initialMusicsSelected;
    final result = await repository.getAllMusics();
    result.fold(
      (musics) {
        allMusics = musics
            .map(
              (music) => MusicInRepertoire(
                musicData: music,
                isSelected: initialMusicsSelected.any(
                  (selectedMusic) => selectedMusic.id == music.id,
                ),
              ),
            )
            .toList();
        emit(UpdateMusicOnEventLoaded());
      },
      (error) {
        emit(UpdateMusicOnEventError('Erro ao carregar as músicas'));
      },
    );
  }

  void changeMusicStatus(Music music) {
    final musicInRepertoire = allMusics.firstWhere(
      (m) => m.musicData.id == music.id,
    );
    musicInRepertoire.isSelected = !musicInRepertoire.isSelected;

    if (musicInRepertoire.isSelected) {
      if (!initialMusicsSelected.any(
        (selectedMusic) => selectedMusic.id == music.id,
      )) {
        addMusics.add(music);
      }
      removeMusics.removeWhere((m) => m.id == music.id);
    } else {
      if (initialMusicsSelected.any(
        (selectedMusic) => selectedMusic.id == music.id,
      )) {
        removeMusics.add(music);
      }
      addMusics.removeWhere((m) => m.id == music.id);
    }

    emit(UpdateMusicOnEventLoaded());
  }

  Future<void> updateMusicToEvent({required String eventId}) async {
    emit(UpdateMusicOnEventUpdating());

    String? error;

    if (addMusics.isNotEmpty) {
      error = await addMusicsToEvent(eventId: eventId);
      if (error != null) {
        emit(UpdateMusicOnEventUpdateError(error));
        return;
      }
    }

    if (removeMusics.isNotEmpty) {
      error = await removeMusicsToEvent(eventId: eventId);
      if (error != null) {
        emit(UpdateMusicOnEventUpdateError(error));
        return;
      }
    }

    emit(UpdateMusicOnEventUpdated());
  }

  Future<String?> addMusicsToEvent({required String eventId}) async {
    final result = await repository.addMusicsToEvent(
      eventId: eventId,
      musics: addMusics,
    );

    return result.fold(
      (ok) {
        return null;
      },
      (error) {
        return error.toString();
      },
    );
  }

  Future<String?> removeMusicsToEvent({required String eventId}) async {
    final result = await repository.removeMusicsToEvent(
      eventId: eventId,
      musics: removeMusics,
    );
    return result.fold(
      (ok) {
        return null;
      },
      (error) {
        return error.toString();
      },
    );
  }
}
