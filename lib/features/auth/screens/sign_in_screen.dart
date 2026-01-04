import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/constants/app_string.dart';
import 'package:template/core/constants/image_const.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/auth/controllers/auth_controller.dart.dart';
import 'package:template/features/auth/widgets/custome_textfield.dart';
import 'package:template/features/widget/custom_button.dart';
import 'package:template/features/widget/custome_header.dart';
import 'package:template/routes/routes_name.dart';

class SignInScreen extends GetView<AuthController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              //Header Here
              CustomeHeader(title: AppString.signin, isMenu: false),

              //Logo Here
              Image.asset(AppImages.legalAiLogo, width: 132.5.w, height: 106.h),

              //Email Address Here
              SizedBox(height: 51.h),
              CustomeTextfield(
                controller: controller.loginEmailController,
                icon: SvgPicture.asset(AppImages.email, fit: BoxFit.cover),
                hint: AppString.enterEmail,
              ),

              //Enter Password Here
              SizedBox(height: 16.h),
              CustomeTextfield(
                controller: controller.loginPasswordController,
                icon: SvgPicture.asset(AppImages.lcok, fit: BoxFit.cover),
                hint: AppString.enterPassword,
              ),

              //Forgot Password
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Error Message
                  Obx(
                    () => Text(
                      "${controller.errorMessageSignIn}",
                      style: AppTextStyles.s14w4i(color: AppColors.error),
                    ),
                  ),

                  //Forgot Password
                  InkWell(
                    onTap: () => Get.toNamed(RoutesName.forgetPassword),
                    child: Text(
                      AppString.forgotPassword,
                      style: AppTextStyles.s14w4i(color: AppColors.brand),
                    ),
                  ),
                ],
              ),
              //Sign In Here
              SizedBox(height: 27.h),
              CustomeButton(
                bgColor: AppColors.brand,
                onTap: controller.signIn,
                title: AppString.signin,
              ),

              //Sign Up Here
              SizedBox(height: 20.h),
              CustomeButton(
                bgColor: AppColors.brand,
                onTap: () => Get.toNamed(RoutesName.signUp),
                title: AppString.signup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
