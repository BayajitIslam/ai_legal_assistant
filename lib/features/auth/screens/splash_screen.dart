import 'package:ai_legal_assistant/core/constants/app_string.dart';
import 'package:ai_legal_assistant/core/constants/image_const.dart';
import 'package:ai_legal_assistant/core/themes/app_text_style.dart';
import 'package:ai_legal_assistant/features/auth/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';

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
