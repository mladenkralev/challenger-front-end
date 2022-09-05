import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/global_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChallengeSizedBox extends StatelessWidget {

  double boxHeight = 100.0;
  double boxWidth = 150.0;

  String title;
  List<Challenge> futureChallenges;

  ChallengeSizedBox(this.title, this.futureChallenges);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: Card(
          child: Container(
              height: boxHeight,
              width: boxWidth,
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .cardColor
                    .withOpacity(0.8),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0)),
              ),
              child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    new Text(title,
                        style: TextStyle(
                            fontSize:
                            GlobalConstants.h2Size,
                            color: Colors.black
                                .withOpacity(0.7))),
                    new Text(
                        futureChallenges.length.toString(),
                        style: TextStyle(
                            fontSize:
                            GlobalConstants.h2Size,
                            color: Colors.black
                                .withOpacity(0.7))),
                  ])),
        ));
  }
}
