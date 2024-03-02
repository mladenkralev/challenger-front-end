import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/card/BrowseCardChallenge.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/services/BrowseChallengeService.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:flutter/material.dart';

class BrowseChallengePage extends StatefulWidget {
  final UserManagerService userManager;

  BuildContext context;

  BrowseChallengePage(this.userManager, this.context);

  @override
  State<BrowseChallengePage> createState() => _BrowseChallengePageState();
}

class _BrowseChallengePageState extends State<BrowseChallengePage> {
  final challengeService = locator<BrowseChallengeService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<ChallengeModel>>(
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
              snapshot.data?.sort((a, b) => a!.title!.compareTo(b.title!));
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
                    final ChallengeModel challenge = snapshot.data![index];
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

  Widget _getCard(ChallengeModel challenge, int index) {
    // add key for updating
    Key cardKey = new Key(index.toString());

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // remember the card for clear and adding again
    BrowseCardChallenge browseCard =
        new BrowseCardChallenge(cardKey, challenge, width / 8, height / 3);

    // wrap with slidable
    return browseCard;
  }

  Stream<List<ChallengeModel>>? getShownChallenges() {
    return challengeService
        .getBrowsableChallenges(widget.userManager.user!.token);
  }
}
