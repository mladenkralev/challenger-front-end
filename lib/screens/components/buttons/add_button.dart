// import 'package:challenger/challenges/challenge.dart';
// import 'file:///C:/Users/Mladen/AndroidStudioProjects/challenger/lib/screens/user/profile/components/user_home.dart';
// import 'package:challenger/screens/custom_challenges/add_page.dart';
//
// import 'package:challenger/user/user.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:unicorndial/unicorndial.dart';
//
// class AddButton extends StatelessWidget {
//   final Function(Challenge) notifyParent;
//   User user;
//
//   AddButton(this.notifyParent, this.user);
//
//   List<UnicornButton> _getProfileMenu(BuildContext context) {
//     List<UnicornButton> children = [];
//
//     // Add Children here
//     children.add(_profileOption(
//         iconData: Icons.import_contacts,
//         tag: "importChallenges",
//         onPressed: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => UserHome(this.notifyParent, this.user)
//         ),
//       );
//     }));
//     children.add(_profileOption(
//         iconData: Icons.add,
//         tag: "addChallenges",
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => AddCustomChallengePage(this.notifyParent, this.user)
//             ),
//           );
//         })
//     );
//
//     return children;
//   }
//
//   Widget _profileOption({IconData iconData, String tag, Function onPressed}) {
//     return UnicornButton(
//         currentButton: FloatingActionButton(
//           heroTag: tag,
//           mini: true,
//           child: Icon(iconData),
//           onPressed: onPressed
//         )
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return UnicornDialer(
//       orientation: UnicornOrientation.VERTICAL,
//       parentButton: Icon(Icons.add),
//       childButtons: _getProfileMenu(context),
//       backgroundColor: Colors.transparent,
//     );
//   }
//
// }
