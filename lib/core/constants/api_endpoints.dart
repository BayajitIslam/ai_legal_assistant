class ApiEndpoints {
  static const String baseUrl = 'http://10.10.7.22:12002';

  //====================== Auth ======================
  static const String signup = '$baseUrl/api/register/';
  static const String signin = '$baseUrl/api/login/';
  static const String verifyOTP = '$baseUrl/api/verify-otp/';
  static const String resetPasswordRequest =
      '$baseUrl/api/password-reset-request/';
  static const String resetPasswordConfirm = '$baseUrl/api/password-reset/';
  static const String verifyResetOTP = '$baseUrl/api/verify-reset-otp/';
}
