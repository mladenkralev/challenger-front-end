import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/StatisticsModel.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/shared/model/UserModel.dart';

import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../model/AssignedChallenges.dart';

class StatisticsService {
  final userManager = locator<UserManagerService>();

  // static const String BACKEND_AUTH_SERVICE = "http://192.168.0.103";
  static const String BACKEND_AUTH_SERVICE = "http://localhost:8080";

  Future<StatisticsModel> getUserStatistics() async {
    print("Getting user statistics...");

    var usersUrl = Uri.parse(BACKEND_AUTH_SERVICE +
        '/api/v1/' +
        userManager.user!.email +
        '/statistics');
    var token = userManager.user?.token;

    print("Pressed " + usersUrl.toString());

    final statistics = await http.get(
      usersUrl,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Access-Control-Allow-Origin': 'http://siteA.com',
        'Access-Control-Allow-Methods': 'GET, POST, PUT',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );
    print("Response from statistics " + statistics.statusCode.toString());

    Map<String, dynamic> statData = jsonDecode(statistics.body);
    StatisticsModel statisticsModel = StatisticsModel.fromJson(statData);

    print("Statistics data " + statData.toString());
    return statisticsModel;
  }
}
