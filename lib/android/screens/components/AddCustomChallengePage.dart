import 'package:challenger/android/screens/user/profile/components/tabs/AddCard.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCustomChallengePage extends StatelessWidget {
  static const String id = 'add_page';

  final Function(ChallengeModel) notifyParent;

  BuildContext context;

  AddCustomChallengePage(this.context, this.notifyParent);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: AddCard(this.notifyParent),
              ),
            ),
          ],
        )));
  }
}
