import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/features/auth/models/user_model.dart';
import 'package:template/routes/routes_name.dart';

class AuthController extends GetxController {
  // Sign Up Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  // Sign In Form Controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Foroget Password Form Controllers
  final forgotPasswordEmailController = TextEditingController();

  // Reset Password Controllers
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  //Error Message
  final RxString errorMessageSignIn = ''.obs;
  final RxString errorMessageSignUp = ''.obs;
  final RxString errorMessageForgotPassword = ''.obs;

  // Error Message for Reset Password
  final RxString errorMessageResetPassword = ''.obs;

  // Observable States
  final RxBool isLoading = false.obs;

  //Sign Up ---
  void signUp() {
    //Sign Up Logic Here
    if (!_validateSignUpForm()) return;
    errorMessageSignUp.value = "";

    Get.toNamed(RoutesName.signUpotpScreen);
  }

  //Sign In ---
  void signIn() {
    //Sign In Logic Here
    if (!_validateSignInForm()) return;
    errorMessageSignIn.value = "";

    Get.toNamed(RoutesName.home);
  }

  //resetPassword
  void sendPasswordResetEmail() {
    errorMessageForgotPassword.value = '';

    // Validation
    if (forgotPasswordEmailController.text.trim().isEmpty) {
      errorMessageForgotPassword.value = 'Please enter your email';
      return;
    }

    if (!GetUtils.isEmail(forgotPasswordEmailController.text.trim())) {
      errorMessageForgotPassword.value = 'Please enter a valid email';
      return;
    }

    Get.toNamed(RoutesName.forgetPasswordotpScreen);
  }

  // Validate Sign In Form
  bool _validateSignInForm() {
    if (loginEmailController.text.trim().isEmpty) {
      errorMessageSignIn.value = 'Please enter your email';
      return false;
    }
    if (!GetUtils.isEmail(loginEmailController.text.trim())) {
      errorMessageSignIn.value = 'Please enter a valid email';
      return false;
    }
    if (loginPasswordController.text.isEmpty) {
      errorMessageSignIn.value = 'Please enter your password';
      return false;
    }
    return true;
  }

  // Validate Sign Up Form
  bool _validateSignUpForm() {
    if (emailController.text.trim().isEmpty) {
      errorMessageSignUp.value = 'Please enter your email';
      return false;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      errorMessageSignUp.value = 'Please enter a valid email';
      return false;
    }
    if (passwordController.text.length < 6) {
      errorMessageSignUp.value = 'Password must be at least 6 characters';
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      errorMessageSignUp.value = 'Passwords do not match';
      return false;
    }
    return true;
  }

  // Reset Password
  Future<void> resetPassword() async {
    errorMessageResetPassword.value = '';

    // Validation
    if (newPasswordController.text.isEmpty) {
      errorMessageResetPassword.value = 'Please enter your new password';
      return;
    }

    if (newPasswordController.text.length < 6) {
      errorMessageResetPassword.value =
          'Password must be at least 6 characters';
      return;
    }

    if (confirmNewPasswordController.text.isEmpty) {
      errorMessageResetPassword.value = 'Please confirm your password';
      return;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      errorMessageResetPassword.value = 'Passwords do not match';
      return;
    }

    try {
      isLoading.value = true;

      // API Call (Replace with your actual API)
      // final response = await ApiService.resetPassword(
      //   password: newPasswordController.text,
      // );

      // Mock Response
      await Future.delayed(Duration(seconds: 2));

      // Success
      Get.snackbar(
        'Success',
        'Password has been reset successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Clear fields
      newPasswordController.clear();
      confirmNewPasswordController.clear();

      // Navigate to login
      await Future.delayed(Duration(seconds: 1));
      Get.offAllNamed(RoutesName.login);
    } catch (e) {
      errorMessageResetPassword.value =
          'Failed to reset password. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // Save User Data to SharedPreferences
  // ignore: unused_element
  Future<void> _saveUserData(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id ?? '');
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setString('auth_token', user.token ?? '');
    await prefs.setBool('is_logged_in', true);
  }
}
