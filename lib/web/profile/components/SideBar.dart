import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:challenger/web/profile/BrowseChallenge.dart';
import 'package:challenger/web/profile/TreeChallenge.dart';
import 'package:challenger/web/profile/UserHomeWeb.dart';
import 'package:challenger/web/profile/pages/ChallengeTree.dart';
import 'package:challenger/web/profile/pages/UserHomeWebPage.dart';
import 'package:challenger/web/profile/ProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  UserManagerService userManager;

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
             Get.to(UserHomeWeb(widget.userManager));
            },
          ),
          ListTile(
            title: Text("Browse"),
            leading: Icon(Icons.density_large_rounded),
            onTap: () {
              Get.to(BrowseChallenge(widget.userManager));
            },
          ),
          ListTile(
            title: Text("Profile"),
            leading: Icon(Icons.person_rounded),
            onTap: () {
              Get.to(ProfilePage(widget.userManager));
            },
          ),
          ListTile(
            title: Text("Challenge Tree"),
            leading: Icon(Icons.person_rounded),
            onTap: () {
              Get.to(TreeChallenge(widget.userManager));
            },
          )
        ],
      ),

    );
  }
}
