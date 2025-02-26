import 'package:dio/dio.dart';
import 'package:simple_chat/src/service/config_service.dart';
import 'package:simple_chat/src/service/interceptor.dart';

class DioClient {
  static final DioClient _singleton = DioClient._internal();
  final baseUrl = ConfigService.apiUrl;
  late final Dio _dio;


  factory DioClient() {
    return _singleton;
  }

  DioClient._internal() {
    _dio = Dio();
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    _dio.interceptors.add(DioInterceptor());
  }

  Dio get instance => _dio;
}