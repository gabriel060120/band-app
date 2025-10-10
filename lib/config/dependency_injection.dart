import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;

void registerCore() {
  // di.registerLazySingleton(
  //   () => DioClient(baseUrl: const String.fromEnvironment('API_URL')),
  // );
  di.registerLazySingleton(() => FlutterSecureStorage());
}
