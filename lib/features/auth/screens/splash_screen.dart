import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:template/core/constants/app_string.dart';
import 'package:template/core/constants/image_const.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/auth/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  //
  final controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Logo
              Image.asset(AppImages.legalAiLogo, width: 261.w, height: 200.h),
              //title
              SizedBox(height: 15.h),
              Text(AppString.aiLegalAssistant, style: AppTextStyles.s24w6p()),

              //desc
              SizedBox(height: 15.h),
              Text(
                AppString.yourIntelligentLegalResearchCompanion,
                style: AppTextStyles.s16w4p(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
