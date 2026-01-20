import 'package:dio/dio.dart';
import 'package:shop_flow/core/network/api/end_points.dart';

/// A singleton class to manage all API requests using the Dio package.
class ApiService {
  final Dio _dio;

  // Private constructor
  ApiService._()
      : _dio = Dio(
    BaseOptions(
      // The base URL for all API requests, defined in EndPoints.
      baseUrl: EndPoints.baseUrl,
      // Receive data even if the status code indicates an error.
      receiveDataWhenStatusError: true,
      // You can add default headers here if needed, e.g., for content-type.
      headers: {
        'Content-Type': 'application/json',
      },
      // Set connection and receive timeouts.
      connectTimeout: const Duration(seconds: 10), // 10 seconds
      receiveTimeout: const Duration(seconds: 10), // 10 seconds
    ),
  ) {
    // You can add interceptors here for logging, authentication, etc.
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  // Singleton instance
  static final ApiService _instance = ApiService._();

  /// Provides a global access point to the ApiService instance.
  factory ApiService() => _instance;

  /// Makes a GET request to the given [endpoint].
  ///
  /// [queryParameters] can be used to add URL query parameters.
  /// [options] can be used to configure headers, timeouts, etc. for this specific request.
  Future<Response> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    return await _dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: options,
    );
  }

  /// Makes a POST request to the given [endpoint] with the given [data].
  ///
  /// [data] is the request body.
  /// [options] can be used to configure headers, timeouts, etc. for this specific request.
  Future<Response> post(
      String endpoint, {
        Map<String, dynamic>? data,
        Options? options,
      }) async {
    return await _dio.post(
      endpoint,
      data: data,
      options: options,
    );
  }

  /// Makes a PUT request to the given [endpoint] with the given [data].
  Future<Response> put(
      String endpoint, {
        required Map<String, dynamic> data,
        Options? options,
      }) async {
    return await _dio.put(
      endpoint,
      data: data,
      options: options,
    );
  }

  /// Makes a DELETE request to the given [endpoint].
  Future<Response> delete(
      String endpoint, {
        Options? options,
      }) async {
    return await _dio.delete(
      endpoint,
      options: options,
    );
  }
}
