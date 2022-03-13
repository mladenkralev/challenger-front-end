import 'package:challenger/screens/components/add_page.dart';
import 'package:challenger/screens/user/profile/components/animated_user_challenge.dart';
import 'package:challenger/screens/user/profile/components/tabs/profile_tab.dart';
import 'package:challenger/screens/user/profile/components/user_home.dart';
import 'package:challenger/time/occurrences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../home_page.dart';

// Should contain only view stuff
class Body {
  UserHomePageState parent;
  List<Widget> widgetOptions;

  Body(this.parent) {
    widgetOptions = <Widget>[
      UserHome(this.parent.widget.userManager, parent.context),
      new ProfileHome(this.parent.widget.userManager, parent.context),
      AddCustomChallengePage(parent.context, this.parent.addNewChallenge),
    ];
  }

  Widget getChallenges() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: this.parent.widget.userManager.getAssignChallenges().length,
      itemBuilder: (context, index) {
        final item = this.parent.widget.userManager.getAssignChallenges()[index];
        return AnimatedUserChallenge(
            index, item, parent.markUserChallengeAsCompleted);
      },
    );
  }

  Widget noChallengesWidget() {
    switch (parent.currentlyDisplayed) {
      case Occurrences.DAY:
        return SizedBox(
          child: Card(
            child: ListTile(
                title:
                    Center(child: Text('You completed every challenge today!')),
                subtitle: Center(child: Text('You are awesome!'))),
          ),
        );
      case Occurrences.WEEK:
        return SizedBox(
          child: Card(
            child: ListTile(
                title: Center(
                    child:
                        Text('You completed every challenge for the weekend!')),
                subtitle: Center(child: Text('That\'s right, YOU did it!'))),
          ),
        );
      case Occurrences.MONTH:
        return SizedBox(
          child: Card(
            child: ListTile(
                title: Center(
                    child:
                        Text('You completed every challenge for the month!')),
                subtitle: Center(child: Text('You showed them!'))),
          ),
        );
    }
    return null;
  }
}
