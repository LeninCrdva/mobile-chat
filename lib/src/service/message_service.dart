import 'dart:async';

import 'package:dio/dio.dart';
import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/src/model/message.dart';
import 'package:simple_chat/src/model/message_request.dart';
import 'package:simple_chat/src/repository/data_manager.dart';
import 'package:simple_chat/src/service/toast_service.dart';
import 'package:simple_chat/src/shared/dio_client.dart';

class MessageService extends DataManager<Message> {
  late final Dio _dio;

  MessageService(Box<Message> box) : super(box) {
    _dio = DioClient().instance;
  }

  void loadMessages(int chatId) {
    getMessagesByChatId(chatId);
  }

  Future<void> sendMessage(MessageRequest message) async {
    final response =
        await _dio.post('messages/private', data: message.toJson());

    if (response.statusCode != 200) {
      ToastService().showSnackBar('Failed to send message');
      throw Exception('Failed to send message');
    }
  }

  Future<void> getMessagesByChatId(int chatId) async {
    String url = 'messages/messages';

    final response = await _dio.get(
      url,
      queryParameters: {
        'chatId': chatId,
      },
    );

    if (response.statusCode == 200) {
      List<Message> newMessages =
          (response.data as List).map((e) => Message.fromJson(e)).toList();

      for (var element in newMessages) {
        element.chat.targetId = chatId;
      }

      addItems(newMessages, removeAll: true);
    } else {
      throw Exception('Failed to get messages');
    }
  }
}
