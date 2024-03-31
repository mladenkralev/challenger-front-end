// You may need to adjust the parameters or imports based on the actual data types and structures you're using.
import 'dart:math';

import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../chart/DummyGraphsForCards.dart';

class SummaryHomePageCard extends StatelessWidget {
  final double _padding = 32.0;
  static const double _roundingRadius = 12;

  final String title;
  final Icon icon;
  final Function() onTap;
  final Stream<List<dynamic>>? challenges;
  final double cardsSizeHeight;
  final double cardsSizeWidth;

  SummaryHomePageCard(this.title, this.icon, this.onTap, this.challenges,
      this.cardsSizeHeight, this.cardsSizeWidth,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCard(context, title, icon, onTap, challenges, cardsSizeHeight,
        cardsSizeWidth);
  }

  Widget _buildCard(
      BuildContext context,
      String title,
      Icon icon,
      Function nextPage,
      Stream<List<dynamic>>? chalenges,
      double cardsSizeHeight,
      double cardsSizeWidth) {
    print("sizeee " +
        cardsSizeHeight.toString() +
        " and " +
        cardsSizeWidth.toString());

    // Dynamically adjust properties based on card size
    final double dynamicPadding = max(4.0, cardsSizeWidth * 0.02);
    final double dynamicFontSize = max(12.0, cardsSizeHeight * 0.05);
    final double dynamicIconSize = max(24.0, cardsSizeWidth * 0.1);

    final double graphWidth = max(25.0, cardsSizeWidth * 0.5);
    final double graphHeight = max(25.0, cardsSizeHeight * 0.5);

    final double roundingRadius = 12.0;

    // Adjusting padding around the card content based on the card size
    // Adjusting padding around the card content based on the card size
    final EdgeInsets cardPadding = EdgeInsets.symmetric(
        horizontal: dynamicPadding, vertical: dynamicPadding / 2);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          // Navigate to the desired page
          nextPage();
        },
        child: SizedBox(
          width: cardsSizeWidth,
          height: cardsSizeHeight,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Allocate fixed space for Text
                Container(
                  width: double.infinity,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: icon,
                    ),
                    title: Text(
                      title,
                      style: TextStyle(color: WebGlobalConstants.hardBlack),
                    ),
                    subtitle: Text(
                        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                        style: TextStyle(color: WebGlobalConstants.hardBlack)),
                    trailing: StreamBuilder<List<dynamic>>(
                      stream: chalenges,
                      // Call the function that fetches the data
                      builder: (ctx, snapshot) {
                        return _getStreamLentgth(ctx, snapshot);
                      },
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                  color: Colors.black26,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      // Wrap the graph in an Expanded widget to fill available space
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            dynamicPadding, 0, 8, dynamicPadding),
                        child: DummyGraphsForCards(
                            TypeOfGraph.REGRESSIVE, graphWidth, graphHeight),
                      ),
                    ),
                    Expanded(
                      // Wrap the text column in an Expanded widget to avoid overflowing
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: Text(
                              "10% more",
                              style: TextStyle(fontSize: dynamicFontSize),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: Text(
                              "from last week",
                              style: TextStyle(fontSize: dynamicFontSize),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getStreamLentgth(BuildContext context, AsyncSnapshot snapshot) {
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
