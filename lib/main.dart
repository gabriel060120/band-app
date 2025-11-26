import 'package:band_app/config/config.dart';
import 'package:band_app/data/services/api/api_client.dart';
import 'package:band_app/ui/repertoire_day/repertoire_day_module.dart';
import 'package:band_app/ui/splash/splash_module.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'routing/routing.dart';

Future<void> main() async {
  registerCore();
  await initializeDateFormatting('pt_BR', null);
  await GetIt.I<ApiClient>().init();
  final modules = <FeatureModule>[SplashModule(), RepertoireDayModule()];
  for (final module in modules) {
    module.register(di);
  }
  final router = buildRouter(modules);

  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Band APP',
      theme: ThemeData(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
