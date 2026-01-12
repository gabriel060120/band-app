import 'package:band_app/data/repositories/repertoire_day/update_music_on_event_repository.dart';
import 'package:band_app/data/services/api/api_client.dart';
import 'package:band_app/routing/routing.dart';
import 'package:band_app/ui/repertoire_day/widgets/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/repositories.dart';
import '../../domain/models/lyrics/lyrics.dart';
import '../../domain/models/repertoire_day/music.dart';
import '../lyrics/cubits/lyrics_cubit.dart';
import '../lyrics/widgets/lyrics_screen.dart';
import 'cubits/cubits.dart';

class RepertoireDayModule implements FeatureModule {
  @override
  String get name => 'repertoire-day';

  @override
  void register(GetIt di) {
    di
      ..registerFactory<RepertoireDayRepository>(
        () => RepertoireDayRepository(di<ApiClient>()),
      )
      ..registerFactory<EventSelectedRepository>(
        () => EventSelectedRepository(di<ApiClient>()),
      )
      ..registerFactory<CreateEventRepository>(
        () => CreateEventRepository(di<ApiClient>()),
      )
      ..registerFactory<CreateEventCubit>(
        () => CreateEventCubit(di<CreateEventRepository>()),
      )
      ..registerFactory<UpdateMusicOnEventRepository>(
        () => UpdateMusicOnEventRepository(di<ApiClient>()),
      )
      ..registerFactory<UpdateMusicOnEventCubit>(
        () => UpdateMusicOnEventCubit(di<UpdateMusicOnEventRepository>()),
      )
      ..registerFactory<RepertoireDayCubit>(
        () => RepertoireDayCubit(di<RepertoireDayRepository>()),
      );
  }

  @override
  List<RouteBase> routes() => [
    GoRoute(
      path: '/timeline-repertoire',
      name: 'repertoire-timeline',
      builder: (context, state) => BlocProvider<RepertoireDayCubit>.value(
        value: GetIt.I<RepertoireDayCubit>(),
        child: const RepertoireDayScreen(),
      ),
    ),
    GoRoute(
      path: '/create-event',
      name: 'create-event',
      builder: (context, state) => BlocProvider<CreateEventCubit>.value(
        value: GetIt.I<CreateEventCubit>(),
        child: const CreateEventScreen(),
      ),
    ),
    GoRoute(
      path: '/select-repertoire-type',
      name: 'select-repertoire-type',
      builder: (context, state) => BlocProvider<EventSelectedCubit>.value(
        value: EventSelectedCubit(
          EventSelectedInitialState(state.extra as String),
          GetIt.I<EventSelectedRepository>(),
        ),
        child: const EventSelectedScreen(),
      ),
    ),
    GoRoute(
      path: '/update-music-on-event/:eventId',
      name: 'update-music-on-event',
      builder: (context, state) => BlocProvider<UpdateMusicOnEventCubit>.value(
        value: GetIt.I<UpdateMusicOnEventCubit>(),
        child: UpdateMusicOnEventScreen(
          initialSelectedMusics: state.extra as List<Music>,
          eventId: state.pathParameters['eventId'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/lyrics',
      name: 'lyrics_list',
      builder: (context, state) => BlocProvider<LyricsCubit>.value(
        value: LyricsCubit(state.extra as List<Lyrics>),
        child: const LyricsScreen(),
      ),
    ),
    GoRoute(
      path: '/repertoire-day',
      builder: (context, state) => BlocProvider<RepertoireDayCubit>.value(
        value: GetIt.I<RepertoireDayCubit>(),
        child: const RepertoireDayScreen(),
      ),
    ),
  ];
}
