import 'dart:developer';

import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/configuration.dart';
import 'package:challenger/global_constants.dart';
import 'package:challenger/screens/shared/challenge_card.dart';
import 'package:challenger/screens/user/profile/components/occurrence_switcher.dart';
import 'package:challenger/services/challenge_service.dart';
import 'package:challenger/services/login_service.dart';
import 'package:challenger/services/user_manager.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../time/occurrences.dart';

class UserHome extends StatefulWidget {
  final UserManager userManager;

  BuildContext context;

  UserHome(this.userManager, this.context);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final List<GlobalKey<ChallengeCardState>> _keys = List.empty(growable: true);

  String challengePrefixMessage = "Your ";
  String challengePostfixMessage = " challenges progress";
  final double backgroundPictureHeight = 150;

  Occurrences currentlyDisplayed = Occurrences.DAY;

  int occurrencesIndex = 0;
  var listView;

  final occurrences = [
    Occurrences.DAY,
    Occurrences.WEEK,
    Occurrences.MONTH
  ];

  List<Challenge> shownChallenges = List.empty(growable: true);
  List<ChallengeCard> shownCards = List.empty(growable: true);
  Map<Occurrences, List<Challenge>> allChallenges = {};

  @override
  void initState() {
    allChallenges.putIfAbsent(Occurrences.DAY, () =>  widget.userManager.getDailyAssignChallenges());
    allChallenges.putIfAbsent(Occurrences.WEEK, () => widget.userManager.getWeeklyAssignChallenges());
    allChallenges.putIfAbsent(Occurrences.MONTH, () =>   widget.userManager.getMonthlyAssignChallenges());
    log("allChallenges[Occurrences.DAY] is " +  allChallenges[Occurrences.DAY].toString());
    shownChallenges.clear();
    shownChallenges.addAll(allChallenges[Occurrences.DAY]);
  }

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
    listView = _buildViewableList();
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16,top: 16, bottom: 16),
            alignment: Alignment.topLeft,
              child: _challengeMessage()
          ),
          listView
        ],
      ),
    );
  }

  Widget _buildViewableList() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:  shownChallenges.length,
        itemBuilder: (context, index) {
          final Challenge challenge =  shownChallenges[index];
          return _getSlidableCustomChallengeCard(challenge, index);
        });
  }

  changeDisplayedChallenges(Occurrences selectedOccurrenceType) {
    setState(() {
      currentlyDisplayed = selectedOccurrenceType;
      switch (selectedOccurrenceType) {
        case Occurrences.DAY:
          shownChallenges.clear();
          shownCards.clear();
          _keys.clear();
          log("allChallenges[Occurrences.DAY] is " +  allChallenges[Occurrences.DAY].toString());
          shownChallenges.addAll(allChallenges[Occurrences.DAY]);
          listView = _buildViewableList();
          break;
        case Occurrences.WEEK:
          shownChallenges.clear();
          shownCards.clear();
          shownChallenges.addAll(allChallenges[Occurrences.WEEK]);
          setState(() {
            listView = _buildViewableList();
          });
          break;
        case Occurrences.MONTH:
          shownChallenges.clear();
          shownCards.clear();
          shownChallenges.addAll(allChallenges[Occurrences.MONTH]);
          setState(() {
            listView = _buildViewableList();
          });
          break;
      }
    });
  }

  Widget _challengeMessage() {
    return Row(
      children: [
        Text(
          challengePrefixMessage,
          style: TextStyle(
              fontSize: 18
          ),
        ),
        DirectSelect(
            itemExtent: 40.0,
            selectedIndex: occurrencesIndex,
            child: OccurrenceSwitcher(
              isForList: false,
              title: OccurrencesTransformer.transformToString(occurrences[occurrencesIndex]),
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                occurrencesIndex = index;
                changeDisplayedChallenges(occurrences[index]);
              });
            },
            items: occurrences.map(
                    (val) => OccurrenceSwitcher(title: OccurrencesTransformer.transformToString(val))).toList()
        ),
        Text(
          challengePostfixMessage,
          style: TextStyle(
              fontSize: 18
          ),
        )
      ],
    );
  }

  Widget _getSlidableCustomChallengeCard(Challenge challenge, int index) {
    // add key for updating
    GlobalKey<ChallengeCardState> cardKey = GlobalKey();
    _keys.add(cardKey);

    // remember the card for clear and adding again
    ChallengeCard challengeCard = new ChallengeCard(cardKey, challenge);
    shownCards.add(challengeCard);

    // wrap with slidable
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            CardCustomSlidableAction(cardKey: cardKey, challenge: challenge, userManager: widget.userManager, index: index),
          ],
        ),
        child: challengeCard
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
  final occurrences = [
    OccurrencesTransformer.transformToString(Occurrences.DAY),
    OccurrencesTransformer.transformToString(Occurrences.WEEK),
    OccurrencesTransformer.transformToString(Occurrences.MONTH)
  ];

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



