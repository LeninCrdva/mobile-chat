import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/src/model/auth_request.dart';
import 'package:simple_chat/src/service/config_service.dart';
import 'package:simple_chat/src/storage/token.dart';

class AuthServiceProvider with ChangeNotifier {
  final Box<Token> _tokenBox = objectBox.store.box<Token>();
  final baseUrl = ConfigService.apiUrl;

  late final Dio _dio;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthServiceProvider() {
    _dio = Dio();
  }

  Future<void> login(AuthRequest authRequest) async {
    String url = '${baseUrl}auth/sign-in';

    final response = await _dio.post(
      url,
      data: authRequest.toJson(),
    );

    if (response.statusCode == 200) {
      _isLoggedIn = true;

      final token = Token.fromJson(response.data);
      token.id = 1;
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
