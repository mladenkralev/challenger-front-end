import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:challenger/web/profile/components/SideBar.dart';
import 'package:challenger/web/profile/pages/UserHomeWebPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pages/AssignedChallengesPage.dart';
import 'pages/CompletedChallengesPage.dart';

class CompletedChallengesRoot extends StatefulWidget {

  final userManager = locator<UserManagerService>();

  @override
  CompletedChallengesRootState createState() => CompletedChallengesRootState();
}

class CompletedChallengesRootState extends State<CompletedChallengesRoot> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
              "Completed Challenges",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: WebGlobalConstants.foregroundColor,
            titleTextStyle: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            )
        ),
        body: CompletedChallengesPage(context),
        drawer: SideBar(widget.userManager),
      ),
    );
  }
}
