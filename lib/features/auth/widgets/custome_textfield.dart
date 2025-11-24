import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';

class CustomeTextfield extends StatelessWidget {
  final TextEditingController controller;
  final Widget icon;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  const CustomeTextfield({
    super.key,
    required this.controller,
    required this.icon,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
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
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.s16w4i(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.s16w4i(),
          prefixIcon: Container(padding: EdgeInsets.all(16.w), child: icon),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.whiteText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(),
          ),

          // Border when not focused (enabled state)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: AppColors.bg, // Border color when not focused
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.brand, width: 1),
          ),
        ),
      ),
    );
  }
}
