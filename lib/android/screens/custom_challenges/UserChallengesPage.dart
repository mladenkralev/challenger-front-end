import 'package:challenger/android/screens/custom_challenges/UserChallengeCard.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserChallengesPage extends StatefulWidget {
  static const String id = 'user_challenges_page';
  UserManagerService user;

  UserChallengesPage(this.user);

  @override
  _UserChallengesPageState createState() => _UserChallengesPageState();
}

class _UserChallengesPageState extends State<UserChallengesPage> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
            getChallenges(widget.user.getAssignChallenges())
        ]));
  }

  removeExistingChallenge(ChallengeModel existingChallenge) {
    setState(() {
      // widget.user.manager.abandonChallenge(existingChallenge);
    });
  }

  Widget getChallenges(List<AssignedChallenges> snapshot) {
    return snapshot.length == 0
        ? SizedBox(
            child: Card(
              child: ListTile(
                  title: Center(
                      child: Text('You completed every challenge today!')),
                  subtitle: Center(child: Text('You are awesome!'))),
            ),
          )
        : SizedBox(
            child: ListView.builder(
                itemCount: snapshot.length,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                      return UserChallengeCard(
                          snapshot.asMap()[index],
                          widget.user,
                          removeExistingChallenge);
                      },
            ),
          );
  }
}
