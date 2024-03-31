import 'dart:math';

import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/services/AssignedChallengeService.dart';
import 'package:challenger/shared/services/TagColorRelationService.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../time/TagTransformer.dart';
import 'Indicator.dart';

class PieChartSample extends StatefulWidget {
  const PieChartSample();

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  final tagColorRelationService = locator<TagColorRelationService>();
  final challengeService = locator<AssignedChallengeService>();
  final userManager = locator<UserManagerService>();

  @override
  Widget build(BuildContext context) {
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

    List<Widget> tagWidgets = Tag.values.map((Tag tag) {
      // Get the color for this tag
      Color colorForTag = tagColorRelationService.getColorForTag(tag);

      // Build and return the widget for this tag
      return buildLegendElement(colorForTag, TagTransformer.toShortString(tag));
    }).toList();

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Center(
                // Centers the column
                child: Padding(
                  padding: EdgeInsets.only(top: dynamicPadding),
                  // Add padding at the top
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // Ensures the column takes up minimal vertical space
                    children: <Widget>[
                      Text(
                        "Daily Summary",
                        style: TextStyle(
                          color: WebGlobalConstants.hardBlack,
                          // Your chosen text color
                          fontWeight: FontWeight.bold,
                          // Make text bold
                          fontSize:
                              20, // Increase font size or adjust as needed
                        ),
                      ),
                      Text(
                        DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                        style: TextStyle(
                          color: WebGlobalConstants.hardBlack,
                          // Your chosen text color
                          fontSize: 16, // Adjust font size as needed
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: StreamBuilder<List<AssignedChallenges>>(
                stream: getShownChallenges(),
                builder: (context, snapshot) {
                    if (snapshot.hasData) {
                    // Call a method to generate pie chart sections from the list of challenges
                    List<PieChartSectionData> sections =
                        createSectionsFromChallenges(snapshot.data!);

                    if(sections.isEmpty) {
                      return Text(
                        "All set for today!",
                        style: TextStyle(
                          color: WebGlobalConstants.hardBlack,
                          // Your chosen text color
                          fontSize: 16, // Adjust font size as needed
                        ),
                      );
                    }

                    return PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 100,
                        sections: sections,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // Handle error state
                    return Text('Error loading data');
                  }
                  // Handle loading state
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
          Expanded(
              child: Container(
            child: Wrap(
              spacing: 8.0, // horizontal space between children
              runSpacing: 8.0, // vertical space between lines
              children: tagWidgets,
            ),
          ))
        ]); // Add some space at the bottom (optional)
  }

  Widget buildLegendElement(Color color, String text) {
    return Indicator(
      color: color, // Replace with your color
      text: text,
      isSquare: true,
    );
  }

  List<PieChartSectionData> createSectionsFromChallenges(List<AssignedChallenges> challenges) {
    // You would replace this logic with whatever suits your application
    // For demonstration, let's assume each challenge has a `type` property and you are counting them by type
    Map<Tag, int> typeCounts = {};
    for (AssignedChallenges challenge in challenges) {
      List<Tag>? badges = challenge.challengeModel!.badges;
      for(Tag singleTag in badges!) {
        typeCounts[singleTag] = (typeCounts[singleTag] ?? 0) + 1;
      }
    }

    var sortedByValueMap = Map.fromEntries(
        typeCounts.entries.toList()
          ..sort((e1, e2) {
            // Primary comparison by value
            int primary = e1.value.compareTo(e2.value);
            if (primary != 0) return primary;
            // Secondary comparison by the enum index or name if values are equal
            return e1.key.toString().compareTo(e2.key.toString());
          })
    );
    print("TYPES "  + sortedByValueMap.toString());

    // Now create a list of PieChartSectionData from typeCounts
    List<PieChartSectionData> sections = [];
    int i = 0;
    sortedByValueMap.forEach((type, count) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = tagColorRelationService.getColorForTag(type); // Assuming you have a color for each tag

      sections.add(PieChartSectionData(
        color: color,
        value: count.toDouble(), // Assuming the count is the value you want to represent in the chart
        title: '$count%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      ));

      i++; // Increment the index for the next challenge
    });

    return sections;
  }

  Stream<List<AssignedChallenges>>? getShownChallenges() {
    return challengeService.getUserChallenges();
  }
}
