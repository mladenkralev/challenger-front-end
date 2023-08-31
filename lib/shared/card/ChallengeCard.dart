import 'package:cached_network_image/cached_network_image.dart';
import 'package:challenger/shared/card/ExpandedCard.dart';
import 'package:challenger/shared/services/AssetService.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../DependencyInjection.dart';
import '../model/AssignedChallenges.dart';

class ChallengeCard extends StatefulWidget {
  bool isExpanded = false;
  final AssignedChallenges challenge;

  double collapsedHeight;

  ChallengeCard(Key key, this.challenge, this.collapsedHeight)
      : super(key: key);

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
              height: collapsed
                  ? widget.collapsedHeight
                  : MediaQuery
                  .of(context)
                  .size
                  .height / 2,
              // alignment: collapsed ? Alignment.center : AlignmentDirectional
              //     .topStart,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              child: collapsed
                  ? _collapsedChild()
                  : ExpandedCard(widget.challenge)),
        ));
  }

  Widget _collapsedChild() {
    if (!runOnce) {
      pace = 100 / widget.challenge.maxProgress!;
      challengeProgress = pace *
          (widget.challenge.maxProgress! - widget.challenge.currentProgress!);
      updateChallengeProgress(challengeProgress);
      runOnce = true;
    }
    // center it if you want
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        borderOnForeground: true,
        child: getCard(widget.challenge.challengeModel?.id),
        // Column(children: [

        // Flexible(
        //     flex: 1,
        //     child: ListTile(
        //       leading: new CircularPercentIndicator(
        //         radius: 45.0,
        //         lineWidth: 4.0,
        //         percent: double.parse((challengeProgress).toStringAsFixed(1)),
        //         center: new Text(challengeProgress.toStringAsFixed(1)),
        //         progressColor: Colors.red,
        //       ),
        //       title: Text(widget.challenge.challengeModel!.title!),
        //       subtitle: Text(
        //         'A sufficiently long subtitle warrants three lines.',
        //         style: TextStyle(),
        //       ),
        //       trailing: Icon(Icons.done_outline_sharp),
        //       isThreeLine: true,
        //     ))
        // ]));
    );
  }

  updateChallengeProgress(double numberOfHits) {
    setState(() {
      challengeProgress = numberOfHits / 100;
      print(challengeProgress);
    });
  }

  static const String BACKEND_AUTH_SERVICE = "http://localhost:8080";

  Widget getCard(int? id) {
    var url = BACKEND_AUTH_SERVICE + '/api/v1/blobs/' + id.toString();
    print("Getting image");
    CachedNetworkImage cachedNetworkImage = new CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) =>
          Container(
            height: 100,
            width: 100,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
                borderRadius: BorderRadius.circular(25)),
          ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
    );

    return cachedNetworkImage;
  }
}
