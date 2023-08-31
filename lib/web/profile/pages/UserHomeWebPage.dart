import 'dart:math';

import 'package:calendar_view/calendar_view.dart';
import 'package:challenger/shared/card/HomeCardChallenge.dart';
import 'package:challenger/shared/chart/CompletedChallengesChart.dart';
import 'package:challenger/shared/chart/DummyGraphsForCards.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/model/HistoryChallenges.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:challenger/web/profile/AssignedChallenges.dart';
import 'package:challenger/web/profile/ProfilePage.dart';
import 'package:challenger/web/profile/pages/BrowseChallengePage.dart';
import 'package:challenger/web/profile/pages/ChallengeTree.dart';
import 'package:confetti/confetti.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../DependencyInjection.dart';
import '../../../shared/services/ChallengeService.dart';
import '../../../shared/services/HistoryChallengeService.dart';
import 'AssignedChallengesPage.dart';

class UserHomeWebPage extends StatefulWidget {
  final UserManagerService userManager;

  BuildContext context;

  UserHomeWebPage(this.userManager, this.context);

  @override
  _UserHomeWebPageState createState() => _UserHomeWebPageState();
}

class _UserHomeWebPageState extends State<UserHomeWebPage> {
  final challengeService = locator<ChallengeService>();

  final historyChallengeService = locator<HistoryChallengeService>();

  late ConfettiController _controllerCenterRight;
  late ConfettiController _controllerCenterLeft;

  String challengePrefixMessage = "Your ";
  String challengePostfixMessage = " challenges progress";

  Occurrences currentlyDisplayed = Occurrences.DAY;

  var listView;

  final occurrences = [Occurrences.DAY, Occurrences.WEEK, Occurrences.MONTH];

  List<AssignedChallenges> shownChallenges = List.empty(growable: true);
  List<HomeCardChallenge> shownCards1 = List.empty(growable: true);
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
    double taskbarHeight = MediaQuery.of(context).size.height * 0.05;

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
                  color: Colors.red,
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
                          _buildCard(context, "Assigned challenges",
                              Icon(Icons.assignment_outlined)),
                          _buildCard(context, "Completed challenges",
                              Icon(Icons.done_all_outlined)),
                          _buildCard(context, "New challenges",
                              Icon(Icons.new_label_outlined)),
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
                        Radius.circular(_roundingRadius), // Rounding value here
                      ),
                    ),
                    child: _buildCalendar(context)))),
      ]))
    ]);
  }

  Widget _buildCalendar(BuildContext context) {
    double cardsSizeHeight = MediaQuery.of(context).size.height * 0.5;
    double cardsSizeWidth = MediaQuery.of(context).size.width * 0.5 * 0.85;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: cardsSizeWidth,
        height: cardsSizeHeight,
        color: Colors.indigo,
        child: Padding(
          padding: EdgeInsets.all(_padding),
          child: Container(
            child: Center(
                child: CalendarControllerProvider(
                    controller: EventController(),
                    child: MonthView(
                      controller: EventController(),
                      // to provide custom UI for month cells.
                      cellBuilder: (date, events, isToday, isInMonth) {
                        // Return your widget to display as month cell.
                        if (isToday) {
                          return Container(
                            color: Colors.blueAccent,
                          );
                        }
                        if (!isInMonth) {
                          return Container(
                            color: Colors.white24,
                          );
                        }
                        return Container();
                      },
                      headerBuilder: (date) {
                        return Container(
                          color: Colors.redAccent,
                        );
                      },
                      minMonth: DateTime(1990),
                      maxMonth: DateTime(2050),
                      initialMonth: DateTime.now(),
                      width: cardsSizeWidth,
                      cellAspectRatio: 3,
                      onPageChange: (date, pageIndex) =>
                          print("$date, $pageIndex"),
                      onCellTap: (events, date) {
                        // Implement callback when user taps on a cell.
                        print(events);
                      },
                      startDay: WeekDays.sunday,
                      // To change the first day of the week.
                      // This callback will only work if cellBuilder is null.
                      onEventTap: (event, date) => print(event),
                      onDateLongPress: (date) => print(date),
                    ))),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, Icon icon) {
    double cardsSizeHeight = MediaQuery.of(context).size.height * 0.5 * 0.5;
    double cardsSizeWidth = MediaQuery.of(context).size.width * 0.6 * 0.3;
    print("sizeee " +
        cardsSizeHeight.toString() +
        " and " +
        cardsSizeWidth.toString());

    final double _paddingText = 4.0;
    final double _paddingRightText = 4.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          // Navigate to the desired page
          Get.to(
            AssignedChallengesRoot(),
            transition: Transition.zoom,
          );
        },
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius:
                const BorderRadius.all(Radius.circular(_roundingRadius)),
          ),
          child: Column(
            children: [
              // Allocate fixed space for Text
              Row(children: [
                SizedBox(
                  width: cardsSizeWidth,
                  height: cardsSizeHeight,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: icon,
                        ),
                        title: Text(title),
                        subtitle: Text(DateTime.now().toString()),
                        trailing: StreamBuilder<List<AssignedChallenges>>(
                          stream: getShownChallenges(),
                          // Call the function that fetches the data
                          builder: (ctx, snapshot) {
                            return _assignedChallengesLength(ctx, snapshot);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                          color: Colors.black26,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: cardsSizeWidth * 0.7,
                              height: cardsSizeHeight / 2,
                              child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      _paddingText, 0, 8, _padding),
                                  child: DummyGraphsForCards(
                                      TypeOfGraph.REGRESSIVE))),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            // align text to the left
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Text(
                                    "10% more",
                                    style: TextStyle(
                                        fontSize: WebGlobalConstants.h1Size),
                                  )),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                child: Text(
                                  "from last week",
                                  style: TextStyle(
                                      fontSize: WebGlobalConstants.h1Size),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

  changeDisplayedChallenges(Occurrences selectedOccurrenceType) {
    currentlyDisplayed = selectedOccurrenceType;
    shownChallenges.clear();
    shownChallenges.addAll(
        allChallenges[selectedOccurrenceType] as Iterable<AssignedChallenges>);
    // listView = _buildViewableList();
  }

  Future<List<AssignedChallenges>?> getUserChallenges() async {
    return await widget.userManager.getAssignChallenges();
  }

  Stream<List<HistoryChallenge>>? getHistoryChallenges() {
    this.historyChallenges =
        historyChallengeService.fetchHistoryData().asBroadcastStream();
    return historyChallenges?.asBroadcastStream();
  }

  Stream<List<AssignedChallenges>>? getShownChallenges() {
    return challengeService.getUserChallenges(widget.userManager.user!.token);
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
                '${snapshot.data?[index].assignedChallenges?.challengeModel?.title}'),
            subtitle: Text('${snapshot.data?[index].progressDate}'),
          ),
        );
      },
    );
  }

  Widget _assignedChallengesLength(
      BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
        child: Text(
          '${snapshot.data!.length}',
          style: TextStyle(fontSize: WebGlobalConstants.titleSize),
        ),
      );
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    return CircularProgressIndicator();
  }
}
