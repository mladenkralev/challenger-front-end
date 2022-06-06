import 'package:challenger/screens/user/profile/home_page.dart';
import 'package:challenger/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../configuration.dart';
import 'login/login_page.dart';

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

        ),
        home: userManager.hasUser == null ? LoginPage(userManager) : UserHomePage(userManager)
    );
  }
}
