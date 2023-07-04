import 'package:challenger/shared/card/HomeCardChallenge.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/model/HistoryChallenges.dart';
import 'package:challenger/shared/model/UserManager.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';
import 'package:flutter/material.dart';

import '../../../DependencyInjection.dart';
import '../../../shared/services/ChallengeService.dart';
import '../../../shared/services/HistoryChallengeService.dart';

class UserHomeWebPage extends StatefulWidget {
  final UserManager userManager;

  BuildContext context;

  UserHomeWebPage(this.userManager, this.context);

  @override
  _UserHomeWebPageState createState() => _UserHomeWebPageState();
}

class _UserHomeWebPageState extends State<UserHomeWebPage> {
  final challengeService = locator<ChallengeService>();

  final historyChallengeService = locator<HistoryChallengeService>();

  final List<Key> _keys1 = List.empty(growable: true);

  String challengePrefixMessage = "Your ";
  String challengePostfixMessage = " challenges progress";

  Occurrences currentlyDisplayed = Occurrences.DAY;

  var listView;

  final occurrences = [Occurrences.DAY, Occurrences.WEEK, Occurrences.MONTH];

  List<AssignedChallenges> shownChallenges = List.empty(growable: true);
  List<HomeCardChallenge> shownCards1 = List.empty(growable: true);
  Map<Occurrences, List<AssignedChallenges>> allChallenges = {};

  Stream<List<HistoryChallenge>>? historyChallenges;

  Function(AssignedChallenges, Key)? notifyParent;

  @override
  void initState() {
    allChallenges.putIfAbsent(
        Occurrences.DAY, () => widget.userManager.getDailyAssignChallenges()!);
    allChallenges.putIfAbsent(Occurrences.WEEK,
        () => widget.userManager.getWeeklyAssignChallenges()!);
    allChallenges.putIfAbsent(Occurrences.MONTH,
        () => widget.userManager.getMonthlyAssignChallenges()!);

    shownChallenges.clear();
    shownChallenges
        .addAll(allChallenges[Occurrences.DAY] as Iterable<AssignedChallenges>);
  }

  @override
  Widget build(BuildContext context) {
    return _getChallengesNew();
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
            child: StreamBuilder<List<HistoryChallenge>>(
          stream: getHistoryChallenges(),
          // Call the function that fetches the data
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loading indicator while fetching the data
            } else if (snapshot.hasError) {
              return Text(
                  'Error: ${snapshot.error}'); // Show an error message if there's an error
            } else {
              // Use the fetched data to populate the ListView
              return ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(12.0),
                itemCount: snapshot.data?.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.check),
                      ),
                      title: Text(
                          '${snapshot.data?[index].assignedChallenges?.challengeModel?.title}'),
                      subtitle: Text('${snapshot.data?[index].progressDate}'),
                    ),
                  );
                },
              );
            }
          },
        )),
      ],
    );
  }

  changeDisplayedChallenges(Occurrences selectedOccurrenceType) {
    currentlyDisplayed = selectedOccurrenceType;
    shownChallenges.clear();
    _keys1.clear();
    shownChallenges.addAll(
        allChallenges[selectedOccurrenceType] as Iterable<AssignedChallenges>);
    // listView = _buildViewableList();
  }

  Widget _getCard(AssignedChallenges challenge, int index) {
    // add key for updating
    Key cardKey = new Key(index.toString());
    _keys1.add(cardKey);

    // remember the card for clear and adding again
    HomeCardChallenge challengeCard = new HomeCardChallenge(
        _keys1, cardKey, challenge, this.removeExistingChallenge);
    shownCards1.add(challengeCard);

    // wrap with slidable
    return challengeCard;
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

  // REMOVING FROM LIST
  removeExistingChallenge(AssignedChallenges existingChallenge, Key key) {
    setState(() {
      AssignedChallenges? firstWhere = widget.userManager
          .getAssignChallenges()
          ?.firstWhere((element) => existingChallenge.id == element.id);
      challengeService.upgradeProgressOfChallenge(firstWhere?.id);
      getHistoryChallenges();
      _keys1.remove(key);
      shownChallenges.remove(existingChallenge);
      widget.userManager?.abandonChallenge(existingChallenge);
    });
  }

  Stream<List<HistoryChallenge>>? getHistoryChallenges() {
    this.historyChallenges = historyChallengeService.fetchHistoryData();
    return historyChallenges;
  }
}
