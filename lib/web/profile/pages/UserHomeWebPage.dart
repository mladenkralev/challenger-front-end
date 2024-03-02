import 'dart:math';

import 'package:challenger/shared/calendar/HomeCalendar.dart';
import 'package:challenger/shared/card/SummaryHomePageCard.dart';
import 'package:challenger/shared/card/home/AssignedCard.dart';
import 'package:challenger/shared/chart/CompletedChallengesChart.dart';
import 'package:challenger/shared/chart/DummyGraphsForCards.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/model/HistoryChallenges.dart';
import 'package:challenger/shared/services/AssignedChallengeService.dart';
import 'package:challenger/shared/services/BrowseChallengeService.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:challenger/web/profile/BrowseChallengeRoot.dart';
import 'package:challenger/web/profile/ComplatedChallengesRoot.dart';
import 'package:confetti/confetti.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../DependencyInjection.dart';
import '../../../shared/services/HistoryChallengeService.dart';
import '../AssignedChallengesRoot.dart';

class UserHomeWebPage extends StatefulWidget {
  final UserManagerService userManager;

  BuildContext context;

  UserHomeWebPage(this.userManager, this.context);

  @override
  _UserHomeWebPageState createState() => _UserHomeWebPageState();
}

class _UserHomeWebPageState extends State<UserHomeWebPage> {
  final challengeService = locator<AssignedChallengeService>();

  final historyChallengeService = locator<HistoryChallengeService>();
  final browseChallengeService = locator<BrowseChallengeService>();

  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;

  String challengePrefixMessage = "Your ";
  String challengePostfixMessage = " challenges progress";

  Occurrences currentlyDisplayed = Occurrences.DAY;

  var listView;

  final occurrences = [Occurrences.DAY, Occurrences.WEEK, Occurrences.MONTH];

  List<AssignedChallenges> shownChallenges = List.empty(growable: true);
  List<AssignedCard> shownCards1 = List.empty(growable: true);
  Map<Occurrences, List<AssignedChallenges>> allChallenges = {};

  final double _padding = 32.0;
  static const double _roundingRadius = 12;

  Stream<List<HistoryChallenge>>? historyChallenges;

  Function()? notifyParent;

  // Generate some dummy data for the cahrt
  // This will be used to draw the red line
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  // This will be used to draw the orange line
  final List<FlSpot> dummyData2 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  // This will be used to draw the blue line
  final List<FlSpot> dummyData3 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextDouble());
  });

  @override
  void initState() {
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  void dispose() {
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _getChallengesNew();
  }

  Widget _getChallengesNew() {
    double taskbarHeight = MediaQuery
        .of(context)
        .size
        .height * 0.05;

    return Column(children: <Widget>[
      // First row
      Expanded(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(_padding),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo, // Background color
                    borderRadius: BorderRadius.all(
                      Radius.circular(_roundingRadius), // Rounding value here
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [],
                      ),
                      Spacer(flex: 1),
                      // First sub-row for cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SummaryHomePageCard(
                              "Assigned challenges",
                              Icon(Icons.assignment_outlined),
                              goToPageAssigned,
                              getAssignedChallenges()
                          ),
                          SummaryHomePageCard(
                              "Completed challenges",
                              Icon(Icons.done_all_outlined),
                              goToPageCompleted,
                              getHistoryChallenges()
                          ),
                          SummaryHomePageCard(
                              "New challenges",
                              Icon(Icons.new_label_outlined),
                              goToPageBrowse,
                              getBrowseChallenges()
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: const Divider(
                          height: 20,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                          color: Colors.white24,
                        ),
                      ),
                      // Second sub-row which will occupy the remaining space
                      Container(
                        height: taskbarHeight,
                        // Adjust this height for the taskbar size
                        color: Colors.purple,
                        child: Center(child: Text('Taskbar content here')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(_padding),
                child: Container(
                  color: Colors.green,
                  child: Center(
                      child: Container(
                        alignment: Alignment.topCenter,
                        color: Colors.green,
                        child: StreamBuilder<List<HistoryChallenge>>(
                          stream: getHistoryChallenges(),
                          // Call the function that fetches the data
                          builder: (ctx, snapshot) {
                            return _historyBuilder(ctx, snapshot);
                          },
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
      // Second row
      Expanded(
          child: Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(_padding),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo, // Background color
                    borderRadius: BorderRadius.all(
                      Radius.circular(_roundingRadius), // Rounding value here
                    ),
                  ),
                  child: Container(child: CompletedChallengesChart()),
                ),
              ),
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(_padding),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo, // Background color
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                _roundingRadius), // Rounding value here
                          ),
                        ),
                        child: HomeCalendar()))),
          ]))
    ]);
  }

  Future? goToPageAssigned() {
    Future? future = Get.to(
      AssignedChallengesRoot(),
      transition: Transition.noTransition,
    );
    print('Pressed');
    return future;
  }

  Future? goToPageCompleted() {
    Future? future = Get.to(
      CompletedChallengesRoot(),
      transition: Transition.noTransition,
    );
    print('Pressed');
    return future;
  }

  Future? goToPageBrowse() {
    Future? future = Get.to(
      BrowseChallengeRoot(),
      transition: Transition.noTransition,
    );
    print('Pressed');
    return future;
  }

  changeDisplayedChallenges(Occurrences selectedOccurrenceType) {
    currentlyDisplayed = selectedOccurrenceType;
    shownChallenges.clear();
    shownChallenges.addAll(
        allChallenges[selectedOccurrenceType] as Iterable<AssignedChallenges>);
    // listView = _buildViewableList();
  }

  Stream<List<HistoryChallenge>>? getHistoryChallenges() {
    this.historyChallenges =
        historyChallengeService.fetchHistoryData().asBroadcastStream();
    return historyChallenges?.asBroadcastStream();
  }

  Stream<List<AssignedChallenges>>? getAssignedChallenges() {
    return challengeService.getUserChallenges(widget.userManager.user!.token);
  }

  Stream<List<ChallengeModel>>? getBrowseChallenges() {
    return browseChallengeService.getBrowsableChallenges(widget.userManager.user!.token);
  }

  Widget _historyBuilder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator(); // Show a loading indicator while fetching the data
    }

    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}',
            style: TextStyle(fontSize: WebGlobalConstants.h1Size)),
      ); // Show an error message if there's an error
    }

    if (snapshot.data!.isEmpty) {
      return Center(
          child: Text(
            "No history data detected",
            style: TextStyle(fontSize: WebGlobalConstants.h1Size),
          ));
    }

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
                '${snapshot.data?[index].assignedChallenges?.challengeModel
                    ?.title}'),
            subtitle: Text('${snapshot.data?[index].progressDate}'),
          ),
        );
      },
    );
  }


}
