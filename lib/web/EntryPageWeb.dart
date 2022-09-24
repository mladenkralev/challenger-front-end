import 'package:challenger/shared/login/LoginPage.dart';
import 'package:challenger/shared/model/UserManager.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../DependencyInjection.dart';
import 'profile/UserHomeWeb.dart';

class EntryPageWeb extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _EntryPageWebState createState() => _EntryPageWebState();
}

class _EntryPageWebState extends State<EntryPageWeb> {
  final userManager = locator<UserManager>();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return UserHomePage(new User());
    return MaterialApp(
        theme: ThemeData(
          primaryColor: WebGlobalConstants.primaryColor,
          colorScheme: WebGlobalConstants.secondColor,
          backgroundColor: WebGlobalConstants.backgroundColor,
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            headline2: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
        ),
        home: userManager.hasUser == null ? LoginPage(userManager) : UserHomeWeb(userManager)
    );
  }


}
