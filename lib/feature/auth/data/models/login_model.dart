class LoginModel {
  final String message;
  final bool isAuthenticated;
  final String token;
  final String email;
  final List<String> roles;

  LoginModel({
    required this.message,
    required this.isAuthenticated,
    required this.token,
    required this.email,
    required this.roles,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      message: json['message'] ?? '',
      isAuthenticated: json['isAuthenticated'] ?? false,
      token: json['token'] ?? '',
      email: json['email'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
    );
  }
}
