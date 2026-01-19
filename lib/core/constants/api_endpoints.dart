class ApiEndpoints {
  static const String baseUrl = 'https://harryapi.dsrt321.online';

  //====================== Auth ======================
  static const String signup = '$baseUrl/api/register/';
  static const String signin = '$baseUrl/api/login/';
  static const String verifyOTP = '$baseUrl/api/verify-otp/';
  static const String resetPasswordRequest =
      '$baseUrl/api/password-reset-request/';
  static const String resetPasswordConfirm = '$baseUrl/api/password-reset/';
  static const String verifyResetOTP = '$baseUrl/api/verify-reset-otp/';
  static const String resendOTP = '$baseUrl/api/resend-otp/';

  //====================== Chat ======================
  static const String getChatSessions = '$baseUrl/api/chat/sessions/';
  static const String createChatSession = '$baseUrl/api/chat/sessions/create/';
  static String getChatSession(String sessionId) =>
      '$baseUrl/api/chat/sessions/$sessionId/';
  static String updateChatSession(String sessionId) =>
      '$baseUrl/api/chat/sessions/$sessionId/';
  static String deleteChatSession(String sessionId) =>
      '$baseUrl/api/chat/sessions/$sessionId/';
  static const String sendMessage = '$baseUrl/api/chat/send/';

  //====================== Profile ======================
  static const String profile = '$baseUrl/api/profile/';
}
