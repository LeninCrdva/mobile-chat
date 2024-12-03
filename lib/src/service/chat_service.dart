import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/src/model/chat.dart';
import 'package:simple_chat/src/service/config_service.dart';
import 'package:simple_chat/src/shared/dio_client.dart';

import '../utils/token_claim.dart';

class ChatService with ChangeNotifier {
  final Box<Chat> _chatBox = objectBox.store.box<Chat>();
  List<Chat> _chats = [];
  late final Dio _dio;
  final baseUrl = ConfigService.apiUrl;

  List<Chat> get chats => _chats;

  ChatService() {
    _dio = DioClient().instance;
    _loadLocalChats();
    getChatsByUserId();
    print('chats: ${_chats.length} then ${chats.length}');
  }

  void _loadLocalChats() {
    _chats = _chatBox.getAll();

    notifyListeners();
  }

  Future<void> getChatsByUserId() async {
    String url = '${baseUrl}chat/chat-by-user';

    int userId = await TokenClaims().extractIntClaim('userId');

    final response = await _dio.get(
        url,
        queryParameters: {
          'userId': userId,
        }
    );

    print(response);

    if (response.statusCode == 200) {
      List<Chat> newChats = (response.data as List).map((e) => Chat.fromJson(e)).toList();

      if (newChats != _chats) {
        _chats = newChats;
        _chatBox.removeAll();
        _chatBox.putMany(_chats);

        notifyListeners();
      }
    } else {
      throw Exception('Failed to get chats');
    }
  }
}