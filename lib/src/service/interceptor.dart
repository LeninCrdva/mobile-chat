import 'package:dio/dio.dart';
import 'package:simple_chat/main.dart';
import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/src/service/config_service.dart';
import 'package:simple_chat/src/storage/token.dart';
import 'package:simple_chat/src/service/session_service.dart';

class DioInterceptor extends Interceptor {
  Token token = tokenFromBox!;
  final Box<Token> _tokenBox = objectBox.store.box<Token>();
  final url = '${ConfigService.apiUrl}auth/refresh-token';

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
        'STATUS: [${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} AT ${DateTime.now()}');

    if ((err.response?.statusCode == 401)) {
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

    print('RETRYING REQUEST with extra: ${requestOptions.extra} and options: ${requestOptions}');

    return dio.request(
        '${requestOptions.baseUrl}${requestOptions.path}',
        queryParameters: requestOptions.queryParameters,
        data: await requestOptions.data,
        options: Options(
          contentType: requestOptions.contentType,
          headers: requestOptions.headers,
          method: requestOptions.method,
          responseType: requestOptions.responseType,
          validateStatus: requestOptions.validateStatus,
          sendTimeout: requestOptions.sendTimeout,
          receiveTimeout: requestOptions.receiveTimeout,
          extra: requestOptions.extra,
        ),
    );
  }

  Future<bool> refreshToken() async {
    if (token.refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await Dio().post(
        url,
        data: {'refreshJwt': token.refreshToken},
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['accessToken'];
        token.accessToken = accessToken;
        _tokenBox.put(token);

        return true;
      } else {
        SessionService.closeSession();
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
