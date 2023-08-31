import 'package:cached_network_image/cached_network_image.dart';
import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/card/BrowseCardDetails.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/services/AssetService.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BrowseCardChallenge extends StatefulWidget {
  final assetService = locator<AssetService>();

  bool collapsed = true;
  double cardRadius = 20;
  double challengeProgress = 0;

  Key key;
  final AssignedChallenges challenge;

  BrowseCardChallenge(this.key, this.challenge);

  @override
  State<BrowseCardChallenge> createState() => BrowseCardChallengeState();
}

const loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class BrowseCardChallengeState extends State<BrowseCardChallenge> {
  double challengeProgress = 0;
  double pace = 0;

  var _specificCard = "seeSpecificCard";

  @override
  Widget build(BuildContext context) {
    challengeProgress = pace *
        (widget.challenge.maxProgress! - widget.challenge.currentProgress!);
    pace = 100 / widget.challenge.maxProgress!;

    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BrowseCardDetails(widget.challenge, widget.key))),
      child: Hero(
        tag: _specificCard +
            widget.challenge.id.toString() +
            widget.challenge.challengeModel!.id.toString(),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.cardRadius),
            ),
            child: getCard(widget.challenge.challengeModel!.id)),
      ),
    );
  }

  static const String BACKEND_AUTH_SERVICE = "http://localhost:8080";

  Widget getCard(int? id) {
    var url = BACKEND_AUTH_SERVICE + '/api/v1/blobs/' + id.toString();
    // print("Getting image" + id.toString());
    CachedNetworkImage cachedNetworkImage = new CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => SizedBox(
        width: 300,
        height: 300,
        child: Container(
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
                  title: Text(widget.challenge.challengeModel!.title!),
                  subtitle: Text(
                    'A sufficiently long subtitle warrants three lines.',
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
                  loremIpsum,
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
