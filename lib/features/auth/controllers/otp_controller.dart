import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/api_endpoints.dart';
import 'package:template/core/services/api_service.dart';
import 'package:template/core/utils/console.dart';
import 'package:template/features/widget/custome_snackbar.dart';
import 'package:template/routes/routes_name.dart';

class OTPController extends GetxController {
  // OTP Controllers for each box
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // Focus Nodes for each box
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  // Observable States
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt remainingTime = 120.obs; // 2 minutes in seconds
  final RxBool canResend = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  // Start Countdown Timer
  void startTimer() {
    remainingTime.value = 120;
    canResend.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  // Format Time (MM:SS)
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString()}:${secs.toString().padLeft(2, '0')}';
  }

  // Get OTP Code
  String getOTPCode() {
    return otpControllers.map((controller) => controller.text).join();
  }

  // Verify OTP

  Future<void> verifyOTP() async {
    errorMessage.value = '';

    // Get OTP code
    String otp = getOTPCode();

    // Validation
    if (otp.length != 6) {
      errorMessage.value = 'Please enter complete OTP code';
      return;
    }

    try {
      isLoading.value = true;

      final email = Get.arguments['email'] ?? '';
      final otpType = Get.arguments['otp_type'];

      // Determine API endpoint
      final apiEndpoint = (otpType == 'registration')
          ? ApiEndpoints.verifyOTP
          : ApiEndpoints.verifyResetOTP;

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "email": email,
        "otp_code": otp,
      };

      // Add otp_type only if it exists
      if (otpType != null) {
        requestBody["otp_type"] = otpType;
      }

      Console.info('Verifying OTP: $requestBody');

      // API Call
      final response = await ApiService.post(apiEndpoint, body: requestBody);

      if (response.statusCode == 200) {
        // Success
        CustomeSnackbar.success(response.data['message']);
        Console.info('OTP Verified: ${response.data}');

        // Navigate to next screen
        if (otpType == 'registration') {
          Get.toNamed(RoutesName.accountCreated);
        } else {
          Get.toNamed(
            RoutesName.passwordReset,
            arguments: {
              'reset_token': response.data['data']['reset_token'],
              'email': response.data['data']['email'],
            },
          );
        }
      } else if (response.statusCode == 400) {
        //  Validation Error
        _handleValidationError(response.data);
      } else {
        //  Other Error
        errorMessage.value = response.data['message'] ?? 'Verification failed.';
        CustomeSnackbar.error(errorMessage.value);
        Console.error('Verification Error: ${response.data}');
      }
    } catch (e) {
      // Exception
      Console.error('Exception during OTP verification: $e');
      errorMessage.value = 'Verification failed. Please try again.';
      CustomeSnackbar.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  //  Handle validation errors
  void _handleValidationError(Map<String, dynamic> data) {
    if (!data['success'] && data['errors'] != null) {
      final errors = data['errors'];

      String errorMsg = '';

      if (errors is Map<String, dynamic>) {
        // Extract first error message
        for (var messages in errors.values) {
          if (messages is List && messages.isNotEmpty) {
            errorMsg = messages.first.toString();
            break;
          } else if (messages is String) {
            errorMsg = messages;
            break;
          }
        }
      }

      if (errorMsg.isNotEmpty) {
        errorMessage.value = errorMsg;
        CustomeSnackbar.error(errorMsg);
        Console.error('Validation Error: $errorMsg');
      } else {
        errorMessage.value = 'Invalid OTP code';
        CustomeSnackbar.error('Invalid OTP code');
      }
    } else {
      errorMessage.value = data['message'] ?? 'Verification failed';
      CustomeSnackbar.error(errorMessage.value);
    }
  }

  // Resend OTP
  Future<void> resendOTP() async {
    if (!canResend.value) return;

    try {
      // API Call to resend OTP
      // await ApiService.resendOTP(
      //   email: email,
      //   type: verificationType,
      // );
      // Mock Response
      await Future.delayed(Duration(seconds: 1));

      CustomeSnackbar.success('OTP has been resent to your email');

      // Restart timer
      startTimer();

      // Clear OTP fields
      for (var controller in otpControllers) {
        controller.clear();
      }

      // Focus on first field
      focusNodes[0].requestFocus();
    } catch (e) {
      CustomeSnackbar.error('Failed to resend OTP. Please try again.');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }
}
