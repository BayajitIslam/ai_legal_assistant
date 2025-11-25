import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
  }
}

// Alternative: If you want to initialize immediately
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChatController>(ChatController(), permanent: true);
  }
}
