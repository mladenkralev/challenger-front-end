import 'package:challenger/services/challenge_service.dart';
import 'package:challenger/services/login_service.dart';
import 'package:challenger/services/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final locator = GetIt.instance;

void configureDependencies() {
  locator.registerLazySingleton<LoginService>(() => LoginService());
  locator.registerLazySingleton<ChallengeService>(() => ChallengeService());
  locator.registerLazySingleton<UserManager>(() => UserManager());
}