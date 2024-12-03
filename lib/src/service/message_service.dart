import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/src/model/message.dart';
import 'package:simple_chat/src/service/config_service.dart';
import 'package:simple_chat/src/service/toast_service.dart';
import 'package:simple_chat/src/shared/dio_client.dart';

class MessageService with ChangeNotifier {
  final Box<Message> _messagesBox = objectBox.store.box<Message>();
  late final Dio _dio;
  final int chatId;
  final baseUrl = ConfigService.apiUrl;

  List<Message> _messages = [];
  List<Message> get messages => _messages;

  MessageService(this.chatId) {
    _dio = DioClient().instance;
  }

  void loadChat(int chatId) {
    _clearMessages();
    _loadLocalMessages(chatId);
    getMessagesByChatId(chatId);
  }

  void _clearMessages() {
    _messages = [];
    notifyListeners();
  }

  void _loadLocalMessages(int chatId) {
    _messages = _messagesBox.getAll().where((element) => element.chat.targetId == chatId).toList();

    ToastService().showSnackBar("${_messages.length} messages loaded from local storage with the chat id $chatId");

    notifyListeners();
  }

  Future<void> getMessagesByChatId(int chatId) async {
    String url = '${baseUrl}messages/messages';

    final response = await _dio.get(
        url,
        queryParameters: {
          'chatId': chatId,
        }
    );

    if (response.statusCode == 200) {
      List<Message> newMessages = (response.data as List).map((e) => Message.fromJson(e)).toList();

      if (newMessages != messages) {
        for (var element in newMessages) {
          element.chat.targetId = chatId;
          _messagesBox.put(element);
        }

        _messages = newMessages;

        notifyListeners();
      }

    } else {
      throw Exception('Failed to get messages');
    }
  }
}