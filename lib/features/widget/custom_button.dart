import 'package:ai_legal_assistant/core/constants/app_colors.dart';
import 'package:ai_legal_assistant/core/themes/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomeButton extends StatefulWidget {
  final Color? bgColor;
  final Color? textColor;
  final String title;
  final void Function()? onTap;

  const CustomeButton({
    super.key,
    this.bgColor = AppColors.buttonBg,
    required this.onTap,
    required this.title,
    this.textColor = AppColors.whiteText,
  });

  @override
  State<CustomeButton> createState() => _CustomeButtonState();
}

class _CustomeButtonState extends State<CustomeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: 48.h,
        transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
        decoration: BoxDecoration(
          color: widget.bgColor,
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
          child: Text(
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
