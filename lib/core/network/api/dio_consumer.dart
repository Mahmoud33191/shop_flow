import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'api_consumer.dart';
import 'end_points.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoints.baseUrl;
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  @override
  Future post(String path, {Map<String, dynamic>? body, bool formDataIsEnabled = false}) async {
    try {
      final response = await dio.post(
        path,
        data: formDataIsEnabled ? FormData.fromMap(body!) : body,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  // Implement get, put, delete similarly...
  @override
  Future get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future delete(String path, {Map<String, dynamic>? body}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future put(String path, {Map<String, dynamic>? body}) {
    // TODO: implement put
    throw UnimplementedError();
  }
}
