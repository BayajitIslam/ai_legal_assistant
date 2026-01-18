import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/api_endpoints.dart';
import 'package:template/core/services/api_service.dart';
import 'package:template/core/services/local%20storage/storage_service.dart';
import 'package:template/core/utils/console.dart';
import 'package:template/features/widget/custome_snackbar.dart';
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
  void signUp() async {
    //Sign Up Logic Here
    if (!_validateSignUpForm()) return;
    errorMessageSignUp.value = "";

    try {
      isLoading(true);

      //call api
      final response = await ApiService.post(
        ApiEndpoints.signup,
        body: {
          "full_name": nameController.text,
          "email": emailController.text.toLowerCase(),
          "mobile_number": phoneController.text,
          "password": passwordController.text,
          "re_type_password": confirmPasswordController.text,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading(false);
        CustomeSnackbar.success(response.data['message']);
        Console.info('${response.data}');
        Get.toNamed(
          RoutesName.signUpotpScreen,
          arguments: {
            'email': emailController.text,
            'otp_type': 'registration',
          },
        );
      } else if (response.statusCode == 400) {
        isLoading(false);
        Console.info('${response.data}');
        if (!response.data['success']) {
          final errors = response.data['errors'] as Map<String, dynamic>;

          errors.forEach((field, messages) {
            for (var msg in messages) {
              errorMessageSignUp.value = msg;
              Console.error('$field: $msg');
            }
          });
        }
      } else {
        isLoading(false);
        CustomeSnackbar.error(response.data['message']);
        Console.info('${response.data}');
      }
    } catch (e) {
      isLoading(false);
      CustomeSnackbar.error('Error: $e');
      Console.error('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  // Fixed signIn method

  void signIn() async {
    // Validate form
    if (!_validateSignInForm()) return;
    errorMessageSignIn.value = "";

    final data = {
      "email": loginEmailController.text.toLowerCase().trim(),
      "password": loginPasswordController.text,
    };

    try {
      isLoading(true);

      final response = await ApiService.post(ApiEndpoints.signin, body: data);

      if (response.statusCode == 200) {
        //  Success - Login successful
        CustomeSnackbar.success(response.data['message']);
        Console.info('Login Success: ${response.data}');

        // Save user data to shared preferences
        final userData = response.data['data'];

        StorageService.setAccessToken(userData['tokens']['access']);
        StorageService.setRefreshToken(userData['tokens']['refresh']);
        StorageService.setUserName(userData['user']['full_name']);
        StorageService.setUserEmail(userData['user']['email']);
        StorageService.setUserId(userData['user']['id'].toString());
        StorageService.setIsLoggedIn(true);

        // Navigate to Home Screen
        Get.offNamed(RoutesName.home);
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        //  Error - Bad Request / Unauthorized / Forbidden

        if (response.data != null && !response.data['success']) {
          // Check if errors exist and handle accordingly
          final errors = response.data['errors'];

          if (errors != null) {
            // Handle detail array format (like your 401 error)
            if (errors['detail'] != null && errors['detail'] is List) {
              final detailErrors = errors['detail'] as List;
              if (detailErrors.isNotEmpty) {
                errorMessageSignIn.value = detailErrors.first.toString();
              }
            }
            // Handle field-specific errors (Map format)
            else if (errors is Map<String, dynamic>) {
              String errorMessage = '';
              errors.forEach((field, messages) {
                if (messages is List && messages.isNotEmpty) {
                  errorMessage = messages.first.toString();
                } else if (messages is String) {
                  errorMessage = messages;
                }
              });
              if (errorMessage.isNotEmpty) {
                errorMessageSignIn.value = errorMessage;
              }
            }
          } else {
            // Fallback to message if no errors
            errorMessageSignIn.value =
                response.data['message'] ?? 'Login failed';
          }
        } else {
          errorMessageSignIn.value = 'Authentication failed';
        }

        Console.error('Login Error ${response.statusCode}: ${response.data}');
      } else {
        //  Other errors
        final message = response.data?['message'] ?? 'Something went wrong';
        errorMessageSignIn.value = message;
        Console.error('Unexpected Error: ${response.data}');
      }
    } catch (e) {
      isLoading(false);
      Console.error('Exception during login: $e');
      errorMessageSignIn.value = 'Connection failed. Please try again.';
      CustomeSnackbar.error('Connection failed. Please try again.');
    } finally {
      isLoading(false);
    }
  }

  //resetPassword
  void sendPasswordResetEmail() async {
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
    try {
      isLoading.value = true;

      // API Call
      final response = await ApiService.post(
        ApiEndpoints.resetPasswordRequest,
        body: {
          "email": forgotPasswordEmailController.text.toLowerCase().trim(),
        },
      );
      isLoading(false);
      if (response.statusCode == 200) {
        //  Success
        CustomeSnackbar.success(response.data['message']);
        Console.info('Password Reset Request Success: ${response.data}');
        Get.toNamed(
          RoutesName.forgetPasswordotpScreen,
          arguments: {
            'email': forgotPasswordEmailController.text.toLowerCase().trim(),
            'otp_type': 'reset',
          },
        );
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        //  Error - Bad Request / Unauthorized / Forbidden

        if (response.data != null && !response.data['success']) {
          // Check if errors exist and handle accordingly
          final errors = response.data['errors'];

          if (errors != null) {
            // Handle detail array format (like your 401 error)
            if (errors['detail'] != null && errors['detail'] is List) {
              final detailErrors = errors['detail'] as List;
              if (detailErrors.isNotEmpty) {
                errorMessageForgotPassword.value = detailErrors.first
                    .toString();
              }
            }
            // Handle field-specific errors (Map format)
            else if (errors is Map<String, dynamic>) {
              String errorMessage = '';
              errors.forEach((field, messages) {
                if (messages is List && messages.isNotEmpty) {
                  errorMessage = messages.first.toString();
                } else if (messages is String) {
                  errorMessage = messages;
                }
              });
              if (errorMessage.isNotEmpty) {
                errorMessageForgotPassword.value = errorMessage;
              }
            }
          } else {
            // Fallback to message if no errors
            errorMessageForgotPassword.value =
                response.data['message'] ?? 'Login failed';
          }
        } else {
          errorMessageForgotPassword.value = 'Authentication failed';
        }

        Console.error('Login Error ${response.statusCode}: ${response.data}');
      } else {
        //  Other errors
        final message = response.data?['message'] ?? 'Something went wrong';
        errorMessageForgotPassword.value = message;
        Console.error('Unexpected Error: ${response.data}');
      }
    } catch (e) {
      isLoading(false);
      errorMessageForgotPassword.value = 'Connection failed. Please try again.';
    } finally {
      isLoading(false);
    }
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
    if (loginPasswordController.text.length < 6) {
      errorMessageSignIn.value = 'Minimum 6 characters required';
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
      CustomeSnackbar.success('Password reset successfully!');

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
}
