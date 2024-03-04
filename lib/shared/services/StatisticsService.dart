import 'dart:async';
import 'dart:convert';

import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/StatisticsModel.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StatisticsService {
  final userManager = locator<UserManagerService>();

  // static const String BACKEND_AUTH_SERVICE = "http://192.168.0.103";
  static String BACKEND_AUTH_SERVICE = "http://localhost:8080";

  StatisticsService() {
    if (kIsWeb) {
      //web
      BACKEND_AUTH_SERVICE = "http://localhost:8080";
    } else {
      //phone
      BACKEND_AUTH_SERVICE = "http://10.0.2.2:8080";
    }
  }

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
