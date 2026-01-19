import 'dart:async';
import 'package:ai_legal_assistant/routes/routes_name.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxService {
  Timer? timer;
  var opacity = 0.0.obs;
  //get x storeage
  // final LocalStorage _localStorage = Get.put(LocalStorage());

  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      if (opacity.value != 1.0) {
        opacity.value += 0.5;
      }
    });

    Future.delayed(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Check if user is logged in
      bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        Get.offAllNamed(RoutesName.home);
      } else {
        // User not logged in → LoginPage
        Get.offAllNamed(RoutesName.login);
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
