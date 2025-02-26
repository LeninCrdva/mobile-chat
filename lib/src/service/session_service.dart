import 'package:simple_chat/main.dart';
import 'package:simple_chat/route/named_routes.dart';
import 'package:simple_chat/src/model/chat.dart';
import 'package:simple_chat/src/model/chat_info.dart';
import 'package:simple_chat/src/model/message.dart';
import 'package:simple_chat/src/model/user.dart';
import 'package:simple_chat/src/service/toast_service.dart';
import 'package:simple_chat/src/storage/token.dart';

class SessionService {
  
  SessionService._();

  static void _deleteAllData<T>() {
    objectBox.store.box<T>().removeAll();
  }

  static void closeSession() {
    final entities = [User, Token, Chat, ChatInfo, Message];
    for (var entity in entities) {
      if (entity == User) {
        _deleteAllData<User>();
      } else if (entity == Token) {
        _deleteAllData<Token>();
      } else if (entity == Chat) {
        _deleteAllData<Chat>();
      } else if (entity == ChatInfo) {
        _deleteAllData<ChatInfo>();
      } else if (entity == Message) {
        _deleteAllData<Message>();
      } else if (entity == Token) {
        _deleteAllData<Token>();
      }
    }

    navigatorKey.currentState!.pushNamedAndRemoveUntil(NamedRoute.login, (route) => false);

    ToastService().showSnackBar('Session closed');
  }
}