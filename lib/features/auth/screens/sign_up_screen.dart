import 'package:ai_legal_assistant/core/constants/app_colors.dart';
import 'package:ai_legal_assistant/core/constants/app_string.dart';
import 'package:ai_legal_assistant/core/constants/image_const.dart';
import 'package:ai_legal_assistant/core/themes/app_text_style.dart';
import 'package:ai_legal_assistant/features/auth/controllers/auth_controller.dart.dart';
import 'package:ai_legal_assistant/features/auth/widgets/custome_textfield.dart';
import 'package:ai_legal_assistant/features/widget/custom_button.dart';
import 'package:ai_legal_assistant/features/widget/custome_header.dart';
import 'package:ai_legal_assistant/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({super.key});

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
                CustomeHeader(title: AppString.signup, isMenu: false),

                //Logo Here
                Image.asset(
                  AppImages.legalAiLogo,
                  width: 132.5.w,
                  height: 106.h,
                ),
                //Full Name Here
                SizedBox(height: 51.h),
                CustomeTextfield(
                  controller: controller.nameController,
                  icon: SvgPicture.asset(AppImages.user, fit: BoxFit.cover),
                  hint: AppString.enterFullName,
                ),

                //Email Address Here
                SizedBox(height: 16.h),
                CustomeTextfield(
                  controller: controller.emailController,
                  icon: SvgPicture.asset(AppImages.email, fit: BoxFit.cover),
                  hint: AppString.enterEmail,
                ),

                //Mobile Number Here
                SizedBox(height: 16.h),
                CustomeTextfield(
                  controller: controller.phoneController,
                  icon: SvgPicture.asset(AppImages.phone, fit: BoxFit.cover),
                  hint: AppString.enterMobile,
                ),

                //Enter Password Here
                SizedBox(height: 16.h),
                CustomeTextfield(
                  controller: controller.passwordController,
                  icon: SvgPicture.asset(AppImages.lcok, fit: BoxFit.cover),
                  hint: AppString.enterPassword,
                ),
                //Re Enter Password Here
                SizedBox(height: 16.h),
                CustomeTextfield(
                  controller: controller.confirmPasswordController,
                  icon: SvgPicture.asset(AppImages.lcok, fit: BoxFit.cover),
                  hint: AppString.reEnterPassword,
                ),

                //Error Message
                SizedBox(height: 8.h),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Obx(
                    () => Text(
                      "${controller.errorMessageSignUp}",
                      style: AppTextStyles.s14w4i(color: AppColors.error),
                    ),
                  ),
                ),

                //Sign Up Here
                SizedBox(height: 55.h),
                Obx(
                  () => CustomeButton(
                    bgColor: AppColors.brand,
                    isLoading: controller.isLoading.value,
                    onTap: controller.signUp,
                    title: AppString.signup,
                  ),
                ),

                //Sign In Here
                SizedBox(height: 20.h),
                CustomeButton(
                  bgColor: AppColors.brand,
                  onTap: () => Get.toNamed(RoutesName.login),
                  title: AppString.signin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
