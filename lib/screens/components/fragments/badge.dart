import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerbBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('something was clicked')));
      },
      onLongPress: () {
        // open dialog OR navigate OR do what you want
      },
      child: Badge(
        badgeColor: Colors.deepPurple,
        shape: BadgeShape.square,
        // borderRadius: new BorderRadiusGeometry(20),
        toAnimate: false,
        badgeContent: Text('BADGE', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
