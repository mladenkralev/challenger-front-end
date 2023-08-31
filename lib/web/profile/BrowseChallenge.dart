import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:challenger/web/profile/components/SideBar.dart';
import 'package:challenger/web/profile/pages/BrowseChallengePage.dart';
import 'package:challenger/web/profile/pages/UserHomeWebPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pages/ChallengeTree.dart';

class BrowseChallenge extends StatefulWidget {
  static const String id = 'user_profile_page';

  // User user
  UserManagerService userManager;

  BrowseChallenge(this.userManager);

  @override
  BrowseChallengeState createState() => BrowseChallengeState();
}

class BrowseChallengeState extends State<BrowseChallenge> {
  Occurrences currentlyDisplayed = Occurrences.DAY;

  String getUserGreeting() =>  "Good day, " + widget.userManager.username!;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                getUserGreeting(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: WebGlobalConstants.foregroundColor,
              titleTextStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
              )
          ),
            body: BrowseChallengePage(widget.userManager, context),
            drawer: SideBar(widget.userManager),
        ),
    );
  }
}
