import 'dart:math';

import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/services/AssetService.dart';
import 'package:challenger/shared/services/AssignedChallengeService.dart';
import 'package:challenger/shared/services/HistoryChallengeService.dart';
import 'package:challenger/web/PhoneGlobalConstants.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AssignedCardDetails extends StatelessWidget {
  final loginService = locator<AssetService>();
  final challengeService = locator<AssignedChallengeService>();
  final historyService = locator<HistoryChallengeService>();

  var _specificCard = "seeSpecificCard";
  double cardRadius = 20;

  final AssignedChallenges _challenge;
  Key key;

  AssignedCardDetails(this._challenge, this.key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    const double baseScreenWidth = 1024.0;
    const double basePadding = 24.0;
    const double baseTextSize = 20.0;

    const double maxScaleFactor = 1.5; // Adjust this value as needed
    double scale = min(screenWidth / baseScreenWidth, maxScaleFactor);

    // Calculate the dynamic padding
    double minPadding = 8.0;
    double dynamicPadding =
        max(24.0 * scale, 8.0); // Ensures padding is not less than 8.0
    double dynamicTextSize = max(
        baseTextSize * scale, 12.0); // Ensures text size is not less than 12.0

    double cardWidth = screenWidth * 0.3;
    double cardHeight = screenHeight * 0.5;

    print("Width: " + screenWidth.toString());
    print("Height: " + screenHeight.toString());
    print("Scale: " + scale.toString());
    print("Dynamic padding: " + dynamicPadding.toString());
    print("Dynamic textSize: " + dynamicTextSize.toString());

    return Hero(
        tag: _specificCard +
            _challenge.id.toString() +
            _challenge.challengeModel!.id.toString(),
        child: Center(
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius),
              ),
              child: Container(
                constraints: BoxConstraints.expand(height: screenHeight),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.dstATop),
                      image: loginService
                          .getImage(_challenge.challengeModel?.blob?.id),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(cardRadius)),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: ListTile(
                        leading: new CircularPercentIndicator(
                          radius: 20.0,
                          lineWidth: 4.0,
                          percent: 0.1,
                          center:
                              Text((_challenge.currentProgress!).toString()),
                          progressColor: Colors.red,
                        ),
                        title: Text(_challenge.challengeModel!.title!),
                        subtitle: Text(
                          _challenge.challengeModel!.shortDescription
                              .toString(),
                          style: TextStyle(
                            fontSize: dynamicTextSize - 2,
                            color: WebGlobalConstants.secondBlack,
                          ),
                        ),
                        trailing: Icon(Icons.done_outline_sharp),
                        isThreeLine: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: dynamicPadding * 2, left: dynamicPadding * 2),
                      child: Text(
                        _challenge.challengeModel!.description!,
                        style: TextStyle(
                          fontSize: dynamicTextSize - 2,
                          color: WebGlobalConstants.secondBlack,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 300),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: TextStyle(
                                    fontSize: dynamicTextSize - 2,
                                    color: WebGlobalConstants.secondBlack),
                              ),
                              child: const Text('BACK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle: TextStyle(
                                    fontSize: dynamicTextSize - 2,
                                    color: WebGlobalConstants.secondBlack),
                              ),
                              child: const Text('DONE'),
                              onPressed: () {
                                challengeService
                                    .upgradeProgressOfChallenge(_challenge.id);
                                historyService.sendServerUpdate();
                                challengeService.sendServerUpdate();
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
