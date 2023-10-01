import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/card/completed/CompletedCard.dart';
import 'package:challenger/shared/model/HistoryChallenges.dart';
import 'package:challenger/shared/services/HistoryChallengeService.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:flutter/material.dart';

class CompletedChallengesPage extends StatelessWidget {
  final historyService = locator<HistoryChallengeService>();
  final userManager = locator<UserManagerService>();

  BuildContext context;

  CompletedChallengesPage(this.context);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<HistoryChallenge>>(
        stream: getCompletedChallenges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while data is loading
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Error message in case of error
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              snapshot.data?.sort((a, b) =>
                  a.assignedChallenges!.challengeModel!.title!.compareTo(
                      b.assignedChallenges!.challengeModel!.title.toString()));
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // 4 cards in a row
                    childAspectRatio: 1, // Aspect ratio
                    mainAxisSpacing: 32, // Spacing between rows
                    crossAxisSpacing: 32, // Spacing between columns
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final HistoryChallenge challenge = snapshot.data![index];
                    return _getCard(challenge, index);
                  },
                ),
              );
            } else {
              return Text('No data'); // In case no data is available
            }
          }
        },
      ),
    );
  }

  Stream<List<HistoryChallenge>>? getCompletedChallenges() {
    return historyService.fetchHistoryData();
  }

  Widget _getCard(HistoryChallenge challenge, int index) {
    // add key for updating if wanted
    Key cardKey = new Key(index.toString());
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // remember the card for clear and adding again
    CompletedCard challengeCard =
        new CompletedCard(cardKey, challenge, width / 8, height / 3);

    // wrap with slidable
    return challengeCard;
  }
}
