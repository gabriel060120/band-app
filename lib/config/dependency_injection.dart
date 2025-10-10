import 'package:band_app/data/services/api/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;

void registerCore() {
  di
    ..registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage())
    ..registerLazySingleton<ApiClient>(() => ApiClient());
}
