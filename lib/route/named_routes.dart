import 'package:flutter/material.dart';
import 'package:simple_chat/components/pages/home_page.dart';
import 'package:simple_chat/components/pages/sign_in_page.dart';
import 'package:simple_chat/components/shared/message_list_page.dart';

class NamedRoute {
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notFound = '/not-found';
  static const String chat = '/chat';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const SignInPage(),
    home: (_) => const HomePage(),
    /*register: (context) => RegisterPage(),
    profile: (context) => ProfilePage(),
    settings: (context) => SettingsPage(),
    notFound: (context) => NotFoundPage(),*/
    chat: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as List;
      return MessageListPage(
        avatarUrl: args[0] as String,
        contactName: args[1] as String,
        chatId: args[2] as int,
      );
    },
  };
}