import 'package:ai_legal_assistant/features/auth/controllers/otp_controller.dart';
import 'package:get/get.dart';

class OtpBindingForgetPassword extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => OTPController(),
      fenix: true,
    );
  }
}

class OtpBindingSignUp extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => OTPController(),
      fenix: true,
    );
  }
}
