class EndPoints {
  static const String baseUrl = "https://accessories-eshop.runasp.net/";

  // Auth
  static const String login = "api/auth/login";
  static const String register = "api/auth/register";
  static const String verifyEmail = "api/auth/verify-email";
  static const String forgotPassword = "api/auth/forgot-password";
  static const String validateOtp = "api/auth/validate-otp";
  static const String resetPassword = "api/auth/reset-password";
  static const String changePassword = "api/auth/change-password";
  static const String logout = "api/auth/logout";
  static const String refreshToken = "api/auth/refresh-token";
  static const String resendOtp = "api/auth/resend-otp";
  static const String me = "api/auth/me";

  // Products
  static const String products = "api/products";
  static String productById(String id) => "api/products/$id";

  // Categories
  static const String categories = "api/categories";

  // Cart
  static const String cart = "api/cart";
  static const String addToCart = "api/cart/items";
  static String removeFromCart(String itemId) => "api/cart/items/$itemId";
  static String updateCartItem(String itemId) => "api/cart/items/$itemId";

  // Offers
  static const String offers = "api/offers";

  // Reviews
  // Reviews
  static const String reviewsBase = "api/reviews";
  static String reviews(String productId) => "api/reviews/$productId";

  // Orders
  static const String orders = "api/orders";
  static const String checkout = "api/orders/checkout";
}

class ApiKeys {
  static const String email = "email";
  static const String password = "password";
  static const String otp = "otp";
  static const String newPassword = "newPassword";
  static const String currentPassword = "currentPassword";
  static const String token = "token";
  static const String refreshToken = "refreshToken";
  static const String userId = "userId";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String productId = "productId";
  static const String quantity = "quantity";
}
