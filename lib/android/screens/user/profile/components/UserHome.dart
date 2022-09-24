import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/card/ChallengeCard.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/model/UserManager.dart';
import 'package:challenger/shared/services/ChallengeService.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';

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

  String challengePrefixMessage = "Your ";
  String challengePostfixMessage = " challenges progress";

  Occurrences currentlyDisplayed = Occurrences.DAY;

  var listView;

  final occurrences = [
    Occurrences.DAY,
    Occurrences.WEEK,
    Occurrences.MONTH
  ];

  List<ChallengeModel> shownChallenges = List.empty(growable: true);
  List<ChallengeCard> shownCards = List.empty(growable: true);
  Map<Occurrences, List<ChallengeModel>> allChallenges = {};

  @override
  void initState() {
    allChallenges.putIfAbsent(Occurrences.DAY, () =>  widget.userManager.getDailyAssignChallenges());
    allChallenges.putIfAbsent(Occurrences.WEEK, () => widget.userManager.getWeeklyAssignChallenges());
    allChallenges.putIfAbsent(Occurrences.MONTH, () =>   widget.userManager.getMonthlyAssignChallenges());

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
          final ChallengeModel challenge =  shownChallenges[index];
          return _getSlidableCustomChallengeCard(challenge, index);
        });
  }

  changeDisplayedChallenges(Occurrences selectedOccurrenceType) {
    currentlyDisplayed = selectedOccurrenceType;
    shownChallenges.clear();
    shownCards.clear();
    _keys.clear();
    shownChallenges.addAll(allChallenges[selectedOccurrenceType]);
    listView = _buildViewableList();
  }

  Widget _challengeMessage() {
    return Row(
      children: [
        Text(
          challengePrefixMessage,
          style: Theme.of(context).textTheme.headline2,
        ),
        DropdownButton(
          style: Theme.of(context).textTheme.headline2,
          value: currentlyDisplayed,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: occurrences.map((Occurrences currentItem) {
            return DropdownMenuItem(
              value: currentItem,
              child: Text(OccurrencesTransformer.toUiFormat(
                  OccurrencesTransformer.transformToString(currentItem))),
            );
          }).toList(),
          onChanged: (Occurrences newValue) {
            setState(() {
              currentlyDisplayed = newValue;
              changeDisplayedChallenges(currentlyDisplayed);
            });
          },
        ),
        Text(
          challengePostfixMessage,
          style: Theme.of(context).textTheme.headline2,
        )
      ],
    );
  }

  Widget _getSlidableCustomChallengeCard(ChallengeModel challenge, int index) {
    // add key for updating
    GlobalKey<ChallengeCardState> cardKey = GlobalKey();
    _keys.add(cardKey);

    // remember the card for clear and adding again
    ChallengeCard challengeCard = new ChallengeCard(cardKey, challenge, 100.0);
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

  Future<List<ChallengeModel>> getUserChallenges() async {
    return await widget.userManager.getAssignChallenges();
  }

  Widget _title() {
    return Container(
      color: Theme.of(context).primaryColor ,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 50, left: 16, bottom: 30),
      child: new Text(
        getUserGreeting(),
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.headline1.fontSize
        ),
      ),
    );
  }

  String getUserGreeting() =>  "Good day, \n" + widget.userManager.username;
}

class CardCustomSlidableAction extends StatefulWidget {
  final occurrences = [
    OccurrencesTransformer.transformToString(Occurrences.DAY),
    OccurrencesTransformer.transformToString(Occurrences.WEEK),
    OccurrencesTransformer.transformToString(Occurrences.MONTH)
  ];

  final UserManager userManager;

  int index;

  ChallengeModel challenge;

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


