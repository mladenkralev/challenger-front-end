import 'package:challenger/configuration.dart';
import 'package:challenger/services/login_service.dart';
import 'package:challenger/user/user_manager.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final UserManager userManager;

  LoginPage(this.userManager);

  @override
  State<StatefulWidget> createState() => new _LoginPageState(this.userManager);
}

// Used for controlling whether the user is logging or creating an account
enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  Color primaryColor = Colors.white;
  Color secondaryColor = Colors.white60;

  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();

  String _email = "";
  String _password = "";
  FormType _form = FormType.login;

  UserManager userManager;

  final loginService = locator<LoginService>();

  _LoginPageState(UserManager userManager) {
    this.userManager = userManager;

    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  // Swap in between our two forms, registering and logging in
  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // appBar: _buildBar(context),
        body: new Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/home_image_1.jpg"),
                fit: BoxFit.cover
            )
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _buildTextFields(),
                _buildButtons(),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              style: TextStyle(color: primaryColor),
              controller: _emailFilter,
              decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      color: primaryColor
                  )
              ),
            ),
          ),
          new Container(
            child: new TextField(
              style: TextStyle(color: primaryColor),
              controller: _passwordFilter,
              decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      color: primaryColor
                  )
              ),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20),
              width: double.maxFinite,
              child: new ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: primaryColor
                ),
                child: new Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
                onPressed: _loginPressed,
              ),
            ),
            new TextButton(
              child: new Text(
                "Don't have an account? Tap here to register.",
                style: TextStyle(
                    color: secondaryColor
                ),
              ),
              onPressed: _formChange,
            ),
            new TextButton(
              child: new Text(
                'Forgot Password?',
                style: TextStyle(
                    color: secondaryColor
                ),

              ),
              onPressed: _passwordReset,
            )
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(top: 20),
              child: new ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: primaryColor
                ),
                child: new Text(
                  'Create an Account',
                   style: TextStyle(
                    color: Colors.black
                  ),
                ),
                onPressed: _createAccountPressed,
              ),
            ),
            new TextButton(
              child: new Text(
                'Have an account? Click here to login.',
                style: TextStyle(
                  color: secondaryColor
                ),
              ),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
  }

  // These functions can self contain any user auth logic required, they all have access to _email and _password

  void _loginPressed() {
    loginService.loginAndSwitchToUserScreen(userManager, _email, _password, context);
  }

  void _createAccountPressed() {
    loginService.createAccountPressed();
  }

  void _passwordReset() {
    loginService.passwordReset();
  }
}
