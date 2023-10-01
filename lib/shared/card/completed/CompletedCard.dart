import 'package:cached_network_image/cached_network_image.dart';
import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/card/completed/CompletedCardDetails.dart';
import 'package:challenger/shared/model/HistoryChallenges.dart';
import 'package:challenger/shared/services/AssetService.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CompletedCard extends StatefulWidget {
  final assetService = locator<AssetService>();

  double width;
  double height;

  bool collapsed = true;
  double cardRadius = 20;
  double challengeProgress = 0;

  Key key;
  final HistoryChallenge challenge;

  CompletedCard(this.key, this.challenge, this.width, this.height);

  @override
  State<CompletedCard> createState() => CompletedCardState();
}

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class CompletedCardState extends State<CompletedCard> {
  double challengeProgress = 0;
  double pace = 0;

  var _specificCard = "seeSpecificCard";

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CompletedCardDetails(widget.challenge, widget.key))),
      child: Hero(
        tag: _specificCard +
            widget.challenge.assignedChallenges!.id.toString() +
            widget.challenge.assignedChallenges!.challengeModel!.id.toString(),
        child: Container(
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.cardRadius),
              ),
              child: getCard(
                  widget.challenge.assignedChallenges!.challengeModel!.id)),
        ),
      ),
    );
  }

  static const String BACKEND_AUTH_SERVICE = "http://localhost:8080";

  Widget getCard(int? id) {
    print("New invocation of getCard" +
        widget.width.toString() +
        " " +
        widget.height.toString());
    var url = BACKEND_AUTH_SERVICE + '/api/v1/blobs/' + id.toString();
    print("Id: " + id.toString() + " Getting image" + id.toString());
    CachedNetworkImage cachedNetworkImage = new CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => SizedBox(
        width: widget.width,
        height: widget.height,
        child: Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.dstATop),
                fit: BoxFit.cover,
                image: imageProvider,
              ),
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: [
              Flexible(
                child: ListTile(
                  leading: new CircularPercentIndicator(
                    radius: 20.0,
                    lineWidth: 4.0,
                    percent: 0.1,
                    center: new Text("1"),
                    progressColor: Colors.red,
                  ),
                  title: Text(widget
                      .challenge.assignedChallenges!.challengeModel!.title!),
                  subtitle: Text(
                    widget.challenge.assignedChallenges!.challengeModel!.id
                        .toString()!,
                    style: TextStyle(),
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
                  widget.challenge.assignedChallenges!.challengeModel!
                      .description!,
                  style: TextStyle(),
                ),
              ))
            ],
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
    );

    return cachedNetworkImage;
  }
}
