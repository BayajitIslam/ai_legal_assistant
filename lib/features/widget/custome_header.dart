import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/constants/image_const.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/routes/routes_name.dart';

class CustomeHeader extends StatelessWidget {
  CustomeHeader({
    super.key,
    required this.title,
    this.isProfile = false,
    this.isHome = false,
    this.onTapDrawer,
    this.isMenu = true,
  });

  final canGoBack = Navigator.of(Get.context!).canPop();
  final String title;
  final bool isProfile;
  final bool isHome;
  final bool isMenu;
  final VoidCallback? onTapDrawer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 25.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Button (Menu or Back)
          isMenu
              ? GestureDetector(
                  onTap: () {
                    if (isHome) {
                      onTapDrawer?.call(); // ✅ FIX: Call the function with ()
                    } else if (canGoBack) {
                      Get.back();
                    }
                  },
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: AppColors.brand,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFFB991)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brand,
                          blurRadius: 25,
                          blurStyle: BlurStyle.inner,
                        ),
                      ],
                    ),
                    child: Icon(
                      isHome ? Icons.menu : Icons.arrow_back,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                )
              : SizedBox.shrink(),

          // Title
          isProfile
              ? Text(
                  title,
                  style: AppTextStyles.s14w4i(fontweight: FontWeight.w500),
                )
              : const SizedBox.shrink(),

          // Right Button (Profile)
          if (isHome)
            InkWell(
              onTap: () => Get.toNamed(RoutesName.profile),
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: AppColors.brand,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFB991)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brand,
                      blurRadius: 25,
                      blurStyle: BlurStyle.inner,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(8.w),
                child: SvgPicture.asset(AppImages.profile),
              ),
            )
          else
            SizedBox(height: 36.w, width: 36.h),
        ],
      ),
    );
  }
}
