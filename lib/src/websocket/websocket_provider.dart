import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/src/model/message.dart';
import 'package:simple_chat/src/model/message_request.dart';
import 'package:simple_chat/src/service/interceptor.dart';
import 'package:simple_chat/src/shared/dio_client.dart';
import 'package:simple_chat/src/storage/token.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketProvider with ChangeNotifier {
  final baseUrl = 'http://192.168.1.176:8080/api/v1/simple-chat-websocket';
  late StompClient client;
  final Token token = tokenFromBox!;
  bool _isConnected = false;
  final List<Message> _messages = List.empty(growable: true);

  bool get isConnected => _isConnected;
  List<Message> get messages => _messages;

  Future<void> initialize() async {
    final Map<String, String> headers = { 'Authorization': 'Bearer ${token.accessToken}' };

    client = StompClient(
        config: StompConfig.sockJS(
          url: baseUrl,
          onConnect: onConnect,
          onStompError: onError,
          stompConnectHeaders: headers,
          webSocketConnectHeaders: headers,
          onWebSocketError: (dynamic error) => print('WebSocket error: $error'),
          reconnectDelay: const Duration(milliseconds: 5000),
        )
    );
  }

  void onConnect(StompFrame stompFrame) {
    client.subscribe(
        destination: '/user/specific',
        callback: (StompFrame frame) {
          print('Received: ${frame.body!}');
          //_messages.add(Message.fromJson(jsonDecode(frame.body!)));
          notifyListeners();
        }
    );
  }

  void onError(dynamic error) {
    _isConnected = false;
  }

  void sendMessage(MessageRequest message) {
    client.send(
        destination: '/app/private',
        body: jsonEncode(message.toJson()),
    );
  }

  void connect() {
    client.activate();
  }

  void disconnect() {
    client.deactivate();
  }
}
