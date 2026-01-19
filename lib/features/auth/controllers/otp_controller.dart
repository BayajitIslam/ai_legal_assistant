import 'dart:async';
import 'package:ai_legal_assistant/core/constants/api_endpoints.dart';
import 'package:ai_legal_assistant/core/services/api_service.dart';
import 'package:ai_legal_assistant/core/utils/console.dart';
import 'package:ai_legal_assistant/features/widget/custome_snackbar.dart';
import 'package:ai_legal_assistant/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt remainingTime = 120.obs;
  final RxBool canResend = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

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

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString()}:${secs.toString().padLeft(2, '0')}';
  }

  String getOTPCode() {
    return otpControllers.map((controller) => controller.text).join();
  }

  Future<void> verifyOTP() async {
    errorMessage.value = '';

    String otp = getOTPCode();

    if (otp.length != 6) {
      errorMessage.value = 'Please enter complete OTP code';
      return;
    }

    try {
      isLoading.value = true;

      final email = Get.arguments['email'] ?? '';
      final otpType = Get.arguments['otp_type'];

      final apiEndpoint = (otpType == 'registration')
          ? ApiEndpoints.verifyOTP
          : ApiEndpoints.verifyResetOTP;

      final Map<String, dynamic> requestBody = {
        "email": email,
        "otp_code": otp,
      };

      if (otpType != null) {
        requestBody["otp_type"] = otpType;
      }

      Console.info('Verifying OTP: $requestBody');

      final response = await ApiService.post(apiEndpoint, body: requestBody);

      if (response.statusCode == 200) {
        CustomeSnackbar.success(response.data['message']);
        Console.info('OTP Verified: ${response.data}');

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
        _handleValidationError(response.data);
      } else {
        errorMessage.value = response.data['message'] ?? 'Verification failed.';
        CustomeSnackbar.error(errorMessage.value);
        Console.error('Verification Error: ${response.data}');
      }
    } catch (e) {
      Console.error('Exception during OTP verification: $e');
      errorMessage.value = 'Verification failed. Please try again.';
      CustomeSnackbar.error(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleValidationError(Map<String, dynamic> data) {
    if (!data['success'] && data['errors'] != null) {
      final errors = data['errors'];

      String errorMsg = '';

      if (errors is Map<String, dynamic>) {
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

  // Single endpoint for resend with email and otp_type
  Future<void> resendOTP() async {
    if (!canResend.value || isResending.value) return;

    try {
      isResending.value = true;
      errorMessage.value = '';

      final email = Get.arguments['email'] ?? '';
      final otpType = Get.arguments['otp_type'];

      Console.info('Resending OTP to: $email');
      Console.info('OTP Type: $otpType');

      // Single endpoint with email and otp_type
      final requestBody = {
        "email": email,
        "otp_type": otpType, // Pass otp_type to backend
      };

      Console.info('Resend endpoint: ${ApiEndpoints.resendOTP}');
      Console.info('Request body: $requestBody');

      final response = await ApiService.post(
        ApiEndpoints.resendOTP,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        CustomeSnackbar.success('OTP has been resent to your email');
        Console.success('OTP resent successfully');

        startTimer();

        for (var controller in otpControllers) {
          controller.clear();
        }

        focusNodes[0].requestFocus();
      } else {
        final errorMsg = response.data['message'] ?? 'Failed to resend OTP';
        CustomeSnackbar.error(errorMsg);
        Console.error('Resend Error: ${response.data}');
      }
    } catch (e) {
      Console.error('Exception during OTP resend: $e');
      CustomeSnackbar.error('Failed to resend OTP. Please try again.');
    } finally {
      isResending.value = false;
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
