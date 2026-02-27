import 'package:ai_legal_assistant/features/auth/bindings/auth_binding.dart';
import 'package:ai_legal_assistant/features/auth/bindings/otp_binding.dart';
import 'package:ai_legal_assistant/features/auth/bindings/splash_binding.dart';
import 'package:ai_legal_assistant/features/auth/screens/accouont_created.dart';
import 'package:ai_legal_assistant/features/auth/screens/forget_password.dart';
import 'package:ai_legal_assistant/features/auth/screens/otp_screen.dart';
import 'package:ai_legal_assistant/features/auth/screens/password_reset.dart';
import 'package:ai_legal_assistant/features/auth/screens/sign_in_screen.dart';
import 'package:ai_legal_assistant/features/auth/screens/sign_up_screen.dart';
import 'package:ai_legal_assistant/features/auth/screens/splash_screen.dart';
import 'package:ai_legal_assistant/features/home/bindings/chat_binding.dart';
import 'package:ai_legal_assistant/features/home/bindings/profile_binding.dart';
import 'package:ai_legal_assistant/features/home/screens/home_screens.dart';
import 'package:ai_legal_assistant/features/home/screens/profile_screen.dart';
import 'package:ai_legal_assistant/routes/routes_name.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppRoutes {
  static List<GetPage> pages = [
    GetPage(
      name: RoutesName.home,
      page: () => HomeScreens(),
      transition: Transition.rightToLeft,
      bindings: [ChatBinding(), ProfileBinding()],
    ),
    GetPage(
      name: RoutesName.login,
      page: () => SignInScreen(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.splashScreen,
      page: () => SplashScreen(),
      transition: Transition.rightToLeft,
      binding: SplashBinding(),
    ),
    GetPage(
      name: RoutesName.signUp,
      page: () => SignUpScreen(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.forgetPassword,
      page: () => ForgetPassword(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.forgetPasswordotpScreen,
      page: () => OtpScreen(verificationType: "forgot_password"),
      transition: Transition.rightToLeft,
      bindings: [AuthBinding(), OtpBindingForgetPassword()],
    ),
    GetPage(
      name: RoutesName.signUpotpScreen,
      page: () => OtpScreen(verificationType: "registration"),
      transition: Transition.rightToLeft,
      bindings: [AuthBinding(), OtpBindingSignUp()],
    ),
    GetPage(
      name: RoutesName.passwordReset,
      page: () => PasswordReset(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.accountCreated,
      page: () => AccouontCreated(),
      transition: Transition.rightToLeft,
      // binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.profile,
      page: () => ProfileScreen(),
      transition: Transition.rightToLeft,
      binding: ProfileBinding(),
    ),
  ];
}
