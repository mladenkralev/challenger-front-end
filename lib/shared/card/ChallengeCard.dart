import 'package:challenger/shared/card/ExpandedCard.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/services/AssetService.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../DependencyInjection.dart';
import '../model/AssignedChallenges.dart';


class ChallengeCard extends StatefulWidget {
  bool isExpanded = false;
  final AssignedChallenges challenge;

  double collapsedHeight;

  ChallengeCard(Key key, this.challenge, this.collapsedHeight) : super(key: key);

  @override
  ChallengeCardState createState() => ChallengeCardState();
}

class ChallengeCardState extends State<ChallengeCard> {
  bool runOnce = false;

  bool collapsed = true;

  double cardRadius = 20;

  double challengeProgress = 0;
  double pace = 0;

  final loginService = locator<AssetService>();

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
              height: collapsed ? widget.collapsedHeight : MediaQuery
                  .of(context)
                  .size
                  .height / 2,
              // alignment: collapsed ? Alignment.center : AlignmentDirectional
              //     .topStart,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              child: collapsed ? _collapsedChild() : ExpandedCard(widget.challenge)
          ),
        ));
  }

  Widget _collapsedChild() {
    if(!runOnce) {
      pace = 100/ widget.challenge.maxProgress!;
      challengeProgress = pace * (widget.challenge.maxProgress! - widget.challenge.currentProgress!);
      updateChallengeProgress(challengeProgress);
      runOnce = true;
    }
    // center it if you want
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      borderOnForeground: true,
      child: Container(
        constraints: BoxConstraints.expand(height: 300),
        decoration: new BoxDecoration(
            image: new DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
              image: loginService.getImage(widget.challenge.challengeModel?.blob?.id!),
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
                  percent: double.parse((challengeProgress).toStringAsFixed(1)),
                  center: new Text(challengeProgress.toStringAsFixed(1)),
                  progressColor: Colors.red,
                ),
                title: Text(widget.challenge.challengeModel!.title!),
                subtitle: Text(
                  'A sufficiently long subtitle warrants three lines.',
                  style: TextStyle(

                  ),
                ),
                trailing: Icon(Icons.done_outline_sharp),
                isThreeLine: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateChallengeProgress(double numberOfHits){
    setState(() {
      challengeProgress = numberOfHits / 100;
      print(challengeProgress);
    });
  }
}
