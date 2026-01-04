import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/constants/app_string.dart';
import 'package:template/core/constants/image_const.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:template/features/widget/custom_button.dart';
import 'package:template/features/widget/custome_header.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomeHeader(
                title: "Profile",
                isProfile: true,
                onTapDrawer: () => Get.back(),
              ),
            ),

            SizedBox(height: 30.h),

            // Profile Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    // Profile Picture
                    _buildProfilePicture(),

                    SizedBox(height: 16.h),

                    // Name
                    Obx(
                      () => Text(
                        controller.isEditMode.value
                            ? controller.nameController.text.isEmpty
                                  ? 'Your Name'
                                  : controller.nameController.text
                            : controller.userName.value,
                        style: AppTextStyles.s16w4p(
                          fontweight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Email
                    Obx(
                      () => Text(
                        controller.isEditMode.value
                            ? controller.emailController.text.isEmpty
                                  ? 'your@email.com'
                                  : controller.emailController.text
                            : controller.userEmail.value,
                        style: AppTextStyles.s16w4p(
                          fontSize: 12.sp,
                          color: AppColors.gray,
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Edit Button
                    Obx(
                      () => GestureDetector(
                        onTap: () => controller.toggleEditMode(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: controller.isEditMode.value
                                ? Colors.grey[400]
                                : AppColors.brand,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                controller.isEditMode.value
                                    ? Icons.close
                                    : Icons.edit,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                controller.isEditMode.value
                                    ? 'Cancel'
                                    : 'Edit Profile',
                                style: AppTextStyles.s12w4arimo(
                                  color: AppColors.whiteText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Profile Fields
                    Obx(
                      () => controller.isEditMode.value
                          ? _buildEditableFields()
                          : _buildDisplayFields(),
                    ),

                    SizedBox(height: 40.h),

                    // Update Button
                    Obx(
                      () => controller.isEditMode.value
                          ? _buildUpdateButton()
                          : const SizedBox.shrink(),
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Obx(() {
      final isEditable = controller.isEditMode.value;
      return GestureDetector(
        onTap: isEditable ? () => controller.showImageSourceDialog() : null,
        child: Stack(
          children: [
            // Profile Image
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isEditable ? AppColors.brand : const Color(0xFFFFB991),
                  width: 2,
                ),
                image: controller.currentProfileImage != null
                    ? DecorationImage(
                        image: controller.currentProfileImage!,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: controller.currentProfileImage == null
                  ? Icon(Icons.person, size: 50.sp, color: Colors.grey[400])
                  : null,
            ),

            // Edit Button (only in edit mode)
            if (isEditable)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: AppColors.brand,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  // ========== DISPLAY MODE ==========
  Widget _buildDisplayFields() {
    return Column(
      children: [
        _buildDisplayField(
          icon: AppImages.user,
          label: controller.userName.value,
        ),
        SizedBox(height: 16.h),
        _buildDisplayField(
          icon: AppImages.email,
          label: controller.userEmail.value,
        ),
        SizedBox(height: 16.h),
        _buildDisplayField(
          icon: AppImages.phone,
          label: controller.userPhone.value,
        ),
        SizedBox(height: 16.h),
        _buildDisplayField(icon: AppImages.lcok, label: '••••••••••'),

        SizedBox(height: 40.h),
        _buildLogoutButton(),
      ],
    );
  }

  Widget _buildDisplayField({required String icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
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
            offset: const Offset(0, 2),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.s14w4i(
                fontSize: 14.sp,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== EDIT MODE ==========
  Widget _buildEditableFields() {
    return Column(
      children: [
        _buildEditableField(
          icon: AppImages.user,
          controller: controller.nameController,
          hint: 'Full Name',
        ),
        SizedBox(height: 16.h),
        _buildEditableField(
          icon: AppImages.email,
          controller: controller.emailController,
          hint: 'Email Address',
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.h),
        _buildEditableField(
          icon: AppImages.phone,
          controller: controller.phoneController,
          hint: 'Phone Number',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.h),
        _buildPasswordField(),
      ],
    );
  }

  Widget _buildEditableField({
    required String icon,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.brand.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: AppTextStyles.s14w4i(
                fontSize: 14.sp,
                color: Colors.grey[800],
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.s14w4i(
                  fontSize: 14.sp,
                  color: Colors.grey[400],
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.brand.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppImages.lcok),
          SizedBox(width: 12.w),
          Expanded(
            child: Obx(
              () => TextField(
                controller: controller.passwordController,
                obscureText: !controller.showPassword.value,
                style: AppTextStyles.s14w4i(
                  fontSize: 14.sp,
                  color: Colors.grey[800],
                ),
                decoration: InputDecoration(
                  hintText: 'Enter password to confirm', // ✅ Updated hint
                  hintStyle: AppTextStyles.s14w4i(
                    fontSize: 14.sp,
                    color: Colors.grey[400],
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Obx(
            () => GestureDetector(
              onTap: () => controller.togglePasswordVisibility(),
              child: Icon(
                controller.showPassword.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey[400],
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Obx(() {
      final isLoading = controller.isLoading.value;

      return CustomeButton(
        onTap: isLoading ? null : () => controller.updateProfile(),
        title: isLoading ? "Saving Changes..." : AppString.update,
      );
    });
  }

  Widget _buildLogoutButton() {
    return Obx(() {
      final isLoading = controller.isLoading.value;

      return CustomeButton(
        onTap: isLoading ? null : () => controller.logout(),
        title: isLoading ? "Logging out..." : "Logout",
      );
    });
  }
}
