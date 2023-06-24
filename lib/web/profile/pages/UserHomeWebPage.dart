import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/card/ChallengeCard.dart';
import 'package:challenger/shared/card/HomeCardChallenge.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/model/UserManager.dart';
import 'package:challenger/shared/model/UserModel.dart';
import 'package:challenger/shared/services/ChallengeService.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';
import 'package:challenger/web/WebGlobalConstants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class UserHomeWebPage extends StatefulWidget {
  final UserManager userManager;

  BuildContext context;

  UserHomeWebPage(this.userManager, this.context);

  @override
  _UserHomeWebPageState createState() => _UserHomeWebPageState();
}

class _UserHomeWebPageState extends State<UserHomeWebPage> {
  final List<GlobalKey<ChallengeCardState>> _keys = List.empty(growable: true);
  final List<GlobalKey<HomeCardChallengeState>> _keys1 =
      List.empty(growable: true);

  String challengePrefixMessage = "Your ";
  String challengePostfixMessage = " challenges progress";

  Occurrences currentlyDisplayed = Occurrences.DAY;

  var listView;

  final occurrences = [Occurrences.DAY, Occurrences.WEEK, Occurrences.MONTH];

  List<AssignedChallenges> shownChallenges = List.empty(growable: true);
  List<ChallengeCard> shownCards = List.empty(growable: true);
  List<HomeCardChallenge> shownCards1 = List.empty(growable: true);
  Map<Occurrences, List<AssignedChallenges>> allChallenges = {};

  @override
  void initState() {
    allChallenges.putIfAbsent(
        Occurrences.DAY, () => widget.userManager.getDailyAssignChallenges()!);
    allChallenges.putIfAbsent(
        Occurrences.WEEK, () => widget.userManager.getWeeklyAssignChallenges()!);
    allChallenges.putIfAbsent(Occurrences.MONTH,
        () => widget.userManager.getMonthlyAssignChallenges()!);

    shownChallenges.clear();
    shownChallenges
        .addAll(allChallenges[Occurrences.DAY] as Iterable<AssignedChallenges>);
  }

  @override
  Widget build(BuildContext context) {
    return _getChallengesNew();

    // SingleChildScrollView(
    //   physics: ScrollPhysics(),
    //   child: Column(
    //       // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         // _title(),
    //         //_getChallengesNew()
    //       ]
    //   ));
  }

  Widget _getChallengesNew() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DropdownButton(
          style: Theme.of(context).textTheme.headline4,
          value: currentlyDisplayed,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: occurrences.map((Occurrences currentItem) {
            return DropdownMenuItem(
              value: currentItem,
              child: Text(
                OccurrencesTransformer.toUiFormat(
                    OccurrencesTransformer.transformToString(currentItem)),
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }).toList(),
          onChanged: (Occurrences? value) {
            setState(() {
              currentlyDisplayed = value!;
              changeDisplayedChallenges(currentlyDisplayed);
            });
          },
        ),
        Container(
          height: 300,
          child: Container(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: shownChallenges.length,
                itemBuilder: (context, index) {
                  final AssignedChallenges challenge = shownChallenges[index];
                  return _getCard(challenge, index);
                }),
          ),
        ),
        Text(
          'Demo Headline 2',
          style: TextStyle(fontSize: 18),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(12.0),
            itemBuilder: (ctx, int) {
              return Card(
                child: ListTile(
                    title: Text('Motivation $int'),
                    subtitle: Text('this is a description of the motivation')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getChallenges() {
    listView = _buildViewableList();
    return Container(
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
              alignment: Alignment.topLeft,
              child: _challengeMessage()),
          listView
        ],
      ),
    );
  }

  Widget _buildViewableList() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: shownChallenges.length,
        itemBuilder: (context, index) {
          final AssignedChallenges challenge = shownChallenges[index];
          return _getSlidableCustomChallengeCard(challenge, index);
        });
  }

