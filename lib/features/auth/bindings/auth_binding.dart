import 'package:ai_legal_assistant/features/auth/controllers/auth_controller.dart.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
  }
}

