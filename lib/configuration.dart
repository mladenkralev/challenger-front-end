import 'package:challenger/services/login_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final locator = GetIt.instance;

void configureDependencies() {
  locator.registerLazySingleton<LoginService>(() => LoginService());
}