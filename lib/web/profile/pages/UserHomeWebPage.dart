import 'dart:math';

import 'package:challenger/shared/card/SummaryHomePageCard.dart';
import 'package:challenger/shared/card/assigned/AssignedCard.dart';
import 'package:challenger/shared/chart/CompletedChallengesChart.dart';
import 'package:challenger/shared/chart/PieChartSample.dart';
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../DependencyInjection.dart';
import '../../../shared/services/HistoryChallengeService.dart';
import '../AssignedChallengesRoot.dart';

class UserHomeWebPage extends StatefulWidget {
  final UserManagerService userManager;

  BuildContext context;

  UserHomeWebPage(this.userManager, this.context);

  bool isFirstDependencyChange = true;

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

  final occurrences = [Occurrences.DAY, Occurrences.WEEK, Occurrences.MONTH];

  final double _padding = 16.0;
  static const double _roundingRadius = 12;

  List<AssignedChallenges> shownChallenges = List.empty(growable: true);
  List<AssignedCard> shownCards1 = List.empty(growable: true);
  Map<Occurrences, List<AssignedChallenges>> allChallenges = {};

  Stream<List<HistoryChallenge>>? historyChallenges;

  @override
  void initState() {
    challengeService.activateWebSocketConnection();
    historyChallengeService.activateWebSocketConnection();

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
    const phoneBreakpoint = 600;
    const tabletBreakpoint = 900;

    double screnWidth = MediaQuery.of(context).size.width;

    bool isPhone = screnWidth < phoneBreakpoint;
    bool isTablet =
        screnWidth >= phoneBreakpoint && screnWidth < tabletBreakpoint;
    bool isDesktop = screnWidth >= tabletBreakpoint;

    // Use the boolean values to decide which widget to return
    if (isPhone) {
      return _phoneHome();
    } else if (isTablet) {
      // Assuming you have a method for tablet layout
      return _tabletHome();
    } else if (isDesktop) {
      return _webHome();
    }

    // Default to web home if none of the above conditions are met
    // This is just a safety net; ideally, one of the conditions should always be true
    return _webHome();
  }

