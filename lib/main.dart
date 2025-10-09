import 'package:band_app/ui/repertoire_day/widgets/repertoire_day_screen.dart';
import 'package:band_app/ui/splash/widgets/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(nextScreen: RepertoireDayScreen()),
    );
  }
}
