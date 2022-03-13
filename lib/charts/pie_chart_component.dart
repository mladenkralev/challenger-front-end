import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/time/occurrences.dart';
import 'package:challenger/user/user.dart';
import 'package:challenger/user/user_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class ChallengesDonut extends StatefulWidget {
  UserManager user;

  ChallengesDonut(this.user);

  @override
  State<StatefulWidget> createState() => PieChart2State(this.user);
}

class PieChart2State extends State {
  int touchedIndex;

  UserManager user;

  PieChart2State(this.user);

  static const primaryColor = Colors.redAccent;
  static const secondaryColor = Colors.blueAccent;
  static const thirdlyColor = Colors.greenAccent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 150,
                        child: PieChart(
                          PieChartData(
                              pieTouchData: PieTouchData(
                                  touchCallback: (pieTouchResponse) {
                                    setState(() {
                                      if (pieTouchResponse.touchInput
                                      is FlLongPressEnd ||
                                          pieTouchResponse.touchInput
                                          is FlPanEnd) {
                                        touchedIndex = -1;
                                      } else {
                                        touchedIndex = pieTouchResponse
                                            .touchedSectionIndex;
                                      }
                                    });
                                  }),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 10,
                              sections: showingSections(user.getAssignChallenges())),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Indicator(
                        color: primaryColor,
                        text: 'Daily',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(
                        color: secondaryColor,
                        text: 'Weekly',
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Indicator(
                        color: thirdlyColor,
                        text: 'Monthly',
                        isSquare: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      List<Challenge> userChallenges) {
    List<Challenge> challenges = userChallenges;

    int allChallenges = challenges.length;

    double dailyPercentage = (challenges
                .where((element) => element.occurrences == Occurrences.DAY)
                .length /
            allChallenges) *
        100;
    double weeklyPercentage = (challenges
                .where((element) => element.occurrences == Occurrences.WEEK)
                .length /
            allChallenges) *
        100;
    double monthPercentage = (challenges
                .where((element) => element.occurrences == Occurrences.MONTH)
                .length /
            allChallenges) *
        100;

    return List.generate(Occurrences.values.length, (index) {
      switch (index) {
        case 0:
          return buildDataSection(primaryColor, index, this, dailyPercentage);
        case 1:
          return buildDataSection(
              secondaryColor, index, this, weeklyPercentage);
        case 2:
          return buildDataSection(thirdlyColor, index, this, monthPercentage);
        default:
          return buildDataSection(primaryColor, index, this, 0);
      }
    });
  }
}

PieChartSectionData buildDataSection(Color primaryColor, int index,
    PieChart2State thisWidget, double percentage) {
  final isTouched = index == thisWidget.touchedIndex;

  final double fontSize = isTouched ? 25 : 16;
  final double radius = isTouched ? 50 : 40;

  int roundedValue = percentage.round();

  return PieChartSectionData(
    color: primaryColor,
    value: roundedValue.toDouble(),
    title: "$roundedValue%",
    radius: radius,
    titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: const Color(0xffffffff)),
  );
}
