import 'dart:async';
import 'dart:convert';

import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/HistoryChallenges.dart';
import 'package:challenger/shared/model/UserManager.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../model/AssignedChallenges.dart';

class HistoryChallengeService {
  final userManager = locator<UserManager>();

  // static const String BACKEND_AUTH_SERVICE = "http://192.168.0.103";
  static const String BACKEND_AUTH_SERVICE = "http://localhost:8080";
  final _historyDataController = StreamController<List<HistoryChallenge>>();

  Stream<List<HistoryChallenge>> fetchHistoryData() {
    print("Getting history of challenges");

    var usersUrl = Uri.parse(BACKEND_AUTH_SERVICE + '/api/v1/history');
    var token = userManager.user?.token;

    print("Pressed " + usersUrl.toString());
    // final history = await http.get(
    //   usersUrl,
    //   headers: <String, String>{
    //     'Authorization': 'Bearer $token',
    //     'Access-Control-Allow-Origin': 'http://siteA.com',
    //     'Access-Control-Allow-Methods': 'GET, POST, PUT',
    //     'Access-Control-Allow-Headers': 'Content-Type',
    //   },
    // );
    //
    // List<dynamic> historyData = jsonDecode(history.body);
    // List<HistoryChallenge> result = getHistoryData(historyData);
    connectAndSubscribe(token!);
    // if (stompClient!.isActive) {
    //   stompClient?.send(destination: '/your-destination', headers: {});
    // }

    return _historyDataController.stream;
  }

  List<HistoryChallenge> getHistoryData(List<dynamic> historyData) {
    List<HistoryChallenge> result = [];
    for (var item in historyData) {
      // Access individual items in the list using the 'item' variable
      // Perform operations or access properties of each item here
      Map<String, dynamic> json = item['assignedChallenges'];
      AssignedChallenges challenge = AssignedChallenges.fromJson(json);

      String progressDateJson = item['progressDate'];
      var historyChallenge =
          new HistoryChallenge(parseDate(progressDateJson), challenge);
      result.add(historyChallenge);
    }
    return result;
  }

  static DateTime parseDate(String date) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    return format.parse(date);
  }

  StompClient? stompClient;

  Future<void> connectAndSubscribe(String token) async {
    StompConfig conf = StompConfig(
      url: 'ws://localhost:8080/websocket',
      onConnect: onConnectCallback,
      onWebSocketError: (e) => print(e.toString()),
      onStompError: (d) => print('error stomp'),
      onDisconnect: (f) => print('disconnected'),
    );

    stompClient = StompClient(config: conf)..activate();

    print(stompClient?.isActive);
  }

  void onConnectCallback(StompFrame connectFrame) {
    stompClient?.subscribe(
        destination: '/your-topic',
        headers: {},
        callback: (frame) {
          if (frame.body != null) {
            // Received a frame for this subscription
            String? body = frame.body;
            List<dynamic> historyData = jsonDecode(body!);
            List<HistoryChallenge> currentResult = getHistoryData(historyData);

            _historyDataController.add(currentResult);
            // for (HistoryChallenge item in currentResult!) {
            //   print('ITEM: ' + item.toString());
            // }
          }
        });

    // initial
    stompClient?.send(
      destination: '/your-destination',
      headers: {},
    );

    Timer.periodic(
        Duration(seconds: 30),
        (Timer t) => stompClient?.send(
          destination: '/your-destination',
          headers: {},
        ),
    );
  }
}
