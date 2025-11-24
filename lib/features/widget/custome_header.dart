import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/constants/image_const.dart';
import 'package:template/core/themes/app_text_style.dart';

class CustomeHeader extends StatelessWidget {
  CustomeHeader({
    super.key,
    required this.title,
    this.isProfile = false,
    this.isHome = false,
  });

  final canGoBack = Navigator.of(Get.context!).canPop();
  final String title;
  final bool isProfile;
  final bool isHome;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 25.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Conditional Back Button
          canGoBack
              ? InkWell(
                  onTap: () => Get.back(),
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
              : SizedBox(width: 36.w), // Empty space to maintain alignment

          isProfile
              ? Text(
                  title,
                  style: AppTextStyles.s14w4i(fontweight: FontWeight.w500),
                )
              : Text(
                  "",
                  style: AppTextStyles.s14w4i(fontweight: FontWeight.w500),
                ),

          isHome
              ? InkWell(
                  onTap: () => Get.back(),
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
              : SizedBox(height: 36.w, width: 36.h),
        ],
      ),
    );
  }
}
