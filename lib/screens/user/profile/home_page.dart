import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/screens/user/profile/components/body.dart';
import 'package:challenger/time/occurrences.dart';
import 'package:challenger/user/user.dart';
import 'package:challenger/services/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  static const String id = 'user_profile_page';

  // User user
  UserManager userManager;

  UserHomePage(this.userManager);

  @override
  UserHomePageState createState() => UserHomePageState();
}

class UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;
  Occurrences currentlyDisplayed = Occurrences.DAY;

  Body body;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  addNewChallenge(Challenge newChallenge) {
    // setState(() {
    //   widget.user.manager.abandonChallenge(newChallenge);
    // });
  }

  @override
  Widget build(BuildContext context) {
    body = new Body(this);
    return Scaffold(
      backgroundColor: Color(0xFFF9F6F4),
      body: Container(
        child: body.widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'More Challenges',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  markUserChallengeAsCompleted(int indexOfChallenge) {
    setState(() {
      // //remove from UI
      // Challenge removedItem =
      //     currentlyDisplayedChallenges.removeAt(indexOfChallenge);
      //
      // if (!currentlyDisplayedChallenges.contains(removedItem)) {
      //   currentlyDisplayedChallenges.remove(removedItem);
      // }
      // widget.user.manager.updateStatus(removedItem, true);
      // // //remove from DB
      // // if (widget.user.manager.userChallenges.contains(removedItem)) {
      // //   widget.user.manager.userChallenges.remove(removedItem);
      // // }
    });
  }


}
