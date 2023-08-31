import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/services/ChallengeService.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/card/HomeCardChallenge.dart';

class AssignedChallengesPage extends StatelessWidget {

  final challengeService = locator<ChallengeService>();
  final userManager = locator<UserManagerService>();

  BuildContext context;

  AssignedChallengesPage(this.context);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    snapshot.data?.sort((a, b) => a.challengeModel!.title!.compareTo(b.challengeModel!.title!));
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
                    return Text('No data'); // In case no data is available
                  }
                }
              },
            ),
          ),
        );
  }

  Stream<List<AssignedChallenges>>? getShownChallenges() {
    return challengeService.getUserChallenges(userManager.user!.token);
  }

  Widget _getCard(AssignedChallenges challenge, int index) {
    // add key for updating
    Key cardKey = new Key(index.toString());
    // _keys1.add(cardKey);

    // remember the card for clear and adding again
    HomeCardChallenge challengeCard =
    new HomeCardChallenge(cardKey, challenge);

    // wrap with slidable
    return challengeCard;
  }
}
