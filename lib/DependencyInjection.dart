import 'package:challenger/shared/services/HistoryChallengeService.dart';
import 'package:challenger/shared/services/StatisticsService.dart';
import 'package:challenger/shared/services/TagColorRelationService.dart';
import 'package:get_it/get_it.dart';

import 'shared/services/AssignedChallengeService.dart';
import 'shared/services/BrowseChallengeService.dart';
import 'shared/services/UserManager.dart';
import 'shared/services/AssetService.dart';
import 'shared/services/LoginService.dart';

final locator = GetIt.instance;

void configureDependencies() {
  locator.registerLazySingleton<LoginService>(() => LoginService());
  locator.registerLazySingleton<AssignedChallengeService>(() => AssignedChallengeService());
  locator.registerLazySingleton<BrowseChallengeService>(() => BrowseChallengeService());
  locator.registerLazySingleton<StatisticsService>(() => StatisticsService());
  locator.registerLazySingleton<UserManagerService>(() => UserManagerService());
  locator.registerLazySingleton<AssetService>(() => AssetService());
  locator.registerLazySingleton<HistoryChallengeService>(() => HistoryChallengeService());
  locator.registerLazySingleton<TagColorRelationService>(() => TagColorRelationService());
}