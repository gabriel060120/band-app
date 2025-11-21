import 'package:band_app/data/repositories/repertoire_day/repertoire_day_repository.dart';
import 'package:band_app/data/services/api/api_client.dart';
import 'package:band_app/routing/routing.dart';
import 'package:band_app/ui/repertoire_day/cubits/repertoire_day_cubit.dart';
import 'package:band_app/ui/repertoire_day/widgets/repertoire_day_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class RepertoireDayModule implements FeatureModule {
  @override
  String get name => 'repertoire-day';

  @override
  void register(GetIt di) {
    di
      ..registerFactory<RepertoireDayRepository>(
        () => RepertoireDayRepository(di<ApiClient>()),
      )
      ..registerFactory<RepertoireDayCubit>(
        () => RepertoireDayCubit(di<RepertoireDayRepository>()),
      );
  }

  @override
  List<RouteBase> routes() => [
    GoRoute(
      path: '/timeline-repertoire',
      builder: (context, state) => BlocProvider<RepertoireDayCubit>.value(
        value: GetIt.I<RepertoireDayCubit>(),
        child: const RepertoireDayScreen(),
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
