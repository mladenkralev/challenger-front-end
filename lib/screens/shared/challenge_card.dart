import 'package:challenger/challenges/challenge.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class ChallengeCard extends StatefulWidget {
  bool isExpanded = false;
  final Challenge challenge;

  ChallengeCard(Key key, this.challenge) : super(key: key);

  @override
  _ChallengeCardState createState() => _ChallengeCardState();
}

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class _ChallengeCardState extends State<ChallengeCard> {
  bool collapsed = true;

  double cardRadius = 20;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            collapsed = !collapsed;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: AnimatedContainer(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: collapsed ? 100.0 : MediaQuery
                  .of(context)
                  .size
                  .height / 2,
              alignment: collapsed ? Alignment.center : AlignmentDirectional
                  .topCenter,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              child: collapsed ? _collapsedChild() : _expandedChild()
          ),
        ));
  }

  Widget _collapsedChild() {
    return Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          borderOnForeground: true,
          child: Container(
            constraints: BoxConstraints.expand(height: 300),
            decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage(
                      'assets/andrew-tanglao-3I2vzcmEpLU-unsplash.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(cardRadius)
            ),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: ListTile(
                    leading: new CircularPercentIndicator(
                      radius: 45.0,
                      lineWidth: 4.0,
                      percent: 0.10,
                      center: new Text("10%"),
                      progressColor: Colors.red,
                    ),
                    title: Text(widget.challenge.title),
                    subtitle: Text(
                      'A sufficiently long subtitle warrants three lines.',
                      style: TextStyle(

                      ),
                    ),
                    trailing: Icon(Icons.arrow_right),
                    isThreeLine: true,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _expandedChild() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        child: Container(
          constraints: BoxConstraints.expand(height: 300),
          decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage(
                    'assets/andrew-tanglao-3I2vzcmEpLU-unsplash.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(cardRadius)
          ),
          child: Column(
            children: [
              Expanded(
                child: ListTile(
                  leading: new CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 4.0,
                    percent: 0.10,
                    center: new Text("10%"),
                    progressColor: Colors.red,
                  ),
                  title: Text(widget.challenge.title),
                  subtitle: Text(
                    'A sufficiently long subtitle warrants three lines.',
                    style: TextStyle(

                    ),
                  ),
                  trailing: Icon(Icons.arrow_right),
                  isThreeLine: true,
                ),
              ),
              Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(20),
                    child: Text(
                      loremIpsum,
                      style: TextStyle(

                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
