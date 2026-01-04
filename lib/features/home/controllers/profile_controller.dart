// lib/controllers/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:template/core/utils/services/local_storage_service.dart';
import 'package:template/routes/routes_name.dart';

class ProfileController extends GetxController {
  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController =
      TextEditingController(); // Password for verification only

  // Observable values
  final RxString profileImagePath = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool showPassword = false.obs;
  final RxBool isEditMode = false.obs;

  // User data (for display mode)
  final RxString userName = 'Kurt Cobain'.obs;
  final RxString userEmail = 'Kurtcobain@gmail.com'.obs;
  final RxString userPhone = '+88 01673723672632712'.obs;
  final RxString userPassword =
      'password123'.obs; // Stored password for verification

  // Image picker
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Load user data from storage
  void _loadUserData() {
    // TODO: Load from GetStorage/API when backend ready
    userName.value = 'Kurt Cobain';
    userEmail.value = 'Kurtcobain@gmail.com';
    userPhone.value = '+88 01673723672632712';
    userPassword.value = 'password123'; // In production, this should be hashed
  }

  /// Toggle edit mode
  void toggleEditMode() {
    if (isEditMode.value) {
      // Cancel edit - reset fields
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
    } else {
      // Enter edit mode - populate fields
      nameController.text = userName.value;
      emailController.text = userEmail.value;
      phoneController.text = userPhone.value;
      passwordController.clear(); // Password always empty
    }
    isEditMode.value = !isEditMode.value;
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        profileImagePath.value = image.path;
        print('✅ Image picked: ${image.path}');

        Get.snackbar(
          'Success',
          'Profile picture updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        profileImagePath.value = image.path;
        print('✅ Image captured: ${image.path}');

        Get.snackbar(
          'Success',
          'Profile picture updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('❌ Error taking picture: $e');
      Get.snackbar(
        'Error',
        'Failed to take picture',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Show image source selection dialog
  void showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.orange),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.orange),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// Update profile - REQUIRES PASSWORD VERIFICATION
  Future<void> updateProfile() async {
    // First validate inputs
    if (!_validateInputs()) return;

    // MUST verify password before updating
    if (!_verifyPassword()) {
      return; // Password verification failed
    }

    isLoading.value = true;

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Update display values (local only)
      userName.value = nameController.text;
      userEmail.value = emailController.text;
      userPhone.value = phoneController.text;

      // TODO: Save to backend/GetStorage
      // await ApiService.updateProfile({
      //   'name': nameController.text,
      //   'email': emailController.text,
      //   'phone': phoneController.text,
      //   'password': passwordController.text, // For verification
      // });

      print('✅ Profile updated:');
      print('   Name: ${userName.value}');
      print('   Email: ${userEmail.value}');
      print('   Phone: ${userPhone.value}');
      print('   Image: ${profileImagePath.value}');

      // Clear password field
      passwordController.clear();

      // Exit edit mode
      isEditMode.value = false;

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify password before updating profile
  bool _verifyPassword() {
    final password = passwordController.text.trim();

    // Password is required
    if (password.isEmpty) {
      Get.snackbar(
        'Password Required',
        'Please enter your password to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    // Check if password matches
    // TODO: In production, send to backend for verification
    if (password != userPassword.value) {
      Get.snackbar(
        'Incorrect Password',
        'The password you entered is incorrect',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    return true;
  }

  /// Validate inputs
  bool _validateInputs() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar('Error', 'Please enter a valid email');
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number');
      return false;
    }

    return true;
  }

  void logout() async {
    await LocalStorageService.clearAllData();
    Get.offAllNamed(RoutesName.login);
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  /// Get current profile image to display
  ImageProvider? get currentProfileImage {
    if (profileImagePath.value.isNotEmpty) {
      return FileImage(File(profileImagePath.value));
    }
    return null;
  }
}
