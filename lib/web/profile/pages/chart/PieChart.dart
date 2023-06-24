// import 'package:challenger/shared/model/UserManager.dart';
// import 'package:challenger/shared/time/OccurrencesTransformer.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:flutter/material.dart';
//
// class PieChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;
//
//   PieChart(this.seriesList, {required this.animate});
//
//   /// Creates a [PieChart] with sample data and no transition.
//   factory PieChart.withSampleData(UserManager userManager) {
//     return new PieChart(
//       _createSampleData(userManager),
//       // Disable animations for image tests.
//       animate: true,
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return new charts.PieChart(
//       seriesList,
//       animate: animate,
//       behaviors: [
//         new charts.DatumLegend(
//
//           position: charts.BehaviorPosition.end,
//           horizontalFirst: false,
//           cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
//           showMeasures: true,
//           legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
//           measureFormatter: (num value) {
//             return value == null ? '-' : '${value} challenges';
//           },
//         ),
//       ],
//     );
//   }
//
//   /// Create series list with one series
//   static List<charts.Series<ChallengesPerCategory, String>> _createSampleData(UserManager userManager) {
//     final data = [
//       new ChallengesPerCategory(Occurrences.WEEK, userManager.getWeeklyAssignChallenges().length),
//       new ChallengesPerCategory(Occurrences.DAY, userManager.getDailyAssignChallenges().length),
//       new ChallengesPerCategory(Occurrences.MONTH, userManager.getMonthlyAssignChallenges().length),
//     ];
//
//     return [
//       new charts.Series<ChallengesPerCategory, String>(
//         id: 'Sales',
//         domainFn: (ChallengesPerCategory sales, _) =>  OccurrencesTransformer.toUiFormat(OccurrencesTransformer.transformToString(sales.index)),
//         measureFn: (ChallengesPerCategory sales, _) => sales.size,
//         data: data,
//       )
//     ];
//   }
// }
//
// /// Sample linear data type.
// class ChallengesPerCategory {
//   final Occurrences index;
//   final int size;
//
//   ChallengesPerCategory(this.index, this.size);
// }