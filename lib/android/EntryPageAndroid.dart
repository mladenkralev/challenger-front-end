import 'package:challenger/android/AndroidGlobalConstants.dart';
import 'package:challenger/android/screens/user/profile/UserHomePage.dart';
import 'package:challenger/shared/login/LoginPage.dart';
import 'package:challenger/shared/model/UserManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../DependencyInjection.dart';

class EntryPage extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
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
          primaryColor: AndroidGlobalConstants.primaryColor,
          colorScheme: AndroidGlobalConstants.secondColor,
          backgroundColor: AndroidGlobalConstants.backgroundColor,
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            headline2: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
        ),
        home: userManager.hasUser == null ? LoginPage(userManager) : UserHomePage(userManager)
    );
  }
}
