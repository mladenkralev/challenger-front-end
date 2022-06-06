import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/configuration.dart';
import 'package:challenger/global_constants.dart';
import 'package:challenger/screens/shared/challenge_card.dart';
import 'package:challenger/services/challenge_service.dart';
import 'package:challenger/services/login_service.dart';
import 'package:challenger/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserHome extends StatefulWidget {
  final UserManager userManager;

  BuildContext context;

  UserHome(this.userManager, this.context);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final List<GlobalKey<ChallengeCardState>> _keys = List.empty(growable: true);

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

              final Challenge challenge =  widget.userManager.getAssignChallenges()[index];
              GlobalKey<ChallengeCardState> cardKey = GlobalKey();
              _keys.add(cardKey);
              return  Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      CardCustomSlidableAction(cardKey: cardKey, challenge: challenge, userManager: widget.userManager, index: index),
                    ],
                  ),

                  child: new ChallengeCard(cardKey, challenge)
              );
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

class CardCustomSlidableAction extends StatefulWidget {
  final UserManager userManager;

  int index;

  Challenge challenge;

  GlobalKey<ChallengeCardState> cardKey;


  CardCustomSlidableAction({this.cardKey, Key key, this.challenge,this.userManager, this.index}) : super(key: key);

  @override
  State<CardCustomSlidableAction> createState() => _CardCustonSlidableActionState();
}

class _CardCustonSlidableActionState extends State<CardCustomSlidableAction> {
  final ChallengeService challengeService = locator<ChallengeService>();

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      backgroundColor: Color(0xFFF9F6F4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          color: Color(0xFFFE4A49),
        ),
        child: Center(
          child: IconButton(
            iconSize: 30,
            icon: const Icon(Icons.done),
            onPressed: () async => {
              await challengeService.upgradeProgressOfChallenge(widget.userManager, widget.index),
              widget.cardKey.currentState.updateChallengeProgress()
            },
          ),
        ),
      ),
    );
  }
}



