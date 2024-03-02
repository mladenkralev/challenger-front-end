import 'package:challenger/shared/login/LoginPage.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';

import '../DependencyInjection.dart';
import 'profile/UserHomeWeb.dart';

class EntryPageWeb extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _EntryPageWebState createState() => _EntryPageWebState();
}

class _EntryPageWebState extends State<EntryPageWeb> {
  final userManager = locator<UserManagerService>();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return UserHomePage(new User());
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: WebGlobalConstants.primaryColor,
            colorScheme: WebGlobalConstants.colorScheme,
            backgroundColor: WebGlobalConstants.backgroundColor,
            textTheme: GoogleFonts.montserratTextTheme(
              TextTheme(
                displayLarge: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: WebGlobalConstants.h1Size
                ), // Used for the largest text in Material 3
                bodyLarge: TextStyle(
                    color: Colors.black,
                    fontSize: WebGlobalConstants.h1Size
                ), // Used for large body text in Material 3
                bodyMedium: TextStyle(
                    color: Colors.black,
                    fontSize: WebGlobalConstants.h2Size
                ),
              ),
            ).apply(bodyColor: Colors.black), // Applying black as the default body color
            pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                }
            )

        ),
        home: userManager.hasUser == null
    ? LoginPage(userManager): UserHomeWeb(userManager)
    ,
    // textTheme: const TextTheme(
    //     headline1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //     headline2: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
    // ),
    );
  }
}
