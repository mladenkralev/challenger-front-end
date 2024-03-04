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
    const phoneBreakpoint = 600;
    const tabletBreakpoint = 900;

    double screnWidth = MediaQuery.of(context).size.width;

    bool isPhone = screnWidth < phoneBreakpoint;
    bool isTablet =
        screnWidth >= phoneBreakpoint && screnWidth < tabletBreakpoint;
    bool isDesktop = screnWidth >= tabletBreakpoint;

    // Use the boolean values to decide which widget to return
    if (isPhone) {
      return _phoneHome();
    } else if (isTablet) {
      // Assuming you have a method for tablet layout
      return _tabletHome();
    } else if (isDesktop) {
      return _webView();
    }

    return _webView();
  }

  Container _phoneHome() {
    const double dynamicPadding = 6;
    double cardWidth = MediaQuery.of(context).size.width;
    double cardHeight = MediaQuery.of(context).size.height / 3;

    return Container(
      child: StreamBuilder<List<ChallengeModel>>(
        stream: getShownChallenges(),
        // should return a Stream<List<ChallengeModel>>
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while data is loading
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Error message in case of error
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              snapshot.data
                  ?.sort((a, b) => (a.title ?? "").compareTo(b.title ?? ""));
              return Padding(
                padding: const EdgeInsets.all(dynamicPadding),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final ChallengeModel challenge = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: dynamicPadding),
                      // Add padding between items
                      child: _getCard(challenge, index, cardWidth,
                          cardHeight), // Your method to render each challenge card
                    );
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

  Container _tabletHome() {
    return Container(child: Text("Not implmeneted"));
  }

  Container _webView() {
    double cardWidth = MediaQuery.of(context).size.width / 8;
    double cardHeight = MediaQuery.of(context).size.height / 3;

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
                    return _getCard(challenge, index, cardWidth, cardHeight);
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

  Widget _getCard(
      ChallengeModel challenge, int index, double width, double height) {
    // add key for updating
    Key cardKey = new Key(index.toString());

    // remember the card for clear and adding again
    BrowseCardChallenge browseCard =
        new BrowseCardChallenge(cardKey, challenge, width, height);

    // wrap with slidable
    return browseCard;
  }

  Stream<List<ChallengeModel>>? getShownChallenges() {
    return challengeService
        .getBrowsableChallenges(widget.userManager.user!.token);
  }
}
