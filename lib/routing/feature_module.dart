import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

abstract class FeatureModule {
  String get name;
  void register(GetIt di);
  List<RouteBase> routes();
}
