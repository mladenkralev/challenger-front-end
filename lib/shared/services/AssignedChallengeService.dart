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
  final UserManagerService userManager = locator<UserManagerService>();
  static String HTTP_BACKEND_SERVICE =
      kIsWeb ? "http://localhost:8080" : "http://10.0.2.2:8080";
  static String WS_BACKEND_SERVICE =
      kIsWeb ? "ws://localhost:8080/websocket" : "ws://10.0.2.2:8080/websocket";

  StreamController<List<AssignedChallenges>> _challengeDataController =
      StreamController<List<AssignedChallenges>>.broadcast();

  StompClient? stompClient;
  bool _isSubscribed = false;

  AssignedChallengeService() {}

  void _initStompClient() {
    StompConfig config = StompConfig(
      url: WS_BACKEND_SERVICE,
      onConnect: _onConnectCallback,
      beforeConnect: () async {
        print('Waiting to connect...');
        await Future.delayed(Duration(seconds: 1));
      },
      onWebSocketError: (dynamic error) => print(error.toString()),
      onStompError: (StompFrame frame) => print('STOMP Error: ${frame.body}'),
      onDisconnect: (StompFrame frame) =>
          {_isSubscribed = false, print('Disconnected')},
      stompConnectHeaders: {
        'Authorization': 'Bearer ${userManager.user?.token}'
      },
    );

    stompClient = StompClient(config: config);
    stompClient!.activate();
  }

  // Method to upgrade the progress of a challenge
  Future<void> upgradeProgressOfChallenge(int? challengeIndex) async {
    var url = Uri.parse(
        '$HTTP_BACKEND_SERVICE/api/v1/challenges/$challengeIndex/progress');
    try {
      var response = await http.post(
        url,
        headers: _headers(),
      );
      if (response.statusCode == 200) {
        print("Progress updated successfully.");
      } else {
        print("Failed to update progress: ${response.body}");
      }
    } catch (e) {
      print("Error upgrading progress of challenge: $e");
    }
    sendServerUpdate();
  }

  // Method to assign a challenge to the current user
  Future<void> assignChallengeToCurrentUser(int? id, int? challengeIndex) async {
    var url = Uri.parse(HTTP_BACKEND_SERVICE +
        '/api/v1/challenges/' +
        id!.toString() +
        '/' +
        challengeIndex.toString());
    try {
      var response = await http.post(
        url,
        headers: _headers(),
      );
      if (response.statusCode == 200) {
        print("Challenge assigned successfully.");
      } else {
        print("Failed to assign challenge: ${response.body}");
      }
    } catch (e) {
      print("Error assigning challenge to current user: $e");
    }
  }

  Map<String, String> _headers() => {
        'Authorization': 'Bearer ${userManager.user?.token}',
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        // Adjust this according to your CORS policy
      };

  Stream<List<AssignedChallenges>> getUserChallenges() {
    return _challengeDataController.stream.asBroadcastStream();
  }

  void dispose() {
    _challengeDataController.close();
    stompClient?.deactivate();
  }

  void _onConnectCallback(StompFrame frame) {
    if (!_isSubscribed) {
      stompClient?.subscribe(
        destination: '/assigned-response',
        headers: {},
        callback: (StompFrame frame) {
          if (frame.body != null) {
            List<dynamic> assignedData = jsonDecode(frame.body!);
            List<AssignedChallenges> currentResult =
                getAssignedChallenges(assignedData);
            _challengeDataController.add(currentResult);
          }
        },
      );
      _isSubscribed = true; // Mark as subscribed
      sendServerUpdate(); // Initial update
      // Consider if you still need this Timer here
      Timer.periodic(Duration(seconds: 30),
          (Timer t) => sendServerUpdate()); // Adjust frequency as needed
    }
  }

  void activateWebSocketConnection() {
    if (userManager.user?.email != null && !_isSubscribed) {
      _initStompClient(); // This now activates the connection
    } else {
      sendServerUpdate(); // update
    }
  }

  void sendServerUpdate() {
    print('Sending server an update ...');
    stompClient?.send(
      destination: '/assigned',
      body: userManager.user?.email,
      headers: {},
    );
  }

  List<AssignedChallenges> getAssignedChallenges(
      List<dynamic> assignedChallenges) {
    return assignedChallenges
        .map((item) => AssignedChallenges.fromJson(item))
        .toList();
  }
}
