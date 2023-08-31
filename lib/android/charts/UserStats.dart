import 'package:challenger/shared/services/UserManager.dart';
import 'package:flutter/material.dart';

class UserStats extends StatefulWidget {
  UserManagerService userManager;

  UserStats(this.userManager);

  @override
  _UserStatsState createState() => _UserStatsState();
}

class _UserStatsState extends State<UserStats> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      alignment: Alignment.center,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  new Icon(Icons.star),
                  new Text("Level",
                      style: Theme.of(context).textTheme.headline5),
                  new Text(widget.userManager.level.toString(), style: Theme.of(context).textTheme.headline5)
                ],
              ),
            ),
          ]),
    ));
  }
}
