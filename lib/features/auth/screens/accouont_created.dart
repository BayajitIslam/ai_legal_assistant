import 'package:ai_legal_assistant/core/constants/app_string.dart';
import 'package:ai_legal_assistant/core/constants/image_const.dart';
import 'package:ai_legal_assistant/core/themes/app_text_style.dart';
import 'package:ai_legal_assistant/features/widget/custom_button.dart';
import 'package:ai_legal_assistant/features/widget/custome_header.dart';
import 'package:ai_legal_assistant/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccouontCreated extends StatelessWidget {
  const AccouontCreated({super.key});

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
                SizedBox(height: 49.h),
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
                Text(
                  textAlign: TextAlign.center,
                  "Your account has been created. You can now log in and start exploring your account.",
                  style: AppTextStyles.s14w4i(),
                ),

                // Submit Button
                SizedBox(height: 51.h),
                CustomeButton(
                  title: AppString.signin,
                  onTap: () => Get.toNamed(RoutesName.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
