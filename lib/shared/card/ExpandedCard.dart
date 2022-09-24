import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/services/AssetService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ExpandedCard extends StatefulWidget {
  bool collapsed = true;

  double cardRadius = 20;

  double challengeProgress = 0;

  final ChallengeModel challenge;

  ExpandedCard (Key key, this.challenge) : super(key: key);

  final loginService = locator<AssetService>();

  @override
  State<ExpandedCard  > createState() => _ExpandedCardState();
}

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class _ExpandedCardState extends State<ExpandedCard> {

  double challengeProgress = 0;

  @override
  Widget build(BuildContext context) {
    challengeProgress = widget.challenge.numberOfProgressHits / 100;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.cardRadius),
      ),
      child: Container(
        constraints: BoxConstraints.expand(height: 300),
        decoration: new BoxDecoration(
            image: new DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: widget.loginService.getImage(widget.challenge.blob.id),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(widget.cardRadius)
        ),
        child: Column(
          children: [
            Expanded(
              child: ListTile(
                leading: new CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 4.0,
                  percent: challengeProgress,
                  center: new Text(challengeProgress.toString()),
                  progressColor: Colors.red,
                ),
                title: Text(widget.challenge.title),
                subtitle: Text(
                  'A sufficiently long subtitle warrants three lines.',
                  style: TextStyle(

                  ),
                ),
                trailing: Icon(Icons.done_outline_sharp),
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
    );;
  }
}