  changeDisplayedChallenges(Occurrences selectedOccurrenceType) {
    currentlyDisplayed = selectedOccurrenceType;
    shownChallenges.clear();
    shownCards.clear();
    _keys.clear();
    shownChallenges.addAll(
        allChallenges[selectedOccurrenceType] as Iterable<AssignedChallenges>);
    listView = _buildViewableList();
  }

  Widget _challengeMessage() {
    return Row(
      children: [
        Text(
          challengePrefixMessage,
          style: Theme.of(context).textTheme.headline6,
        ),
        DropdownButton(
          style: Theme.of(context).textTheme.headline4,
          value: currentlyDisplayed,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: occurrences.map((Occurrences currentItem) {
            return DropdownMenuItem(
              value: currentItem,
              child: Text(
                OccurrencesTransformer.toUiFormat(
                    OccurrencesTransformer.transformToString(currentItem)),
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }).toList(),
          onChanged: (Occurrences? value) {
            setState(() {
              currentlyDisplayed = value!;
              changeDisplayedChallenges(currentlyDisplayed);
            });
          },
        ),
        Text(
          challengePostfixMessage,
          style: Theme.of(context).textTheme.headline4,
        )
      ],
    );
  }

  Widget _getCard(AssignedChallenges challenge, int index) {
    // add key for updating
    GlobalKey<HomeCardChallengeState> cardKey = GlobalKey();
    _keys1.add(cardKey);

    // remember the card for clear and adding again
    HomeCardChallenge challengeCard = new HomeCardChallenge(cardKey, challenge);
    shownCards1.add(challengeCard);

    // wrap with slidable
    return challengeCard;
  }

  Widget _getSlidableCustomChallengeCard(
      AssignedChallenges challenge, int index) {
    // add key for updating
    GlobalKey<ChallengeCardState> cardKey = GlobalKey();
    _keys.add(cardKey);

    // remember the card for clear and adding again
    ChallengeCard challengeCard = new ChallengeCard(cardKey, challenge, 200);
    shownCards.add(challengeCard);

    // wrap with slidable
    return Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            CardCustomSlidableAction(
              cardKey: cardKey,
              challenge: challenge,
              userManager: widget.userManager,
              index: index,
              key: new GlobalKey(),
            ),
          ],
        ),
        child: challengeCard);
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

  Future<List<AssignedChallenges>?> getUserChallenges() async {
    return await widget.userManager.getAssignChallenges();
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

  AssignedChallenges challenge;

  GlobalKey<ChallengeCardState> cardKey;

  CardCustomSlidableAction(
      {required this.cardKey,
      required Key key,
      required this.challenge,
      required this.userManager,
      required this.index})
      : super(key: key);

  @override
  State<CardCustomSlidableAction> createState() =>
      _CardCustonSlidableActionState();
}

class _CardCustonSlidableActionState extends State<CardCustomSlidableAction> {
  final ChallengeService challengeService = locator<ChallengeService>();

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      backgroundColor: Color(0xFFF9F6F4),
      autoClose: true,
      onPressed: (BuildContext context) {
        challengeService.upgradeProgressOfChallenge(
            widget.userManager, widget.challenge.id!);
        AssignedChallenges? firstWhere = widget.userManager
            .getAssignChallenges()
            ?.firstWhereOrNull((element) => widget.challenge.id == element.id);

        if (firstWhere != null) {
          double pace = 100 / firstWhere.maxProgress!;
          double challengeProgress =
              pace * (firstWhere.maxProgress! - firstWhere.currentProgress!);
          if (firstWhere.isCompleted!) {
            widget.cardKey.currentState?.updateChallengeProgress(100);
          } else {
            widget.cardKey.currentState
                ?.updateChallengeProgress(challengeProgress + pace);
          }
        }
      }
      ,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          color: Color(0xFFFE4A49),
        ),
        child: Center(
          child: IconButton(
            iconSize: 30,
            icon: const Icon(Icons.done),
            onPressed: () {
              //?? TODO
            },
          ),
        ),
      ),
    );
  }
}
