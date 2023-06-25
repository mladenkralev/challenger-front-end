import 'dart:convert';
import 'dart:developer';

import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/UserManager.dart';
import 'package:challenger/shared/model/UserModel.dart';

import 'package:http/http.dart' as http;

import '../model/AssignedChallenges.dart';

class ChallengeService {
  String jsonString = '''
  {
    "email": "test@abv.bg",
    "username": "test",
    "createdByUserChallenges": [
        {
            "id": 3,
            "title": "You are a MACHINE!",
            "description": "Train every day for at least 20 minutes",
            "occurrences": "WEEK",
            "badges": [],
            "startDate": "2022-01-05",
            "endDate": "2022-01-31",
            "numberOfProgressHits": 0.0
        },
        {
            "id": 2,
            "title": "You are a MACHINE!",
            "description": "Train every day for at least 20 minutes",
            "occurrences": "DAY",
            "badges": [],
            "startDate": "2022-01-05",
            "endDate": "2022-01-31",
            "numberOfProgressHits": 0.0
        },
        {
            "id": 1,
            "title": "Knowledge is power!",
            "description": "Read a book every week!",
            "occurrences": "DAY",
            "badges": [],
            "startDate": "2022-01-05",
            "endDate": "2022-01-31",
            "numberOfProgressHits": 0.0
        }
    ],
    "assignedToUserChallenges": [
        {
            "id": 3,
            "title": "You are a MACHINE!",
            "description": "Train every day for at least 20 minutes",
            "occurrences": "WEEK",
            "badges": [],
            "startDate": "2022-01-05",
            "endDate": "2022-01-31",
            "numberOfProgressHits": 0.0
        },
        {
            "id": 2,
            "title": "You are a MACHINE!",
            "description": "Train every day for at least 20 minutes",
            "occurrences": "DAY",
            "badges": [],
            "startDate": "2022-01-05",
            "endDate": "2022-01-31",
            "numberOfProgressHits": 0.0
        },
        {
            "id": 1,
            "title": "Knowledge is power!",
            "description": "Read a book every week!",
            "occurrences": "DAY",
            "badges": [],
            "startDate": "2022-01-05",
            "endDate": "2022-01-31",
            "numberOfProgressHits": 0.0
        }
    ]
}

  ''';


  final userManager = locator<UserManager>();

  // static const String BACKEND_AUTH_SERVICE = "http://192.168.0.103";
  static const String BACKEND_AUTH_SERVICE = "http://localhost:8080";

  Future<User> upgradeProgressOfChallenge(int? challengeIndex) async {
    print("Updating progress of challenge with id" + challengeIndex.toString());
    
    var usersUrl = Uri.parse(BACKEND_AUTH_SERVICE + '/api/v1/challenges/' + challengeIndex.toString() + "/progress");
    var token = userManager.user?.token;

    print("Pressed " + usersUrl.toString());

    final userResponse = await http.post(usersUrl,
      headers: <String, String> {
        'Authorization': 'Bearer $token',
        'Access-Control-Allow-Origin': 'http://siteA.com',
        'Access-Control-Allow-Methods': 'GET, POST, PUT',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );

    print("Response from progress update " + userResponse.statusCode.toString());
    return getUserChallenges(token!);
  }

  Future<User> getUserChallenges(String token) async {
    String userDataUrl = BACKEND_AUTH_SERVICE + '/api/v1/users';

    log('Getting user data from ' + userDataUrl);

    var usersUrl = Uri.parse(userDataUrl);

    final userResponse = await http.get(usersUrl,
      headers: <String, String> {
        'Authorization': 'Bearer $token',
        'Access-Control-Allow-Origin': 'http://siteA.com',
        'Access-Control-Allow-Methods': 'GET, POST, PUT',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );

    Map<String, dynamic> userData = jsonDecode(userResponse.body);
    User user = new User(userData, token);
    print(user.challengeManager?.getChallenges("assignedToUserChallenges"));
    userManager.attachUser(user);

    return user;
  }

  /// TESTING DUMMY DATA
  Future<User> getDummyChallenges(String token) async {

    Map<String, dynamic> userData = jsonDecode(jsonString);
    User user = new User(userData, token);
    print(user.challengeManager?.getChallenges("assignedToUserChallenges"));
    userManager.attachUser(user);

    return user;
  }
}