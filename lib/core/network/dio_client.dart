import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient() : dio = Dio() {
    dio.options.baseUrl = "https://vpic.nhtsa.dot.gov/api/";
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        responseBody: false,
        responseHeader: false,
      ),
    );
  }
}
