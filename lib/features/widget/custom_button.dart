import 'package:ai_legal_assistant/core/constants/app_colors.dart';
import 'package:ai_legal_assistant/core/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomeButton extends StatefulWidget {
  final Color? bgColor;
  final Color? textColor;
  final String title;
  final void Function()? onTap;
  final bool isLoading; // Loading state

  const CustomeButton({
    super.key,
    this.bgColor = AppColors.buttonBg,
    required this.onTap,
    required this.title,
    this.textColor = AppColors.whiteText,
    this.isLoading = false, // Default false
  });

  @override
  State<CustomeButton> createState() => _CustomeButtonState();
}

class _CustomeButtonState extends State<CustomeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.isLoading ? null : (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: widget.isLoading ? null : () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: 48.h,
        transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
        decoration: BoxDecoration(
          color: widget.isLoading 
              ? widget.bgColor?.withOpacity(0.7) 
              : widget.bgColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.pText.withOpacity(_isPressed ? 0.2 : 0.4),
              blurRadius: _isPressed ? 5 : 0,
              spreadRadius: _isPressed ? 1 : 0,
              offset: Offset(0, _isPressed ? 4 : 0),
            ),
          ],
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.textColor ?? AppColors.whiteText,
                    ),
                  ),
                )
              : Text(
                  widget.title,
                  style: AppTextStyles.s16w4p(
                    fontweight: FontWeight.w700,
                    color: widget.textColor,
                  ),
                ),
        ),
      ),
    );
  }
}