import 'dart:convert';
import 'dart:developer';

import 'package:challenger/screens/user/profile/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

import '../user/user.dart';
import '../user/user_manager.dart';
import 'package:challenger/user/user.dart';
import 'package:challenger/user/user_manager.dart';
import 'package:http/http.dart' as http;

class LoginService {
  UserManager userManager;

  static const String BACKEND_AUTH_SERVICE = "http://192.168.0.103";

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

    Response response = await sendLoginRequest(email, password);

    if (response.statusCode == 200) {
      var usersUrl = Uri.parse(BACKEND_AUTH_SERVICE + '/api/v1/users');
      Map<String, dynamic> body =  jsonDecode(response.body);
      String token = body['jwt'];
      final userResponse = await http.get(usersUrl,
        headers: <String, String> {
          'Authorization': 'Bearer $token',
        },
      );
      Map<String, dynamic> userData = jsonDecode(userResponse.body);
      User user = User.fromJson(userData, token);
      userManager.attachUser(user);

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
    var jwtAuthenticationUrl = Uri.parse(BACKEND_AUTH_SERVICE + '/api/v1/authenticate');

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