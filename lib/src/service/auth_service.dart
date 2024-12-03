import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/src/model/auth_request.dart';
import 'package:simple_chat/src/storage/token.dart';

class AuthServiceProvider with ChangeNotifier {
  final Box<Token> _tokenBox = objectBox.store.box<Token>();

  late final Dio _dio;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthServiceProvider() {
    _dio = Dio();
  }

  Future<void> login(AuthRequest authRequest) async {
    const String url = 'http://192.168.1.176:8080/api/v1/auth/sign-in';

    final response = await _dio.post(
      url,
      data: authRequest.toJson(),
    );

    if (response.statusCode == 200) {
      _isLoggedIn = true;

      final token = Token.fromJson(response.data);
      _tokenBox.put(token);
      tokenFromBox = token;

      notifyListeners();
    } else if (response.statusCode == 401) {
      throw Exception('Failed to login');
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
