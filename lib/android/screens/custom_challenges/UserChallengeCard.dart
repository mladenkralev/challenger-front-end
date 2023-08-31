import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/model/AssignedChallenges.dart';

class UserChallengeCard extends StatefulWidget {
  final Function(ChallengeModel) notifyParent;
  final AssignedChallenges challenge;
  final UserManagerService user;

  UserChallengeCard(this.challenge,this.user, this.notifyParent);

  @override
  _ChallengeCardState createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<UserChallengeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Container(
                    child: Icon(Icons.fitness_center, color: Colors.blueGrey, size: 60,)),
                title: Text(
                  this.widget.challenge.challengeModel.title,
                ),
                subtitle: Text("Every " + OccurrencesTransformer.transformToString(this.widget.challenge.challengeModel.occurrences)),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 1, right: 10, bottom: 1),
                  child: Text(
                    this.widget.challenge.challengeModel.description,
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  TextButton(
                    child: const Text("Abandon"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Challenge was abandoned'),
                              duration: Duration(seconds: 2)
                          )
                      );
                      widget.notifyParent(widget.challenge.challengeModel);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}