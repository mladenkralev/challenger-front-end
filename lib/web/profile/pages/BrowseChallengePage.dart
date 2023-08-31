import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/card/BrowseCardChallenge.dart';
import 'package:challenger/shared/card/HomeCardChallenge.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/shared/services/ChallengeService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/model/AssignedChallenges.dart';

class BrowseChallengePage extends StatefulWidget {
  final UserManagerService userManager;

  BuildContext context;

  BrowseChallengePage(this.userManager, this.context);

  @override
  State<BrowseChallengePage> createState() => _BrowseChallengePageState();
}

class _BrowseChallengePageState extends State<BrowseChallengePage> {
  final challengeService = locator<ChallengeService>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 300,
                child: Container(
                  child: StreamBuilder<List<AssignedChallenges>>(
                    stream: getShownChallenges(),
                    // should return a Stream<List<AssignedChallenges>>
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Loading indicator while data is loading
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Error message in case of error
                      } else {
                        if (snapshot.hasData && snapshot.data != null) {
                          snapshot.data?.sort((a, b) => a.challengeModel!.title!
                              .compareTo(b.challengeModel!.title!));
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final AssignedChallenges challenge =
                                  snapshot.data![index];
                              return _getCard(challenge, index);
                            },
                          );
                        } else {
                          return Text(
                              'No data'); // In case no data is available
                        }
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _getCard(AssignedChallenges challenge, int index) {
    // add key for updating
    Key cardKey = new Key(index.toString());

    // remember the card for clear and adding again
    BrowseCardChallenge browseCard =
        new BrowseCardChallenge(cardKey, challenge);

    // wrap with slidable
    return browseCard;
  }

  Stream<List<AssignedChallenges>>? getShownChallenges() {
    return challengeService.getUserChallenges(widget.userManager.user!.token);
  }
}
