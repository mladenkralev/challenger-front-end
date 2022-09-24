import 'package:challenger/shared/model/UserManager.dart';
import 'package:challenger/web/WebGlobalConstants.dart';
import 'package:challenger/web/profile/components/SideBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  UserManager userManager;

  ProfilePage(this.userManager);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String getUserGreeting() => "Good day, \n" + widget.userManager.username;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
              title: Text(getUserGreeting()),
              backgroundColor: Theme
                  .of(context)
                  .primaryColor,
              foregroundColor: WebGlobalConstants.foregroundColor,
              titleTextStyle: TextStyle(
                fontSize: Theme
                    .of(context)
                    .textTheme
                    .headline1
                    .fontSize,
              )
          ),
          drawer: SideBar(widget.userManager),
          body: Column(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Container(
                  color: Colors.red,
              )),
              Flexible(
                  flex: 3,
                  child: Container(
                    color: Colors.blue,
              )),
            ]
          )
      ),
    );
  }
}
