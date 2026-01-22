// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MarketFlow';

  @override
  String get slogan => 'The Future of Commerce';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinMarketFlow => 'Join MarketFlow';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get cart => 'Cart';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get description => 'Description';

  @override
  String get reviews => 'Reviews';

  @override
  String get totalPrice => 'Total Price';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get checkout => 'Proceed to Checkout';

  @override
  String get checkoutMessage => 'Proceeding to checkout...';

  @override
  String get myCart => 'My Cart';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get addItemsToStart => 'Add items to start shopping';

  @override
  String get clearCart => 'Clear Cart';

  @override
  String get clearCartConfirmation =>
      'Are you sure you want to remove all items?';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get delete => 'Delete';

  @override
  String get retry => 'Retry';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get manageStore => 'Manage Store';

  @override
  String get changePassword => 'Change Password';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get aboutUs => 'About Us';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get appVersion => 'App Version';

  @override
  String get categories => 'Categories';

  @override
  String get all => 'All';

  @override
  String get specialOffers => 'Special Offers';

  @override
  String get filteredProducts => 'Filtered Products';

  @override
  String get allProducts => 'All Products';

  @override
  String get items => 'items';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get showAllProducts => 'Show all products';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get updateProfileSuccess => 'Profile updated successfully';

  @override
  String get reviewSubmitted => 'Review submitted successfully';

  @override
  String get writeReview => 'Write a Review';

  @override
  String get shareThoughts => 'Share your thoughts...';

  @override
  String get submit => 'Submit';

  @override
  String get seeAll => 'See All';

  @override
  String get noReviewsYet => 'No reviews yet';

  @override
  String get beFirstReview => 'Be the first to review this product';

  @override
  String addedToCart(String productName) {
    return '$productName added to cart';
  }

  @override
  String get failedAddToCart => 'Failed to add to cart';

  @override
  String get failedSubmitReview => 'Failed to submit review';

  @override
  String get adding => 'Adding...';

  @override
  String get close => 'Close';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get deleteProduct => 'Delete Product?';

  @override
  String deleteProductConfirmation(String productName) {
    return 'Are you sure you want to delete \"$productName\"?';
  }

  @override
  String productDeleted(String productName) {
    return '$productName deleted';
  }

  @override
  String get failedDelete => 'Failed to delete';

  @override
  String get addNewProduct => 'Add New Product';

  @override
  String get productName => 'Product Name';

  @override
  String get arabicName => 'Arabic Name';

  @override
  String get productDescription => 'Product Description';

  @override
  String get arabicDescription => 'Arabic Description';

  @override
  String get price => 'Price';

  @override
  String get stock => 'Stock';

  @override
  String get imageUrl => 'Image URL';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get selectCategoryPrompt => 'Select Category:';

  @override
  String get pleaseSelectCategory => 'Please select a category';

  @override
  String get productAddedSuccess => 'Product added successfully';

  @override
  String get failedAddProduct => 'Failed to add product';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get checkEmail => 'Check your email';

  @override
  String get otpSentTo => 'We sent a verification code to';

  @override
  String get verify => 'Verify';

  @override
  String get didNotReceiveCode => 'Didn\'t receive the code?';

  @override
  String get resend => 'Resend';

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordInstructions =>
      'Your new password must be different from previously used passwords.';

  @override
  String get newPassword => 'New Password';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get passwordResetSuccess => 'Password reset successfully';

  @override
  String get verificationSuccessful => 'Verification successful';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get enterCurrentPassword => 'Enter your current password';

  @override
  String get passwordChangedSuccess => 'Password changed successfully';

  @override
  String get passwordRequirements => 'Password Requirements:';

  @override
  String get reqAtLeast8Chars => 'At least 8 characters';

  @override
  String get reqUppercase => 'At least one uppercase letter';

  @override
  String get reqNumber => 'At least one number';

  @override
  String get reqSpecialChar => 'At least one special character';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }
}