  Widget _phoneHome() {
    double cardsSizeHeight = MediaQuery.of(context).size.height * 0.5 * 0.5;
    double cardsSizeWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCard(
              Colors.red,
              'Balloon 1',
              cardsSizeHeight,
              SummaryHomePageCard(
                  "Assigned challenges",
                  Icon(Icons.assignment_outlined),
                  goToPageAssigned,
                  getAssignedChallenges(),
                  cardsSizeHeight,
                  cardsSizeWidth)),
          _buildCard(
              Colors.blue,
              'Balloon 2',
              cardsSizeHeight,
              SummaryHomePageCard(
                  "Completed challenges",
                  Icon(Icons.done_all_outlined),
                  goToPageCompleted,
                  getHistoryChallenges(),
                  cardsSizeHeight,
                  cardsSizeWidth)),
          _buildCard(
              Colors.green,
              'Balloon 3',
              cardsSizeHeight,
              SummaryHomePageCard(
                  "New challenges",
                  Icon(Icons.new_label_outlined),
                  goToPageBrowse,
                  getBrowseChallenges(),
                  cardsSizeHeight,
                  cardsSizeWidth))
        ],
      ),
    );
  }

  Widget _tabletHome() {
    return new Text("Hello");
  }

  Widget _buildCard(
      Color color, String text, double cardsSizeHeight, Widget innerWidget) {
    return Card(
      // color: color,
      margin: EdgeInsets.all(8.0),
      elevation: 8.0, // Adjust the elevation to control the shadow's prominence
      child: Container(
          height: cardsSizeHeight,
          alignment: Alignment.center,
          child: innerWidget),
    );
  }

  Widget _webHome() {
    double taskbarHeight = MediaQuery.of(context).size.height * 0.05;

    double cardsSizeHeight = MediaQuery.of(context).size.height * 0.5 * 0.5;
    double cardsSizeWidth = MediaQuery.of(context).size.width * 0.6 * 0.3;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    const double baseScreenWidth = 1024.0;
    const double maxScaleFactor = 1.5; // Adjust this value as needed
    const double baseTextSize = 20.0;

    double scale = min(screenWidth / baseScreenWidth, maxScaleFactor);

    double dynamicPadding =
        max(24.0 * scale, 8.0); // Ensures padding is not less than 8.0
    double dynamicTextSize = max(
        baseTextSize * scale, 12.0); // Ensures text size is not less than 12.0

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SummaryHomePageCard(
                              "Assigned challenges",
                              Icon(Icons.assignment_outlined),
                              goToPageAssigned,
                              getAssignedChallenges(),
                              cardsSizeHeight,
                              cardsSizeWidth),
                          SummaryHomePageCard(
                              "Completed challenges",
                              Icon(Icons.done_all_outlined),
                              goToPageCompleted,
                              getHistoryChallenges(),
                              cardsSizeHeight,
                              cardsSizeWidth),
                          SummaryHomePageCard(
                              "New challenges",
                              Icon(Icons.new_label_outlined),
                              goToPageBrowse,
                              getBrowseChallenges(),
                              cardsSizeHeight,
                              cardsSizeWidth),
                        ],
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
                  decoration: BoxDecoration(
                    color: WebGlobalConstants.primaryColor, // Background color
                    borderRadius: BorderRadius.all(
                      Radius.circular(_roundingRadius), // Rounding value here
                    ),
                  ),
                  child: Center(
                      child: Container(
                    decoration: BoxDecoration(
                      color: WebGlobalConstants.primaryColor,
                      // Background color
                      borderRadius: BorderRadius.all(
                        Radius.circular(_roundingRadius), // Rounding value here
                      ),
                    ),
                    child: StreamBuilder<List<HistoryChallenge>>(
                      stream: getHistoryChallenges(),
                      // Call the function that fetches the data
                      builder: (ctx, snapshot) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Aligns children to the start of the cross axis
                            children: [
                              _historyBuilder(ctx, snapshot),
                            ]);
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
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(_padding),
            child: Container(
              decoration: BoxDecoration(
                color: WebGlobalConstants.primaryColor, // Background color
                borderRadius: BorderRadius.all(
                  Radius.circular(_roundingRadius), // Rounding value here
                ),
              ),
              child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: dynamicPadding, bottom: dynamicPadding),
                      // Adjust padding as needed
                      child: Column(
                        children: [
                          Text(
                            'Weekly history summary',
                            // Replace with your actual title
                            style: TextStyle(
                              color: WebGlobalConstants.hardBlack,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  20, // Increase font size or adjust as needed
                            ),
                            textAlign: TextAlign.center, // Center the title
                          ),
                          Text(
                            formatDateRange(DateTime.now()),
                            style: TextStyle(
                              color: WebGlobalConstants.hardBlack,
                              // Your chosen text color
                              fontSize: 16, // Adjust font size as needed
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: StackedAreaCustomColorLineChart())
                  ])),
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(_padding),
          child: Container(
              decoration: BoxDecoration(
                color: WebGlobalConstants.primaryColor,
                // Background color
                borderRadius: BorderRadius.all(
                  Radius.circular(_roundingRadius), // Rounding value here
                ),
              ),
              child: PieChartSample()),
        )),
      ]))
    ]);
  }

  String formatDateRange(DateTime start) {
    final DateFormat formatter = DateFormat('EEEE, dd MMMM');
    final String startDate = formatter.format(start);
    final String endDate = formatter.format(start.add(Duration(days: 7)));

    return "$startDate - $endDate";
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

  Stream<List<HistoryChallenge>> getHistoryChallenges() {
    return historyChallengeService.fetchHistoryData().asBroadcastStream();
  }

  Stream<List<AssignedChallenges>>? getAssignedChallenges() {
    return challengeService.getUserChallenges();
  }

  Stream<List<ChallengeModel>>? getBrowseChallenges() {
    return browseChallengeService
        .getBrowsableChallenges(widget.userManager.user!.token);
  }

  Widget _historyBuilder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}',
            style: TextStyle(fontSize: WebGlobalConstants.h1Size)),
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(
        child: Text("No history data detected",
            style: TextStyle(fontSize: WebGlobalConstants.h1Size)),
      );
    } else {
      return Flexible(
        // Use Flexible or ConstrainedBox as needed
        child: ListView.builder(
          shrinkWrap: true,
          // Important: Setting shrinkWrap to true is necessary here to allow the ListView to occupy space only for its children.
          itemCount: snapshot.data?.length,
          itemBuilder: (ctx, index) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.check)),
                title: Text(
                    '${snapshot.data?[index].assignedChallenges?.challengeModel?.title}'),
                subtitle: Text('${snapshot.data?[index].progressDate}'),
              ),
            );
          },
        ),
      );
    }
  }
}
