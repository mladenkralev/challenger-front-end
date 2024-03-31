import 'dart:async';
import 'dart:convert';

import 'package:challenger/DependencyInjection.dart';
import 'package:challenger/shared/model/AssignedChallenges.dart';
import 'package:challenger/shared/model/HistoryChallenges.dart';
import 'package:challenger/shared/services/UserManager.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class HistoryChallengeService {
  final UserManagerService userManager = locator<UserManagerService>();

  static String HTTP_BACKEND_SERVICE = kIsWeb ? "http://localhost:8080" : "http://10.0.2.2:8080";
  static String WS_BACKEND_SERVICE = kIsWeb ? "ws://localhost:8080/websocket" : "ws://10.0.2.2:8080/websocket";
  StreamController<List<HistoryChallenge>> _historyDataController = StreamController<List<HistoryChallenge>>.broadcast();
  StompClient? stompClient;
  Timer? _periodicUpdateTimer;

  HistoryChallengeService() {
    // URLs are already set based on platform
  }

  void activateWebSocketConnection() {
    if (userManager.user?.token != null && (stompClient == null || !stompClient!.connected)) {
      connectAndSubscribe(userManager.user!.token!);
    } else {
      sendServerUpdate();
    }
  }

  Stream<List<HistoryChallenge>> fetchHistoryData() {
    if (stompClient == null || !stompClient!.connected) {
      connectAndSubscribe(userManager.user!.token);
    }
    // Always return a stream, even if it's empty initially.
    return _historyDataController.stream.asBroadcastStream();
  }

  Future<void> connectAndSubscribe(String token) async {
    StompConfig conf = StompConfig(
      url: WS_BACKEND_SERVICE,
      onConnect: onConnectCallback,
      onWebSocketError: (e) => print(e.toString()),
      onStompError: (d) => print('STOMP Error: $d'),
      onDisconnect: (f) => print('Disconnected'),
      stompConnectHeaders: {'Authorization': 'Bearer $token'},
    );

    stompClient = StompClient(config: conf)..activate();
  }

  void onConnectCallback(StompFrame connectFrame) {
    stompClient?.subscribe(
      destination: '/history-response',
      callback: (frame) {
        List<dynamic> historyData = jsonDecode(frame.body!);
        List<HistoryChallenge> currentResult = getHistoryData(historyData);
        _historyDataController.add(currentResult);
      },
    );

    sendServerUpdate();
    _periodicUpdateTimer?.cancel(); // Cancel any existing timer
    _periodicUpdateTimer = Timer.periodic(Duration(seconds: 30), (Timer t) => sendServerUpdate());
  }

  void sendServerUpdate() {
    print('Sending history server an update ...');
    stompClient?.send(
      destination: '/history',
      body: jsonEncode({'request': 'update'}),
      headers: {},
    );
  }

  Stream<List<HistoryChallenge>> get historyDataStream => _historyDataController.stream.asBroadcastStream();

  List<HistoryChallenge> getHistoryData(List<dynamic> historyData) {
    // Your parsing logic seems appropriate; ensure 'assignedChallenges' and 'progressDate' match your JSON structure
    return historyData.map((item) {
      Map<String, dynamic> json = item['assignedChallenges'];
      AssignedChallenges challenge = AssignedChallenges.fromJson(json);
      DateTime progressDate = parseDate(item['progressDate']);
      return HistoryChallenge(progressDate, challenge);
    }).toList();
  }

  static DateTime parseDate(String date) {
    return DateFormat("yyyy-MM-dd").parse(date);
  }

  void dispose() {
    _periodicUpdateTimer?.cancel();
    _historyDataController.close();
    stompClient?.deactivate();
  }
}