import 'package:challenger/android/screens/components/AddCustomChallengePage.dart';
import 'package:challenger/android/screens/user/profile/components/AnimatedUserChallenge.dart';
import 'package:challenger/android/screens/user/profile/components/profile/ProfileHome.dart';
import 'package:challenger/android/screens/user/profile/components/UserHome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../UserHomePage.dart';

class UserHomeBody {
  UserHomePageState parent;
  List<Widget> widgetOptions;

  UserHomeBody(this.parent) {
    widgetOptions = <Widget>[
      UserHome(this.parent.widget.userManager, parent.context),
      new ProfileHome(this.parent.widget.userManager, parent.context),
      AddCustomChallengePage(parent.context, this.parent.addNewChallenge),
    ];
  }
}
