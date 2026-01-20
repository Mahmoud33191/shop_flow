import 'package:dio/dio.dart';
import 'package:shop_flow/core/network/api/dio_consumer.dart';
import 'package:shop_flow/core/network/api/end_points.dart';
import 'package:shop_flow/core/services/cache_service.dart';
import 'package:shop_flow/feature/auth/data/models/user_model.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  /// Login with email and password
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        EndPoints.login,
        data: {ApiKeys.email: email, ApiKeys.password: password},
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        // Save tokens
        await CacheService.instance.setAccessToken(loginResponse.accessToken);
        await CacheService.instance.setRefreshToken(loginResponse.refreshToken);
        await CacheService.instance.saveUserInfo(
          id: loginResponse.user.id,
          email: loginResponse.user.email,
          name: loginResponse.user.fullName,
          photo: loginResponse.user.photoUrl,
        );

        return loginResponse;
      }
      throw Exception('Login failed');
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, 'Login failed'));
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _apiService.post(
        EndPoints.register,
        data: {
          ApiKeys.email: email,
          ApiKeys.password: password,
          ApiKeys.firstName: firstName,
          ApiKeys.lastName: lastName,
        },
      );

      if (response.statusCode != 204 &&
          response.statusCode != 200 &&
          response.statusCode != 201) {
        throw Exception('Registration failed');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown && e.error is FormatException) {
        return;
      }
      throw Exception(_extractErrorMessage(e, 'Registration failed'));
    } catch (e) {
      if (e is Exception && e.toString().contains('Registration failed')) {
        rethrow;
      }
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  /// Helper to extract detailed error message from API response
  String _extractErrorMessage(DioException e, String defaultMessage) {
    final data = e.response?.data;

    // Handle connection errors
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }

    if (data == null) return defaultMessage;

    // Try to get error details from response
    if (data is Map) {
      // Check for 'errors' array (common in validation errors)
      if (data['errors'] != null) {
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.map((e) => e.toString()).join(', ');
        } else if (errors is Map) {
          final allErrors = <String>[];
          errors.forEach((key, value) {
            if (value is List) {
              allErrors.addAll(value.map((e) => e.toString()));
            } else {
              allErrors.add(value.toString());
            }
          });
          if (allErrors.isNotEmpty) return allErrors.join(', ');
        }
      }
      // Check for 'message' field
      if (data['message'] != null && data['message'].toString().isNotEmpty) {
        return data['message'].toString();
      }
      // Check for 'title' field (some APIs use this)
      if (data['title'] != null && data['title'].toString().isNotEmpty) {
        return data['title'].toString();
      }
      // Check for 'error' field
      if (data['error'] != null && data['error'].toString().isNotEmpty) {
        return data['error'].toString();
      }
      // Check for 'detail' field (ASP.NET sometimes uses this)
      if (data['detail'] != null && data['detail'].toString().isNotEmpty) {
        return data['detail'].toString();
      }
    } else if (data is String && data.isNotEmpty) {
      return data;
    }

    // Default based on status code
    final statusCode = e.response?.statusCode;
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return 'Invalid request. Please check your input.';
        case 401:
          return 'Invalid email or password.';
        case 403:
          return 'Access denied.';
        case 404:
          return 'Service not found.';
        case 409:
          return 'Email already exists.';
        case 422:
          return 'Invalid data. Please check your input.';
        case 500:
          return 'Server error. Please try again later.';
        default:
          return defaultMessage;
      }
    }

    return defaultMessage;
  }

  /// Verify email with OTP
  Future<void> verifyEmail({required String email, required String otp}) async {
    try {
      final response = await _apiService.post(
        EndPoints.verifyEmail,
        data: {ApiKeys.email: email, ApiKeys.otp: otp},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Verification failed');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown && e.error is FormatException) {
        // Handle empty response body on success
        return;
      }
      throw Exception(_extractErrorMessage(e, 'Verification failed'));
    } catch (e) {
      if (e is Exception && e.toString().contains('Verification failed')) {
        rethrow;
      }
      throw Exception('Verification failed: ${e.toString()}');
    }
  }

  /// Resend OTP
  Future<void> resendOtp({required String email}) async {
    try {
      final response = await _apiService.post(
        EndPoints.resendOtp,
        data: {ApiKeys.email: email},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to resend OTP');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown && e.error is FormatException) {
        return;
      }
      throw Exception(_extractErrorMessage(e, 'Failed to resend OTP'));
    } catch (e) {
      if (e is Exception && e.toString().contains('Failed to resend OTP')) {
        rethrow;
      }
      throw Exception('Failed to resend OTP: ${e.toString()}');
    }
  }

  /// Forgot password - sends OTP to email
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await _apiService.post(
        EndPoints.forgotPassword,
        data: {ApiKeys.email: email},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to send reset email');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown && e.error is FormatException) {
        return;
      }
      throw Exception(_extractErrorMessage(e, 'Failed to send reset email'));
    } catch (e) {
      if (e is Exception &&
          e.toString().contains('Failed to send reset email')) {
        rethrow;
      }
      throw Exception('Failed to send reset email: ${e.toString()}');
    }
  }

  /// Validate OTP for password reset
  Future<void> validateOtp({required String email, required String otp}) async {
    try {
      final response = await _apiService.post(
        EndPoints.validateOtp,
        data: {ApiKeys.email: email, ApiKeys.otp: otp},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Invalid OTP');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown && e.error is FormatException) {
        return;
      }
      throw Exception(_extractErrorMessage(e, 'Invalid OTP'));
    } catch (e) {
      if (e is Exception && e.toString().contains('Invalid OTP')) {
        rethrow;
      }
      throw Exception('OTP validation failed: ${e.toString()}');
    }
  }

  /// Reset password
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        EndPoints.resetPassword,
        data: {
          ApiKeys.email: email,
          ApiKeys.otp: otp,
          ApiKeys.newPassword: newPassword,
        },
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to reset password');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown && e.error is FormatException) {
        return;
      }
      throw Exception(_extractErrorMessage(e, 'Failed to reset password'));
    } catch (e) {
      if (e is Exception && e.toString().contains('Failed to reset password')) {
        rethrow;
      }
      throw Exception('Failed to reset password: ${e.toString()}');
    }
  }

  /// Change password (for logged-in users)
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final token = CacheService.instance.accessToken;
      final response = await _apiService.post(
        EndPoints.changePassword,
        data: {
          ApiKeys.currentPassword: currentPassword,
          ApiKeys.newPassword: newPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to change password');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown && e.error is FormatException) {
        return;
      }
      throw Exception(_extractErrorMessage(e, 'Failed to change password'));
    } catch (e) {
      if (e is Exception &&
          e.toString().contains('Failed to change password')) {
        rethrow;
      }
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }

  /// Get current user info
  Future<UserModel> getCurrentUser() async {
    try {
      final token = CacheService.instance.accessToken;
      final response = await _apiService.get(
        EndPoints.me,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      throw Exception('Failed to get user info');
    } on DioException catch (e) {
      throw Exception(_extractErrorMessage(e, 'Failed to get user info'));
    } catch (e) {
      if (e is Exception && e.toString().contains('Failed to get user info')) {
        rethrow;
      }
      throw Exception('Failed to get user info: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    try {
      final token = CacheService.instance.accessToken;
      final response = await _apiService.put(
        EndPoints.me, // Assuming PUT on /me updates profile
        data: {ApiKeys.firstName: firstName, ApiKeys.lastName: lastName},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        // Update cache
        await CacheService.instance.saveUserInfo(
          id: CacheService.instance.userId ?? '',
          email: CacheService.instance.userEmail ?? '',
          name: '$firstName $lastName',
          photo: CacheService.instance.userPhoto,
        );
      } else {
        throw Exception('Failed to update profile');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown && e.error is FormatException) {
        return;
      }
      throw Exception(_extractErrorMessage(e, 'Failed to update profile'));
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      final token = CacheService.instance.accessToken;
      await _apiService.post(
        EndPoints.logout,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } finally {
      await CacheService.instance.clearAuth();
    }
  }

  /// Check if user is logged in
  bool get isLoggedIn => CacheService.instance.isLoggedIn;
}
