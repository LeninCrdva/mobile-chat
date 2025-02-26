import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:internet_connectivity_checker/internet_connectivity_checker.dart';
import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/src/model/chat.dart';
import 'package:simple_chat/src/repository/data_manager.dart';
import 'package:simple_chat/src/service/toast_service.dart';
import 'package:simple_chat/src/shared/dio_client.dart';
import 'package:simple_chat/src/utils/token_claim.dart';
import 'package:sse_stream/sse_stream.dart';

class ChatService extends DataManager<Chat> {
  late final Dio _dio;
  final ConnectivityChecker _connectivityChecker = ConnectivityChecker(interval: const Duration(seconds: 10));
  // StreamSubscription<bool>? _connectivitySubscription;
  // StreamSubscription<SseEvent>? _sseSubscription;

  ChatService(Box<Chat> box) : super (box) {
    _dio = DioClient().instance;
  }

  /*void receiveMessages() {
    _connectivitySubscription = _connectivityChecker.stream.listen(
      (bool isOnline) {
        if (isOnline) {
          startSseConnection();
        } else {
          _sseSubscription?.cancel();
        }
      },
      onError: (Object error) {
        ToastService().showSnackBar('Failed to connect to the server');
      },
    );
  }*/

  void startSseConnection() async {

    if (tokenFromBox?.accessToken == null || tokenFromBox?.refreshToken == null) {
      return;
    }

    try {
      print('TRIYING TO CONNECT at ${DateTime.now()}');

      final userId = await TokenClaims().extractIntClaim('userId');

      final Response<ResponseBody> response = await _dio.get(
        'chat/$userId/events',
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(minutes: 30),
        ),
      );

      //_sseSubscription =
      response.data?.stream
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .transform(const SseEventTransformer())
          .listen(
            (event) {

          final dataFromJson = jsonDecode(event.data ?? '');
          final data = Chat.fromJson(dataFromJson['data']);

          addItem(data);
        },
        /*onError: (Object error) {
              _sseSubscription?.cancel();
              _sseSubscription = null;
              ToastService().showSnackBar('Failed to establish connection');
            },*/
      );
    } catch (e) {
      //_sseSubscription = null;
      ToastService().showSnackBar('Failed to establish khjkconnection');
    }
  }

  void loadChats() {
    getChatsByUserId();
  }

  Future<void> getChatsByUserId() async {
    String url = 'chat/chat-by-user';

    int userId = await TokenClaims().extractIntClaim('userId');

    final response = await _dio.get(
        url,
        queryParameters: {
          'userId': userId,
        }
    );

    if (response.statusCode == 200) {

      List<Chat> newChats = (response.data as List).map((e) => Chat.fromJson(e)).toList();

      addItems(newChats, removeAll: true);
    } else {
      throw Exception('Failed to get chats');
    }
  }

  Future<void> createLocalChat() async {
    await Future.delayed(const Duration(seconds: 10));

    final ch = Chat.fromJson(
        {
          'id': 61,
          'lastMessage': {
            'id': 1,
            'content': 'Hello',
            'type': 'text',
            'senderUsername': 'user1',
            'receiver': 'user2',
            'sendAt': DateTime.now().toIso8601String(),
          },
          'chatInfo': {
            'id': 1,
            'sender': 'Chat 1',
            'receiver': 'user2',
            'receiverAvatar': 'https://placehold.co/800@3x.png',
          },
        }
    );
    addItem(ch);
  }

  void dispose() {
    print('SSE Closed');
    /*_connectivitySubscription?.cancel();
    _sseSubscription?.cancel();*/
  }
}