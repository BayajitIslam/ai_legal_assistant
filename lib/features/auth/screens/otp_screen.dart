import 'package:ai_legal_assistant/core/constants/app_colors.dart';
import 'package:ai_legal_assistant/core/constants/app_string.dart';
import 'package:ai_legal_assistant/core/constants/image_const.dart';
import 'package:ai_legal_assistant/core/themes/app_text_style.dart';
import 'package:ai_legal_assistant/features/auth/controllers/auth_controller.dart.dart';
import 'package:ai_legal_assistant/features/auth/controllers/otp_controller.dart';
import 'package:ai_legal_assistant/features/widget/custom_button.dart';
import 'package:ai_legal_assistant/features/widget/custome_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OtpScreen extends GetView<AuthController> {
  final String verificationType; // 'signup' or 'forgot_password'
  final String? email;
  const OtpScreen({super.key, required this.verificationType, this.email});

  @override
  Widget build(BuildContext context) {
    final otpController = Get.find<OTPController>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Header
                CustomeHeader(title: AppString.forgotPassword),

                //Logo Here
                Image.asset(
                  AppImages.legalAiLogo,
                  width: 132.5.w,
                  height: 106.h,
                ),

                //Title Here
                SizedBox(height: 23.h),
                Text(AppString.checkYourEmail, style: AppTextStyles.s20w7i()),

                //Description Here
                SizedBox(height: 5.h),
                verificationType == "forgot_password"
                    ? Text(
                        textAlign: TextAlign.center,
                        "${AppString.weSentacodeto} ${controller.forgotPasswordEmailController.text.toLowerCase()} ${AppString.enter6DigitCode}",
                        style: AppTextStyles.s14w4i(),
                      )
                    : Text(
                        textAlign: TextAlign.center,
                        "${AppString.weSentacodeto} ${controller.emailController.text.toLowerCase()} ${AppString.enter6DigitCode}",
                        style: AppTextStyles.s14w4i(),
                      ),

                //Otp Field Here
                SizedBox(height: 51.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => _buildOTPBox(otpController, index),
                  ),
                ),
                //Error Message
                SizedBox(height: 8.h),

                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Obx(
                    () => Text(
                      "${otpController.errorMessage}",
                      style: AppTextStyles.s14w4i(color: AppColors.error),
                    ),
                  ),
                ),

                //Reset Password Here
                SizedBox(height: 24.h),

                // Submit Button
                Obx(
                  () => CustomeButton(
                    title: otpController.isLoading.value
                        ? 'Verifying...'
                        : 'Verify Code',
                    isLoading: otpController.isLoading.value,
                    onTap: otpController.isLoading.value
                        ? null
                        : otpController.verifyOTP,
                  ),
                ),

                
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  Widget _buildOTPBox(OTPController controller, int index) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: AppColors.whiteText,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40A3A3A3),
            blurRadius: 4,

            blurStyle: BlurStyle.outer,
          ),
          BoxShadow(
            color: const Color(0x40A3A3A3),
            blurRadius: 10,
            offset: Offset(0, 2),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: TextField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.pText,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              controller.focusNodes[index + 1].requestFocus();
            } else {
              FocusScope.of(Get.context!).unfocus();
            }
          } else if (value.isEmpty && index > 0) {
            controller.focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
