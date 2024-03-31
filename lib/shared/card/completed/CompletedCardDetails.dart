import 'package:cached_network_image/cached_network_image.dart';
import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/HistoryChallenges.dart';
import 'package:challenger/shared/services/AssetService.dart';
import 'package:challenger/shared/services/AssignedChallengeService.dart';
import 'package:challenger/shared/services/HistoryChallengeService.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CompletedCardDetails extends StatelessWidget {
  final loginService = locator<AssetService>();
  final challengeService = locator<AssignedChallengeService>();
  final historyService = locator<HistoryChallengeService>();

  var _specificCard = "seeSpecificCard";
  double cardRadius = 20;

  final HistoryChallenge _challenge;
  Key key;

  CompletedCardDetails(this._challenge, this.key);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: _specificCard +
            _challenge.assignedChallenges!.id.toString() +
            _challenge.assignedChallenges!.challengeModel!.id.toString(),
        child: Center(
          child: SizedBox(
            width: 800,
            height: 600,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius),
              ),
              child: Container(
                constraints: BoxConstraints.expand(height: 300),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.dstATop),
                      image: loginService.getImage(_challenge
                          .assignedChallenges!.challengeModel?.blob?.id),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(cardRadius)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: ListTile(
                        leading: new CircularPercentIndicator(
                          radius: 20.0,
                          lineWidth: 4.0,
                          percent: 0.1,
                          center: new Text("1"),
                          progressColor: Colors.red,
                        ),
                        title: Text(_challenge.assignedChallenges!.challengeModel!.title!),
                        subtitle: Text(
                          'A sufficiently long subtitle warrants three lines.',
                          style: TextStyle(),
                        ),
                        trailing: Icon(Icons.done_outline_sharp),
                        isThreeLine: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text('BACK'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text('DONE'),
                          onPressed: () {
                            challengeService
                                .upgradeProgressOfChallenge(_challenge.assignedChallenges!.id);
                            historyService.sendServerUpdate();
                            challengeService.sendServerUpdate();
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
