// You may need to adjust the parameters or imports based on the actual data types and structures you're using.
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:flutter/material.dart';

import '../chart/DummyGraphsForCards.dart';

class SummaryHomePageCard extends StatelessWidget {
  final double _padding = 32.0;
  static const double _roundingRadius = 12;

  final String title;
  final Icon icon;
  final Function() onTap;
  final Stream<List<dynamic>>? challenges;

  SummaryHomePageCard(
      this.title, this.icon, this.onTap, this.challenges,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCard(context, title, icon, onTap, challenges);
  }

  Widget _buildCard(BuildContext context, String title, Icon icon,
      Function nextPage, Stream<List<dynamic>>? chalenges) {
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
          nextPage();
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
                        trailing: StreamBuilder<List<dynamic>>(
                          stream: chalenges,
                          // Call the function that fetches the data
                          builder: (ctx, snapshot) {
                            return _getStreamLentgth(ctx, snapshot);
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
                              width: cardsSizeWidth * 0.5,
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
