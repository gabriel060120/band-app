import 'package:band_app/config/config.dart';
import 'package:band_app/ui/splash/splash_module.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routing/routing.dart';

void main() {
  registerCore();

  final modules = <FeatureModule>[SplashModule()];
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
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
