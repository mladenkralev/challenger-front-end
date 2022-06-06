import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/screens/custom_challenges/user_challenge_card.dart';
import 'package:challenger/time/occurrences.dart';
import 'package:challenger/user/user.dart';
import 'package:challenger/services/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserChallengesPage extends StatefulWidget {
  static const String id = 'user_challenges_page';
  UserManager user;

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

  removeExistingChallenge(Challenge existingChallenge) {
    setState(() {
      // widget.user.manager.abandonChallenge(existingChallenge);
    });
  }

  Widget getChallenges(List<Challenge> snapshot) {
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
