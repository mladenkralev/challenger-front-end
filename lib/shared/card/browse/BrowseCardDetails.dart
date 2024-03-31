import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/services/AssetService.dart';
import 'package:challenger/shared/services/AssignedChallengeService.dart';
import 'package:challenger/shared/services/HistoryChallengeService.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class BrowseCardDetails extends StatelessWidget {
  final loginService = locator<AssetService>();
  final challengeService = locator<AssignedChallengeService>();
  final historyService = locator<HistoryChallengeService>();
  final userManagerService = locator<UserManagerService>();

  var _specificCard = "seeSpecificCard";
  double cardRadius = 20;

  final ChallengeModel _challenge;
  Key key;

  BrowseCardDetails(this._challenge, this.key);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: _specificCard +
            _challenge.id.toString() +
            _challenge.id.toString(),
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
                      image: loginService
                          .getImage(_challenge.blob?.id),
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
                        title: Text(_challenge.title!),
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
                          child: const Text('ACCEPT CHALLENGE'),
                          onPressed: () {
                            challengeService.assignChallengeToCurrentUser(userManagerService.user!.id, _challenge.id);
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
