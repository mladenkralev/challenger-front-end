import 'package:cached_network_image/cached_network_image.dart';
import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/card/BrowseCardDetails.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/services/AssetService.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class BrowseCardChallenge extends StatefulWidget {
  final assetService = locator<AssetService>();

  final double width;
  final double height;

  final bool collapsed = true;
  final double cardRadius = 20;
  final double challengeProgress = 0;

  final Key key;
  final ChallengeModel challenge;

  BrowseCardChallenge(this.key, this.challenge, this.width, this.height);

  @override
  State<BrowseCardChallenge> createState() => BrowseCardChallengeState();
}

class BrowseCardChallengeState extends State<BrowseCardChallenge> {
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
                  BrowseCardDetails(widget.challenge, widget.key))),
      child: Hero(
        tag: _specificCard +
            widget.challenge.id.toString() +
            widget.challenge.id.toString(),
        child: Container(
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.cardRadius),
              ),
              child: getCard(widget.challenge.id)),
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

    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
            fit: BoxFit.cover,
            image: imageProvider,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(24),
              child: ListTile(
                leading: CircularPercentIndicator(
                  radius: 20.0,
                  lineWidth: 4.0,
                  percent: 0.1,
                  center: Text("1"),
                  progressColor: Colors.red,
                ),
                title: Text(
                  widget.challenge.title!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: WebGlobalConstants.hardBlack,
                    shadows: [
                      Shadow(
                          blurRadius: 1.0,
                          color: Colors.black,
                          offset: Offset(0, 0))
                    ],
                  ),
                ),
                subtitle: Text(
                  widget.challenge.description!,
                  style: TextStyle(
                    color: WebGlobalConstants.secondBlack,
                  ),
                ),
                trailing: Icon(Icons.done_outline_sharp, color: Colors.black),
                isThreeLine: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(36),
              child: Text(
                widget.challenge.shortDescription!,
                style: TextStyle(
                  color: WebGlobalConstants.secondBlack,
                ),
              ),
            ),
            Spacer(),
            // Use Spacer to push everything above to the top and button to the bottom
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildTag('Strength', Colors.red),
                  SizedBox(width: 8), // Spacing between tags
                  buildTag('Weekly', Colors.green),
                  SizedBox(width: 8), // Spacing between tags
                  buildTag('Easy', Colors.blue),
                  // Add more tags as needed
                ],
              ),
            ),
          ],
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
    );
  }

  Widget buildTag(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: WebGlobalConstants.primaryColor,
            fontSize: WebGlobalConstants.tagSize),
      ),
    );
  }
}
