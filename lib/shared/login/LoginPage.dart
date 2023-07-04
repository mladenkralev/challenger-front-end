import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/UserManager.dart';
import 'package:challenger/shared/services/LoginService.dart';
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
  String backgroundAssetLocalPath = "assets/chrome_login_wallpaper.jpg";

  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();

  String _email = "";
  String _password = "";
  FormType _form = FormType.login;
  var _isLoading = false;

  UserManager? userManager;

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
                image: AssetImage(backgroundAssetLocalPath),
                fit: BoxFit.cover)),
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
    return new AppBar();
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              style: TextStyle(color: Theme.of(context).primaryColor),
              controller: _emailFilter,
              decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          new Container(
            child: new TextField(
              style: TextStyle(color: Theme.of(context).primaryColor),
              controller: _passwordFilter,
              decoration: new InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor)),
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
              child: ElevatedButton.icon(
                icon: _isLoading
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.feedback),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle: TextStyle(color: Colors.black),
                ),
                label: const Text(
                  'Login',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: _isLoading ? null : _onSubmit,
              ),
            ),
            new TextButton(
              child: new Text(
                "Don't have an account? Tap here to register.",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              onPressed: _formChange,
            ),
            new TextButton(
              child: new Text(
                'Forgot Password?',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
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
                    primary: Theme.of(context).colorScheme.primary),
                child: new Text(
                  'Create an Account',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: _createAccountPressed,
              ),
            ),
            new TextButton(
              child: new Text(
                'Have an account? Click here to login.',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
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
    // loginService.loginAndSwitchToUserScreen(userManager, _email, _password, context);
    loginService.loginAndSwitchToUserScreen(
        userManager!, "test@abv.bg", "test", context);
  }

  void _createAccountPressed() {
    loginService.createAccountPressed();
  }

  void _passwordReset() {
    loginService.passwordReset();
  }

  void _onSubmit() {
    setState(() => _isLoading = true);
    _loginPressed();
  }
}
