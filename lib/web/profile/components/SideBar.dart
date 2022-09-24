import 'package:challenger/shared/model/UserManager.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:challenger/web/profile/UserHomeWeb.dart';
import 'package:challenger/web/profile/components/UserHomeWebPage.dart';
import 'package:challenger/web/profile/profile/ProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  UserManager userManager;

  SideBar(this.userManager);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                "Hello",
                style: TextStyle(fontSize: 21, color: WebGlobalConstants.hardBlack),
              )
          ),
          Divider(),
          ListTile(
            title: Text("Home"),
            leading: Icon(Icons.person_rounded),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => UserHomeWeb(widget.userManager),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ));
            },
          ),
          ListTile(
            title: Text("Profile"),
            leading: Icon(Icons.person_rounded),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => ProfilePage(widget.userManager),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ));
            },
          )
        ],
      ),

    );
  }
}
