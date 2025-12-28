import 'package:shop_flow/core/network/api/api_consumer.dart'; // Ensure this path matches your ApiConsumer location
import 'package:shop_flow/core/network/api/end_points.dart';

import '../models/login_model.dart';

class AuthRepository {
  final ApiConsumer api;

  AuthRepository({required this.api});

  Future<LoginModel> login(String email, String password) async {
    final response = await api.post(
      EndPoints.login,
      body: {
        ApiKeys.email: email,
        ApiKeys.password: password,
      },
    );
    return LoginModel.fromJson(response);
  }

  Future<LoginModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await api.post(
      EndPoints.register,
      body: {
        "displayName": name,
        ApiKeys.email: email,
        ApiKeys.password: password,
        "phoneNumber": phone,
      },
    );
    return LoginModel.fromJson(response);
  }

  Future<String> forgotPassword(String email) async {
    final response = await api.post(
      EndPoints.forgotPassword,
      body: {ApiKeys.email: email},
    );
    return response['message'] ?? 'OTP sent successfully';
  }

  Future<String> verifyOtp(String email, String otp) async {
    final response = await api.post(
      EndPoints.verifyOtp,
      body: {
        ApiKeys.email: email,
        ApiKeys.otp: otp,
      },
    );
    return response['message'] ?? 'OTP verified';
  }

  Future<String> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    final response = await api.post(
      EndPoints.resetPassword,
      body: {
        ApiKeys.email: email,
        ApiKeys.newPassword: newPassword,
        ApiKeys.otp: otp,
      },
    );
    return response['message'] ?? 'Password reset successfully';
  }
}
