import 'package:challenger/challenges/challenge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedUserChallenge extends StatefulWidget {
  final Function(int) notifyParent;
  Challenge currentChallenge;
  int index;

  AnimatedUserChallenge(this.index, this.currentChallenge, this.notifyParent);

  @override
  _AnimatedUserChallengeState createState() => _AnimatedUserChallengeState();
}

class _AnimatedUserChallengeState extends State<AnimatedUserChallenge> {
  bool selected = false;
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Dismissible(
          key: Key(widget.currentChallenge.toString()),
          onDismissed: (direction) {
            widget.notifyParent.call(widget.index);

            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("$widget dismissed with $direction")));
          },
          // Show a red background as the item is swiped away.
          background: Container(color: Colors.red),
          child: AnimatedContainer(
            color: selected ? Colors.red : Colors.orange,
            height: selected ? 120: 80,
            alignment:
                selected ? Alignment.center : AlignmentDirectional.topCenter,
            duration: Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            child: Center(
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                        title: Text(widget.currentChallenge.title),
                        subtitle: Text(widget.currentChallenge.description)
                    ),

                  ],
                ),
              ),
            ),
          )),
    );
  }
}
