import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/constants/app_string.dart';
import 'package:template/core/constants/image_const.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/auth/controllers/auth_controller.dart.dart';
import 'package:template/features/widget/custom_button.dart';
import 'package:template/features/auth/widgets/custome_textfield.dart';
import 'package:template/features/widget/custome_header.dart';

class ForgetPassword extends GetView<AuthController> {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
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
                Text(AppString.resetPassword, style: AppTextStyles.s20w7i()),

                //Description Here
                SizedBox(height: 5.h),
                Text(
                  AppString.pleaseEnterYourEmail,
                  style: AppTextStyles.s14w4i(),
                ),

                //Email Address Here
                SizedBox(height: 51.h),
                CustomeTextfield(
                  controller: controller.forgotPasswordEmailController,
                  icon: SvgPicture.asset(AppImages.email, fit: BoxFit.cover),
                  hint: AppString.enterEmail,
                ),

                //Error Message
                SizedBox(height: 8.h),

                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Obx(
                    () => Text(
                      "${controller.errorMessageForgotPassword}",
                      style: AppTextStyles.s14w4i(color: AppColors.error),
                    ),
                  ),
                ),

                //Reset Password Here
                SizedBox(height: 24.h),
                CustomeButton(
                  bgColor: AppColors.brand,
                  onTap: controller.sendPasswordResetEmail,
                  title: AppString.resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
