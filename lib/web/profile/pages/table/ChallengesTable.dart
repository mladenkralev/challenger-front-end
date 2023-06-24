// import 'package:challenger/shared/model/AssignedChallenges.dart';
// import 'package:challenger/shared/model/UserManager.dart';
// import 'package:challenger/shared/time/OccurrencesTransformer.dart';
// import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class ChallengesTable extends StatelessWidget {
//
//   UserManager userManager;
//
//   ChallengesTable(UserManager userManager) {
//    this.userManager = userManager;
//   }
//
//   factory ChallengesTable.withSampleData(UserManager userManager) {
//     return new ChallengesTable(userManager);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DataTable2(
//         columnSpacing: 12,
//         horizontalMargin: 12,
//         minWidth: 600,
//         border: TableBorder(
//           // borderRadius: const BorderRadius.all(Radius.circular(12)),
//         ),
//         columns: [
//           DataColumn2(
//             label: Text('Title'),
//             size: ColumnSize.M,
//           ),
//           DataColumn(
//             label: Text('Description'),
//           ),
//           DataColumn(
//             label: Text('Occurrences'),
//           ),
//           DataColumn(
//             label: Text('Start date'),
//           ),
//           DataColumn(
//             label: Text('End date'),
//           ),
//         ],
//         rows: _getData()
//     );
//   }
//
//   List<DataRow> _getData() {
//     List<DataRow> data = List.empty(growable: true);
//     for(AssignedChallenges challenges in userManager.getAssignChallenges()) {
//       List<DataCell> dataCells = List.empty(growable: true);
//       dataCells.add(DataCell(Text(challenges.challengeModel.title)));
//       dataCells.add(DataCell(Text(challenges.challengeModel.description)));
//       dataCells.add(DataCell(Text(OccurrencesTransformer.transformToString(challenges.challengeModel.occurrences))));
//       dataCells.add(DataCell(Text(challenges.startDate.toString())));
//       dataCells.add(DataCell(Text(challenges.endDate.toString())));
//       data.add(DataRow(cells: dataCells));
//     }
//     return data;
//   }
//
//   static DateTime parseDate(String date) {
//     DateFormat format = DateFormat("yyyy-MM-dd");
//     return format.parse(date);
//   }
// }
//
//
