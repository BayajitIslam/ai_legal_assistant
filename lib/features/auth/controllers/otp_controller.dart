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

    String otp = getOTPCode();

    // Validation
    if (otp.length != 6) {
      errorMessage.value = 'Please enter complete OTP code';
      return;
    }

    try {
      isLoading.value = true;

      // API Call
      final response = await ApiService.post(
        ApiEndpoints.verifyOTP,
        body: {
          "email": Get.arguments['email'],
          "otp_type": Get.arguments['otp_type'],
          "otp_code": otpControllers
              .map((controller) => controller.text)
              .join(),
        },
      );

      if (response.statusCode == 200) {
        isLoading(false);
        CustomeSnackbar.success(response.data['message']);
        Console.info('${response.data}');
        Get.toNamed(RoutesName.accountCreated);
      } else if (response.statusCode == 400) {
        isLoading(false);
        if (!response.data['success']) {
          final errors = response.data['errors'] as Map<String, dynamic>;

          errors.forEach((field, messages) {
            for (var msg in messages) {
              errorMessage.value = msg;
              Console.error('$field: $msg');
            }
          });
        }
      } else {
        isLoading(false);
        errorMessage.value = response.data['message'] ?? 'Verification failed.';
      }
    } catch (e) {
      errorMessage.value = 'Verification failed. Please try again.';
    } finally {
      isLoading.value = false;
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
