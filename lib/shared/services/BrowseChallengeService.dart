import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/ChallengeModel.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:challenger/shared/model/UserModel.dart';

import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../model/AssignedChallenges.dart';

class BrowseChallengeService {

  final userManager = locator<UserManagerService>();

  static const String BACKEND_AUTH_SERVICE = "http://localhost:8080";
  StreamController<List<ChallengeModel>> _challengeDataController = StreamController<List<ChallengeModel>>.broadcast();
  StompClient? stompClient;

  Stream<List<ChallengeModel>> getBrowsableChallenges(String token) {

    connectAndSubscribe(token!);

    return _challengeDataController.stream.asBroadcastStream();
  }

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
        destination: '/challenges-response',
        headers: {},
        callback: (frame) {
          if (frame.body != null) {
            // Received a frame for this subscription
            String? body = frame.body;
            List<dynamic> assignedData = jsonDecode(body!);
            List<ChallengeModel> currentResult = getBrowseChallenges(assignedData);

            _challengeDataController.add(currentResult);
            // for (HistoryChallenge item in currentResult!) {
            //   print('ITEM: ' + item.toString());
            // }
          }
        });

    // initial
    sendServerUpdate();

    Timer.periodic(
      Duration(seconds: 2),
          (Timer t) => sendServerUpdate()
    );
  }

  void sendServerUpdate() {
    // print('Sending server an update ...');
    stompClient?.send(
      destination: '/challenges',
      body: userManager.user?.email,
      headers: {},
    );
  }

  List<ChallengeModel> getBrowseChallenges(List<dynamic> assignedChallenges) {
    List<ChallengeModel> result = [];
    for (var item in assignedChallenges) {
      // Access individual items in the list using the 'item' variable
      // Perform operations or access properties of each item here
      ChallengeModel challenge = ChallengeModel.fromJson(item);
      result.add(challenge);
    }
    return result;
  }
}