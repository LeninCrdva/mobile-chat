import 'package:dio/dio.dart';
import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/route/named_routes.dart';
import 'package:simple_chat/src/storage/token.dart';

class DioInterceptor extends Interceptor {
  Token token = tokenFromBox!;
  final Box<Token> _tokenBox = objectBox.store.box<Token>();

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (token.accessToken.isNotEmpty) {
      options.headers['Accept'] = '*/*';
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('ERROR MESSAGE: ${err.response?.data} a ${err.requestOptions.extra}');

    if ((err.response?.statusCode == 401 &&
        err.response?.data['error'] == 'Token JWT expirado')) {
      if (token.accessToken.isNotEmpty) {
        if (await refreshToken()) {
          final newOptions = err.requestOptions
            ..headers['Authorization'] = 'Bearer ${token.accessToken}';

          handler.resolve(await _retry(newOptions));
          return;
        }
      }
    }

    super.onError(err, handler);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final dio = Dio();

    final options = Options(
      method: requestOptions.method,
      headers: {
        'Accept': '*/*',
        'Authorization': 'Bearer ${token.accessToken}',
      },
      extra: requestOptions.extra,
    );

    return dio.request(requestOptions.path,
        queryParameters: requestOptions.queryParameters,
        data: await requestOptions.data,
        options: options);
  }

  Future<bool> refreshToken() async {
    print('${token.refreshToken} and then ${token.accessToken}');
    if (token.refreshToken.isEmpty) {
      return false;
    }

    const url = 'http://192.168.1.176:8080/api/v1/auth/refresh-token';

    final response = await Dio().post(
      url,
      data: {'refreshJwt': token.refreshToken},
    );

    if (response.statusCode == 200) {
      final accessToken = response.data['accessToken'];
      token.accessToken = accessToken;
      _tokenBox.put(token);

      return true;
    } else {
      _tokenBox.remove(token.id);

      if (response.data['error'] == 'Token JWT expired') {
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil(NamedRoute.login, (route) => false);
      }

      return false;
    }
  }
}
