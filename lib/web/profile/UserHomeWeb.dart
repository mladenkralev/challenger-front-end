import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/model/UserManager.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:challenger/web/profile/components/SideBar.dart';
import 'package:challenger/web/profile/components/UserHomeWebPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserHomeWeb extends StatefulWidget {
  static const String id = 'user_profile_page';

  // User user
  UserManager userManager;

  UserHomeWeb(this.userManager);

  @override
  UserHomeWebState createState() => UserHomeWebState();
}

class UserHomeWebState extends State<UserHomeWeb> {
  Occurrences currentlyDisplayed = Occurrences.DAY;

  String getUserGreeting() =>  "Good day, \n" + widget.userManager.username;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          appBar: AppBar(
              title: Text(getUserGreeting()),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: WebGlobalConstants.foregroundColor,
              titleTextStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.headline1.fontSize,
              )
          ),
            body: UserHomeWebPage(widget.userManager, context),
            drawer: SideBar(widget.userManager),
        ),
    );
  }
}
