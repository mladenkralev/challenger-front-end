import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedUserChallengeWeb extends StatefulWidget {
  final Function(int) notifyParent;
  ChallengeModel currentChallenge;
  int index;

  AnimatedUserChallengeWeb(this.index, this.currentChallenge, this.notifyParent);

  @override
  _AnimatedUserChallengeWebState createState() => _AnimatedUserChallengeWebState();
}

class _AnimatedUserChallengeWebState extends State<AnimatedUserChallengeWeb> {
  bool selected = false;
  late BuildContext context;

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

            ScaffoldMessenger.of(context)
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
                        title: Text(widget.currentChallenge.title!),
                        subtitle: Text(widget.currentChallenge.description!)
                    ),

                  ],
                ),
              ),
            ),
          )),
    );
  }
}
