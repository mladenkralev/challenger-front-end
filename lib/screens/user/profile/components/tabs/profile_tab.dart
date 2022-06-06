import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/charts/pie_chart_component.dart';
import 'package:challenger/charts/stats_user.dart';

import 'package:challenger/screens/user/profile/components/challenge_sized_box.dart';
import 'package:challenger/user/user.dart';
import 'package:challenger/services/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileHome extends StatefulWidget {
  UserManager userManager;

  BuildContext context;

  ProfileHome(this.userManager, this.context);

  @override
  _ProfileHomeState createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  final double nameBellowBackground = -50;

  final double cardsBellowName = 60;

  final double horizontalBoxHeight = 100.0;
  final double horizontalBoxWidth = 150.0;

  final double bottomStatisticsSize = 300;
  final double backgroundPictureHeight = 150;

  double paddingConstraint = 5;

  List<Widget> items = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: Column(children: [
                    Container(
                        constraints: new BoxConstraints.expand(height: backgroundPictureHeight),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage('assets/background.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: new Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            buildAvatar(context),
                            buildAvatarName(context),
                          ],
                        )
                    )
              ])),
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: cardsBellowName),
              child: SingleChildScrollView(
                  child: Column(
                children: [getChallengeBoxes()],
              ))),
          SizedBox(
              height: bottomStatisticsSize,
              child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Column(children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Container(
                                  height: bottomStatisticsSize / 2,
                                  child: ChallengesDonut(widget.userManager),
                                ),
                              ],
                            )),
                        Expanded(
                            child: Column(
                          children: [
                            Container(
                              height: bottomStatisticsSize / 2,
                              child: UserStats(widget.userManager),
                            ),
                          ],
                        ))
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: Column(
                    //           children: [
                    //             Container(
                    //               height: 300,
                    //               child: BarChartSample2(),
                    //             ),
                    //           ],
                    //         )),
                    //   ],
                    // ),
                  ])))
        ]));
  }

  Positioned buildAvatarName(BuildContext context) {
    final leftPositioning = 80.0;
    final username = widget.userManager.username;
    final title = widget.userManager.title;

    return Positioned(
      left: leftPositioning,
      bottom: nameBellowBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(username, style: Theme.of(context).textTheme.headline6),
          Container(
            child: Text(
              title,
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
    );
  }

  Positioned buildAvatar(BuildContext context) {
    final double leftPositioning = 10.0;
    final double bellowBackgroundPicture = -30;
    final double radiusOfAvatar = 30.0;

    return new Positioned(
      left: leftPositioning,
      bottom: bellowBackgroundPicture,
      child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColorLight,
          radius: radiusOfAvatar,
          child: Text(widget.userManager.username.substring(0, 1))),
    );
  }

  SizedBox getChallengeBoxes() {
    Map<String, List<Challenge>> predefinedInputsForBoxes = {
      "Assigned challenges": widget.userManager.getAssignChallenges(),
      "Completed challenges": widget.userManager.getCompletedChallenges(),
      "Completed challenges1": widget.userManager.getCompletedChallenges(),
      "Completed challenges2": widget.userManager.getCompletedChallenges(),
      "Completed challenges3": widget.userManager.getCompletedChallenges()
    };

    List<Widget> statisticsBoxes = [];
    predefinedInputsForBoxes.forEach(
        (key, value) => statisticsBoxes.add(new ChallengeSizedBox(key, value)));

    Widget sizedBox = SizedBox(
        height: horizontalBoxHeight,
        child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: statisticsBoxes));
    return sizedBox;
  }
}
