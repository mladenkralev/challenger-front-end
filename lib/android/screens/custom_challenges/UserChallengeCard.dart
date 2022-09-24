import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/model/UserManager.dart';
import 'package:challenger/shared/time/OccurrencesTransformer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserChallengeCard extends StatefulWidget {
  final Function(ChallengeModel) notifyParent;
  final ChallengeModel challenge;
  final UserManager user;

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
                  this.widget.challenge.title,
                ),
                subtitle: Text("Every " + OccurrencesTransformer.transformToString(this.widget.challenge.occurrences)),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 1, right: 10, bottom: 1),
                  child: Text(
                    this.widget.challenge.description,
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
                      widget.notifyParent(widget.challenge);
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