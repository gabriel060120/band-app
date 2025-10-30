import 'package:bloc/bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'lyrics_state.dart';

class LyricsCubit extends Cubit<LyricsState> {
  late final InAppWebViewController webViewController;

  LyricsCubit() : super(LyricsInitial());

  Future<void> fetchRepertoireDays() async {
    // final result = await _repertoireDayRepository.fetchRepertoireDays();
    // result.fold(
    //   (r) {
    //     emit(RepertoireDayLoaded(r, 0));
    //   },
    //   (l) {
    //     emit(RepertoireDayError('Talvez você não esteja conectado à internet'));
    //   },
    // );
  }
}
