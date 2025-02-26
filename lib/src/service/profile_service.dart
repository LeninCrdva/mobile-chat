import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/src/model/user.dart';
import 'package:simple_chat/src/service/config_service.dart';
import 'package:simple_chat/src/shared/dio_client.dart';

class ProfileService with ChangeNotifier {
  final Box<User> _tokenBox = objectBox.store.box<User>();
  final baseUrl = ConfigService.apiUrl;
  late final Dio _dio;

  User? get user => loadStorageProfile();

  ProfileService() {
    _dio = DioClient().instance;
  }

  loadStorageProfile() {
    if (_tokenBox.isEmpty()) {
      loadProfile();
      return;
    }

    return _tokenBox.getAll()[0];
  }

  void loadProfile() async {
    String url = 'auth/profile';

    await _dio
        .get(
      url,
    )
        .then((response) {
      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);
        _tokenBox.put(user);
        notifyListeners();
      } else {
        throw Exception('Failed to get profile');
      }
    });
  }
}
