import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/global_constants.dart';
import 'package:challenger/screens/shared/challenge_card.dart';
import 'package:challenger/user/user_manager.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  final UserManager userManager;

  BuildContext context;

  UserHome(this.userManager, this.context);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  static const double _leftPadding = 16.0;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  String message = "Your challenges";
  final double backgroundPictureHeight = 150;

  List<ChallengeCard> items = [];

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              _title(),
              _getChallenges()
            ]
        ));
  }

  Widget _getChallenges() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16,top: 16, bottom: 16),
            alignment: Alignment.topLeft,
            child: Text(
              "Your challenges progress",
              style: TextStyle(
                fontSize: 18
              ),
            )
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount:  widget.userManager.getAssignChallenges().length,
            itemBuilder: (context,index){
              Challenge challenge =  widget.userManager.getAssignChallenges()[index];
              return  new ChallengeCard(ObjectKey(challenge), challenge);
            })],
      ),
    );
  }

  SizedBox noChallengesWidget() {
    return SizedBox(
      child: Card(
        child: ListTile(
            title: Center(child: Text('There are no challenges.')),
            subtitle: Center(child: Text('Oops :( '))),
      ),
    );
  }

  Future<List<Challenge>> getUserChallenges() async {
    return await widget.userManager.getAssignChallenges();
  }

  Widget _title() {
    return Container(
      color: Colors.white,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 50, left: 16, bottom: 30),
      child: new Text(
        "Good day, \nJohn Bash!",
        style: TextStyle(
          fontSize: 20
        ),
      ),
    );
  }
}
