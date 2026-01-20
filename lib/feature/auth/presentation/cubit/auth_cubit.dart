import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_flow/feature/auth/data/models/user_model.dart';
import 'package:shop_flow/feature/auth/data/repositories/auth_repository.dart';

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String? message;
  AuthSuccess({this.message});
}

class LoginSuccess extends AuthState {
  final LoginResponse loginResponse;
  LoginSuccess(this.loginResponse);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class OtpSent extends AuthState {
  final String email;
  OtpSent(this.email);
}

class OtpVerified extends AuthState {}

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository(),
      super(AuthInitial());

  String? _tempEmail;
  String? _tempOtp;

  String? get tempEmail => _tempEmail;
  String? get tempOtp => _tempOtp;

  /// Login
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
      );
      emit(LoginSuccess(response));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  /// Register
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    emit(AuthLoading());
    try {
      await _authRepository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      _tempEmail = email;
      emit(OtpSent(email));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  /// Verify Email OTP
  Future<void> verifyEmail({required String email, required String otp}) async {
    emit(AuthLoading());
    try {
      await _authRepository.verifyEmail(email: email, otp: otp);
      emit(AuthSuccess(message: 'Email verified successfully'));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  /// Resend OTP
  Future<void> resendOtp({required String email}) async {
    emit(AuthLoading());
    try {
      await _authRepository.resendOtp(email: email);
      emit(OtpSent(email));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  /// Forgot Password
  Future<void> forgotPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await _authRepository.forgotPassword(email: email);
      _tempEmail = email;
      emit(OtpSent(email));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  /// Validate OTP
  Future<void> validateOtp({required String email, required String otp}) async {
    emit(AuthLoading());
    try {
      await _authRepository.validateOtp(email: email, otp: otp);
      _tempOtp = otp;
      emit(OtpVerified());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  /// Reset Password
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    try {
      await _authRepository.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      emit(AuthSuccess(message: 'Password reset successfully'));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  /// Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(AuthLoading());
    try {
      await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      emit(AuthSuccess(message: 'Password changed successfully'));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  /// Logout
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  /// Update Profile
  Future<void> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    emit(AuthLoading());
    try {
      await _authRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
      );
      emit(AuthSuccess(message: 'Profile updated successfully'));
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  /// Check login status
  bool get isLoggedIn => _authRepository.isLoggedIn;
}
