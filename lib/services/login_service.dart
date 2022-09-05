import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:challenger/configuration.dart';
import 'package:challenger/screens/user/profile/home_page.dart';
import 'package:challenger/services/challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../user/user.dart';
import 'asset_service.dart';
import 'user_manager.dart';
import 'package:challenger/user/user.dart';
import 'package:challenger/services/user_manager.dart';
import 'package:http/http.dart' as http;

class LoginService {
  final challengeService = locator<ChallengeService>();
  final assetService = locator<AssetService>();

  UserManager userManager;

  // static const String BACKEND_AUTH_SERVICE = "http://192.168.0.103";
  static const String BACKEND_AUTH_SERVICE = "http://localhost:8080";

  void loginAndSwitchToUserScreen(UserManager userManager , String _email, String _password, BuildContext context) async {
    await login(_email, _password, context, userManager);
  }


  void createAccountPressed() async {
    print('The user wants to create an account');
  }

  void passwordReset() async {
    print("The user wants a password reset");
  }

  Future<User> login(String email, String password, BuildContext context, UserManager userManager) async {
    log('Login with email $email');

    // String token = "123";
    // User user = await challengeService.getDummyChallenges(token);
    // Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => UserHomePage(userManager),
    //           ));
    Response response = await sendLoginRequest(email, password);

    if (response.statusCode == 200) {
      Map<String, dynamic> body =  jsonDecode(response.body);
      String token = body['jwt'];

      User user = await challengeService.getUserChallenges(token);
      print("new user is " + user.username);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserHomePage(userManager),
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

    return http.post(jwtAuthenticationUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
  }


}