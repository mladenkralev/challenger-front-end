import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/model/HistoryChallenges.dart';
import 'package:challenger/shared/services/AssignedChallengeService.dart';
import 'package:challenger/shared/services/HistoryChallengeService.dart';
import 'package:challenger/shared/services/TagColorRelationService.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/shared/time/TagTransformer.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

class StackedAreaCustomColorLineChart extends StatefulWidget {
  StackedAreaCustomColorLineChart({Key? key}) : super(key: key);

  @override
  _StackedAreaCustomColorLineChartState createState() =>
      _StackedAreaCustomColorLineChartState();
}

class _StackedAreaCustomColorLineChartState
    extends State<StackedAreaCustomColorLineChart> {
  late Future<List<charts.Series<LinearSales, int>>> seriesListFuture;

  final historyService = locator<HistoryChallengeService>();
  final challengeService = locator<AssignedChallengeService>();
  final userService = locator<UserManagerService>();
  final tagColorRelationService = locator<TagColorRelationService>();

  @override
  void initState() {
    super.initState();
    seriesListFuture = _createSampleData(); // Load the data
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<charts.Series<LinearSales, int>>>(
      future: seriesListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return charts.LineChart(
            snapshot.data!,
            defaultRenderer:
                charts.LineRendererConfig(includeArea: true, stacked: true),
            animate: true,
            domainAxis: new charts.NumericAxisSpec(
              tickProviderSpec:
                  new charts.BasicNumericTickProviderSpec(zeroBound: false),
              tickFormatterSpec: new charts.BasicNumericTickFormatterSpec(
                  intToWeekDay), // Pass the function reference directly
            ),
            behaviors: [
              new charts.SeriesLegend(
                position: charts.BehaviorPosition.bottom,
                cellPadding:
                    new EdgeInsets.only(right: 4.0, bottom: 8.0, top: 8.0),
              ), // This line adds a legend to your chart.
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator(); // Show a loader while data is loading
      },
    );
  }

  // This function now matches the expected signature: (num?) => String
  String intToWeekDay(num? day) {
    if (day == null) return ''; // Handle null case, just in case
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day.toInt() % 7];
  }

  Future<List<charts.Series<LinearSales, int>>> _createSampleData() async {
    // Here's where you fetch your real data.
    var resultFromFeature = await Future.wait([
      challengeService.getUserChallenges().first,
      historyService.fetchHistoryData().first
    ]).then((List responses) {
      List<AssignedChallenges> assignedData =
          responses[0] as List<AssignedChallenges>;
      List<HistoryChallenge> historyData =
          responses[1] as List<HistoryChallenge>;

      print("Challenges count: ${assignedData.length}");
      print("History count: ${historyData.length}");

      List<LinearSales> myFakeDesktopData = [];
      for (int index = 1; index < 8; index++) {
        myFakeDesktopData.add(LinearSales(index, 0, Tag.MONTHLY));
        myFakeDesktopData.add(LinearSales(index, 0, Tag.WEEKLY));
        myFakeDesktopData.add(LinearSales(index, 0, Tag.DAILY));
        myFakeDesktopData.add(LinearSales(index, 0, Tag.INTELLECT));
        myFakeDesktopData.add(LinearSales(index, 0, Tag.STRENGTH));
        myFakeDesktopData.add(LinearSales(index, 0, Tag.AGILITY));
        myFakeDesktopData.add(LinearSales(index, 0, Tag.HARD));
        myFakeDesktopData.add(LinearSales(index, 0, Tag.MEDIUM));
        myFakeDesktopData.add(LinearSales(index, 0, Tag.EASY));
      }

      historyData.forEach((element) {
        List<Tag>? badges = element.assignedChallenges!.challengeModel!.badges;
        List<Tag> sortedBadges = List.from(badges!);

        for (Tag badge in sortedBadges) {
          var weekday = element.progressDate!.weekday;
          LinearSales firstWhere = myFakeDesktopData.firstWhere(
              (element) => element.day == weekday && element.tag == badge);

          firstWhere.completedChallengesNumber++;
        }
      });

      Map<Tag, List<LinearSales>> perTag = {};
      for (LinearSales current in myFakeDesktopData) {
        Tag tag = current.tag;

        // Get the list for the current tag, or create it if it doesn't exist
        List<LinearSales> list = perTag.putIfAbsent(tag, () => []);

        list.add(current);
      }

      List<charts.Series<LinearSales, int>> result = [];
      for (var entry in perTag.entries) {
        var tag = entry.key;
        print('Tag:' + tag.toString() + ' and value: ${entry.value.length}');

        var colorForTag = tagColorRelationService.getColorForChart(tag);

        var series = charts.Series<LinearSales, int>(
            id: tag.name,
            colorFn: (_, __) => colorForTag.shadeDefault,
            areaColorFn: (_, __) => colorForTag.shadeDefault.lighter,
            domainFn: (LinearSales sales, _) => sales.day,
            measureFn: (LinearSales sales, _) =>
                sales.completedChallengesNumber,
            data: entry.value,
            displayName: tag.name);
        result.add(series);
      }
      return result;
    });

    return resultFromFeature;
  }
}

/// Sample linear data type.
class LinearSales {
  int day;
  int completedChallengesNumber;
  Tag tag;

  LinearSales(this.day, this.completedChallengesNumber, this.tag);
}
