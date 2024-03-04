import 'dart:async';
import 'dart:convert';

import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../model/AssignedChallenges.dart';

class AssignedChallengeService {
  final userManager = locator<UserManagerService>();

  // static const String BACKEND_AUTH_SERVICE = "http://192.168.0.103";
  static String HTTP_BACKEND_SERVICE = "http://localhost:8080";
  static String WS_BACKEND_SERVICE = "ws://localhost:8080";
  StreamController<List<AssignedChallenges>> _challengeDataController =
      StreamController<List<AssignedChallenges>>.broadcast();
  StompClient? stompClient;

  AssignedChallengeService() {
    if (kIsWeb) {
      //web
      HTTP_BACKEND_SERVICE = "http://localhost:8080";
      WS_BACKEND_SERVICE = "ws://localhost:8080";
    } else {
      //phone
      HTTP_BACKEND_SERVICE = "http://10.0.2.2:8080";
      WS_BACKEND_SERVICE = "ws://10.0.2.2:8080";
    }
  }

  void upgradeProgressOfChallenge(int? challengeIndex) async {
    print("Updating progress of challenge with id" + challengeIndex.toString());

    var usersUrl = Uri.parse(HTTP_BACKEND_SERVICE +
        '/api/v1/challenges/' +
        challengeIndex.toString() +
        "/progress");
    var token = userManager.user?.token;

    print("Pressed " + usersUrl.toString());

    final userResponse = await http.post(
      usersUrl,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Access-Control-Allow-Origin': 'http://siteA.com',
        'Access-Control-Allow-Methods': 'GET, POST, PUT',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );

    print(
        "Response from progress update " + userResponse.statusCode.toString());
  }

  void assignChallengeToCurrentUser(int? id, int? challengeIndex) async {
    print("Assign challenge to user" + challengeIndex.toString());

    var usersUrl = Uri.parse(HTTP_BACKEND_SERVICE +
        '/api/v1/challenges/' +
        id!.toString() +
        '/' +
        challengeIndex.toString());
    var token = userManager.user?.token;

    print("Pressed " + usersUrl.toString());

    final userResponse = await http.post(
      usersUrl,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Access-Control-Allow-Origin': 'http://siteA.com',
        'Access-Control-Allow-Methods': 'GET, POST, PUT',
        'Access-Control-Allow-Headers': 'Content-Type',
      },
    );

    print("Response from assigning challenge " +
        userResponse.statusCode.toString());
  }

  Stream<List<AssignedChallenges>> getUserChallenges(String token) {
    connectAndSubscribe(token!);

    return _challengeDataController.stream.asBroadcastStream();
  }

  Future<void> connectAndSubscribe(String token) async {
    StompConfig conf = StompConfig(
      url:  WS_BACKEND_SERVICE + '/websocket',
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
        destination: '/assigned-response',
        headers: {},
        callback: (frame) {
          if (frame.body != null) {
            // Received a frame for this subscription
            String? body = frame.body;
            List<dynamic> assignedData = jsonDecode(body!);
            List<AssignedChallenges> currentResult =
                getAssignedChallenges(assignedData);

            _challengeDataController.add(currentResult);
            // for (HistoryChallenge item in currentResult!) {
            //   print('ITEM: ' + item.toString());
            // }
          }
        });

    // initial
    sendServerUpdate();

    Timer.periodic(Duration(seconds: 2), (Timer t) => sendServerUpdate());
  }

  void sendServerUpdate() {
    // print('Sending server an update ...');
    stompClient?.send(
      destination: '/assigned',
      body: userManager.user?.email,
      headers: {},
    );
  }

  List<AssignedChallenges> getAssignedChallenges(
      List<dynamic> assignedChallenges) {
    List<AssignedChallenges> result = [];
    for (var item in assignedChallenges) {
      // Access individual items in the list using the 'item' variable
      // Perform operations or access properties of each item here
      AssignedChallenges challenge = AssignedChallenges.fromJson(item);
      result.add(challenge);
    }
    return result;
  }
}
