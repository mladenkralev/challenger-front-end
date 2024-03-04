import 'dart:convert';
import 'dart:developer';

import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/UserModel.dart';
import 'package:challenger/shared/services/AssignedChallengeService.dart';
import 'package:challenger/web/profile/UserHomeWeb.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'AssetService.dart';
import 'UserManager.dart';

class LoginService {
  final challengeService = locator<AssignedChallengeService>();
  final assetService = locator<AssetService>();

  late UserManagerService userManager;

  // static const String BACKEND_AUTH_SERVICE = "http://192.168.0.103";
  static String BACKEND_AUTH_SERVICE = "http://10.0.2.2:8080";

  LoginService() {
    if (kIsWeb) {
      //web
      BACKEND_AUTH_SERVICE = "http://localhost:8080";
    } else {
      //phone
      BACKEND_AUTH_SERVICE = "http://10.0.2.2:8080";
    }
  }


  void loginAndSwitchToUserScreen(UserManagerService userManager, String _email,
      String _password, BuildContext context) async {
    await login(_email, _password, context, userManager);
  }

  void createAccountPressed() async {
    print('The user wants to create an account');
  }

  void passwordReset() async {
    print("The user wants a password reset");
  }

  Future<User> login(String email, String password, BuildContext context,
      UserManagerService userManager) async {
    log('Login with email $email');

    Response response = await sendLoginRequest(email, password);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      String token = body['jwt'];

      String userDataUrl = BACKEND_AUTH_SERVICE + '/api/v1/users';

      log('Getting user data from ' + userDataUrl);

      var usersUrl = Uri.parse(userDataUrl);

      final userResponse = await http.get(
        usersUrl,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Access-Control-Allow-Origin': 'http://siteA.com',
          'Access-Control-Allow-Methods': 'GET, POST, PUT',
          'Access-Control-Allow-Headers': 'Content-Type',
        },
      );

      Map<String, dynamic> userData = jsonDecode(userResponse.body);
      User user = new User(userData, token);
      userManager.attachUser(user);
      print("new user is " +
          user.username +
          " and his id is " +
          user.id.toString());

      var nextPage;
      nextPage = UserHomeWeb(userManager);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => nextPage,
          ));
      return user;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Response> sendLoginRequest(String email, String password) async {
    String loginUrl = BACKEND_AUTH_SERVICE + '/api/v1/authenticate';
    log('Send login request: ' + loginUrl);
    var jwtAuthenticationUrl = Uri.parse(loginUrl);

    return http.post(
      jwtAuthenticationUrl,
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        'Access-Control-Allow-Origin': 'http://siteA.com',
        'Access-Control-Allow-Methods': 'GET, POST, PUT',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Accept': '*/*',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
  }
}
