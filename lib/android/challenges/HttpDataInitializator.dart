import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:http/http.dart' as http;
import 'package:neat_periodic_task/neat_periodic_task.dart';

class HttpDataInitializator {
  static const int initializationSchedulerDelaySeconds = 10;
  static const int schedulerIntervalSeconds = 30;

  static final HttpDataInitializator _singleton =
      HttpDataInitializator._internal();

  HttpDataInitializator._internal();

  // singleton
  factory HttpDataInitializator() {
    return _singleton;
  }

  static NeatPeriodicTaskScheduler scheduler;

  static List<ChallengeModel> _allChallenges;

  static Future<List<ChallengeModel>> get allChallenges async {
    // initial attempt
    if (_allChallenges == null) {
      _allChallenges = await _fetchChallenges();
    }
    return _allChallenges;
  }

  static initFetchScheduler() async {
    log("Initializing fetch scheduler after $initializationSchedulerDelaySeconds delay...");
    Future.delayed(const Duration(seconds: initializationSchedulerDelaySeconds), () async {
      log("Initializing fetch scheduler...");
      if (scheduler == null) {
        scheduler = NeatPeriodicTaskScheduler(
          interval: Duration(seconds: schedulerIntervalSeconds),
          name: 'fetch-challenges',
          timeout: Duration(seconds: 5),
          task: () async => _allChallenges = await _fetchChallenges(),
          minCycle: Duration(seconds: 5),
        );

        scheduler.start();
        await ProcessSignal.sigterm.watch().last;
        log("Stopping fetch scheduler...");
        await scheduler.stop();
      }
    });
  }

  static Future<List<ChallengeModel>> _fetchChallenges() async {
    var url = Uri.parse('http://192.168.0.103/api/v1/challenges');
    final response = await http.get(url);

    log('Performing a data sync:  ${response.body}');
    if (response.statusCode == 200) {
      return ChallengeModel.fromList(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
