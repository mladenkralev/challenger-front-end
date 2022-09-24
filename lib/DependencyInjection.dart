import 'package:get_it/get_it.dart';

import 'shared/model/UserManager.dart';
import 'shared/services/AssetService.dart';
import 'shared/services/ChallengeService.dart';
import 'shared/services/LoginService.dart';

final locator = GetIt.instance;

void configureDependencies() {
  locator.registerLazySingleton<LoginService>(() => LoginService());
  locator.registerLazySingleton<ChallengeService>(() => ChallengeService());
  locator.registerLazySingleton<UserManager>(() => UserManager());
  locator.registerLazySingleton<AssetService>(() => AssetService());
}