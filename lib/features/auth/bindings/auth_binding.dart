import 'package:get/get.dart';
import 'package:template/features/auth/controllers/auth_controller.dart.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: true);
  }
}

