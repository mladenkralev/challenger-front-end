import 'dart:convert';

import 'package:challenger/challenges/challenge.dart';
import 'package:challenger/configuration.dart';

import '../user/user.dart';
import 'user_manager.dart';
import 'package:http/http.dart' as http;

class ChallengeService {
  String jsonString = '''
  {
    "email": "test@abv.bg",
    "username": "test",
    "createdByUserChallenges": [
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

  static const String BACKEND_AUTH_SERVICE = "http://192.168.0.103";

  Future<User> upgradeProgressOfChallenge(UserManager userManager, int challengeIndex) async {
    var assignChallenge = userManager.getAssignChallenges()[challengeIndex];
    var usersUrl = Uri.parse(BACKEND_AUTH_SERVICE + '/api/v1/challenges/' + assignChallenge.id.toString() + "/progress");
    var token = userManager.user.token;

    print("Pressed" + usersUrl.toString());

    final userResponse = await http.post(usersUrl,
      headers: <String, String> {
        'Authorization': 'Bearer $token',
      },
    );

    print("Response from progress update" + userResponse.statusCode.toString());
    return getUserChallenges(token);
  }

  Future<User> getUserChallenges(String token) async {
    var usersUrl = Uri.parse(BACKEND_AUTH_SERVICE + '/api/v1/users');

    final userResponse = await http.get(usersUrl,
      headers: <String, String> {
        'Authorization': 'Bearer $token',
      },
    );

    Map<String, dynamic> userData = jsonDecode(userResponse.body);
    User user = User.fromJson(userData, token);
    print(user.challengeManager.getChallenges("assignedToUserChallenges"));
    userManager.attachUser(user);

    return user;
  }

  /// TESTING DUMMY DATA
  Future<User> getDummyChallenges(String token) async {

    Map<String, dynamic> userData = jsonDecode(jsonString);
    User user = User.fromJson(userData, token);
    print(user.challengeManager.getChallenges("assignedToUserChallenges"));
    userManager.attachUser(user);

    return user;
  }
}