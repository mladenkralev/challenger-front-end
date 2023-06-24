import 'package:challenger/shared/model/UserManager.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:challenger/web/profile/components/SideBar.dart';
import 'package:challenger/web/profile/pages/chart/PieChart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'table/ChallengesTable.dart';

class ProfilePage extends StatefulWidget {
  UserManager userManager;

  ProfilePage(this.userManager);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String getUserGreeting() => "Your Place, " + widget.userManager.username!;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
              title: Text(
                getUserGreeting(),
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineSmall,
              ),
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              foregroundColor: WebGlobalConstants.foregroundColor,
              titleTextStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.headline1?.fontSize,
              )
          ),
          drawer: SideBar(widget.userManager),
          body: Column(
              children: <Widget>[
                Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: buildCard("Completed challenges", widget.userManager.getCompletedChallenges()!.length.toString() )
                        ),
                        Flexible(
                            child: buildCard("Assigned challenges", sumOfChallenges().toString())
                        ),
                        Flexible(
                            child: buildCard("Rank" , "0")
                        ),
                      ],
                    )
                ),
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                onTap: () {
                                  debugPrint('Card tapped.');
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: MediaQuery.of(context).size.height / 4,
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: Text("not impl"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                debugPrint('Card tapped.');
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.height / 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: Text("Not impl"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                debugPrint('Card tapped.');
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.height / 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: Text("Not Impl"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    )
                ),
                Flexible(
                  flex: 4,
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Text("not impl")
                  )
                  ),
                ),
              ]
          )
      ),
    );
  }

  int sumOfChallenges() {
    return widget.userManager.getDailyAssignChallenges()!.length + widget.userManager.getMonthlyAssignChallenges()!.length + widget.userManager.getWeeklyAssignChallenges()!.length;
  }

  Widget buildCard(String leadingText, String subText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            debugPrint('Card tapped.');
          },
          child: SizedBox(
            width: 300,
            height: 100,
            child: Center(
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    leadingText ,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    subText ,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
