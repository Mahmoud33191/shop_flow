import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String errorMessage;
  ServerException(this.errorMessage);
}

void handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException("Connection Timeout");
    case DioExceptionType.sendTimeout:
      throw ServerException("Send Timeout");
    case DioExceptionType.receiveTimeout:
      throw ServerException("Receive Timeout");
    case DioExceptionType.badResponse:
      throw ServerException(e.response?.data['message'] ?? "Bad Response");
    case DioExceptionType.cancel:
      throw ServerException("Request Cancelled");
    default:
      throw ServerException("Unknown Error");
  }
}
