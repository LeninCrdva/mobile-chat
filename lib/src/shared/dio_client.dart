import 'package:dio/dio.dart';
import 'package:simple_chat/src/service/interceptor.dart';

class DioClient {
  static final DioClient _singleton = DioClient._internal();
  late final Dio _dio;

  factory DioClient() {
    return _singleton;
  }

  DioClient._internal() {
    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
  }

  Dio get instance => _dio;
}