import 'package:band_app/data/repositories/repertoire_day/event_selected_repository.dart';
import 'package:band_app/data/repositories/repertoire_day/repertoire_day_repository.dart';
import 'package:band_app/data/services/api/api_client.dart';
import 'package:band_app/routing/routing.dart';
import 'package:band_app/ui/lyrics/cubits/lyrics_cubit.dart';
import 'package:band_app/ui/lyrics/widgets/lyrics_screen.dart';
import 'package:band_app/ui/repertoire_day/cubits/event_selected_cubit.dart';
import 'package:band_app/ui/repertoire_day/cubits/event_selected_state.dart';
import 'package:band_app/ui/repertoire_day/cubits/repertoire_day_cubit.dart';
import 'package:band_app/ui/repertoire_day/widgets/event_selected_screen.dart';
import 'package:band_app/ui/repertoire_day/widgets/repertoire_day_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/lyrics/lyrics.dart';

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
      // ..registerFactory<EventSelectedCubit>(EventSelectedCubit.new)
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
