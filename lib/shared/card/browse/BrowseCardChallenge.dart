import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/card/browse/BrowseCardDetails.dart';
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
              child: _getCard(widget.challenge.id)),
        ),
      ),
    );
  }

  Widget _getCard(int? id) {
    var url = AssetService.HTTP_BACKEND_SERVICE +
        AssetService.ASSET_SUFFIX +
        id.toString();
    print("Id: " +
        id.toString() +
        " Getting image " +
        id.toString() +
        " from " +
        url);

    const double baseScreenWidth = 1024.0;
    const double basePadding = 24.0;
    const double baseTextSize = 20.0;

    double screenWidth = MediaQuery.of(context).size.width;
    const double maxScaleFactor = 1.5; // Adjust this value as needed
    double scale = min(screenWidth / baseScreenWidth, maxScaleFactor);

    // Calculate the dynamic padding
    double minPadding = 8.0;
    double dynamicPadding =
        max(24.0 * scale, 8.0); // Ensures padding is not less than 8.0
    double dynamicTextSize = max(
        baseTextSize * scale, 12.0); // Ensures text size is not less than 12.0

    print("Width: " + widget.width.toString());
    print("Height: " + widget.height.toString());
    print("Scale: " + scale.toString());
    print("Dynamic padding: " + dynamicPadding.toString());
    print("Dynamic textSize: " + dynamicTextSize.toString());

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
              padding: EdgeInsets.all(dynamicPadding),
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
                    fontSize: dynamicTextSize,
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
                    fontSize: dynamicTextSize - 2,
                    color: WebGlobalConstants.secondBlack,
                  ),
                ),
                trailing: Icon(Icons.done_outline_sharp, color: Colors.black),
                isThreeLine: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: dynamicPadding * 2, left: dynamicPadding * 2),
              child: Text(
                widget.challenge.shortDescription!,
                style: TextStyle(
                  fontSize: dynamicTextSize - 2,
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
                  buildTag('Strength', Colors.red, dynamicTextSize - 2),
                  SizedBox(width: 8), // Spacing between tags
                  buildTag('Weekly', Colors.green, dynamicTextSize - 2),
                  SizedBox(width: 8), // Spacing between tags
                  buildTag('Easy', Colors.blue, dynamicTextSize - 2),
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

  Widget buildTag(String label, Color color, double size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: WebGlobalConstants.primaryColor, fontSize: size),
      ),
    );
  }
}
