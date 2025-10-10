import 'package:band_app/routing/feature_module.dart';
import 'package:band_app/ui/splash/cubits/cubits.dart';
import 'package:band_app/ui/splash/widgets/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class SplashModule implements FeatureModule {
  @override
  String get name => 'splash';

  @override
  void register(GetIt di) {
    di.registerFactory(() => SplashCubit());
  }

  @override
  List<RouteBase> routes() => [
    GoRoute(
      path: '/splash',
      builder: (context, state) => BlocProvider<SplashCubit>.value(
        value: GetIt.I<SplashCubit>(),
        child: const SplashScreen(),
      ),
    ),
  ];
}
