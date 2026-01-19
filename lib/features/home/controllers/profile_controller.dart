import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/core/constants/api_endpoints.dart';
import 'package:template/core/services/api_service.dart';
import 'package:template/core/services/local%20storage/storage_service.dart';
import 'package:template/core/utils/console.dart';
import 'package:template/features/widget/custome_snackbar.dart';
import 'package:template/routes/routes_name.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final RxString profileImagePath = ''.obs;
  final RxString profileImageUrl = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;

  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userPhone = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Fetch user profile from API
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      Console.info('Fetching user profile...');

      final response = await ApiService.getAuth(ApiEndpoints.profile);

      if (response.success && response.data != null) {
        Console.success('Profile fetched successfully');
        Console.info('Full response: ${response.data}');
        _loadProfileData(response.data);
      } else {
        Console.error('Failed to fetch profile: ${response.message}');
        CustomeSnackbar.error('Failed to load profile');
      }
    } catch (e) {
      Console.error('Error fetching profile: $e');
      CustomeSnackbar.error('Failed to load profile');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load profile data from API response
  void _loadProfileData(Map<String, dynamic> data) {
    Console.info('Parsing profile data...');

    // Handle different response structures
    Map<String, dynamic>? user;

    if (data['data'] != null && data['data']['user'] != null) {
      user = data['data']['user'];
    } else if (data['user'] != null) {
      user = data['user'];
    } else {
      Console.error('Invalid response structure');
      return;
    }

    Console.info('User data: $user');

    // Load basic info
    userName.value = user!['full_name'] ?? '';
    userEmail.value = user['email'] ?? '';
    userPhone.value = user['mobile_number'] ?? '';

    // Load profile picture with detailed logging
    final profilePicture = user['profile_picture'];
    Console.info('Profile picture raw value: $profilePicture');
    Console.info('Profile picture type: ${profilePicture.runtimeType}');

    if (profilePicture != null && profilePicture.toString().isNotEmpty) {
      String imageUrl = profilePicture.toString();

      // Handle relative URLs
      if (!imageUrl.startsWith('http')) {
        Console.info('Relative URL detected, adding base URL');
        imageUrl = 'https://harryapi.dsrt321.online$imageUrl';
      }

      profileImageUrl.value = imageUrl;
      Console.success('Profile image URL set: $imageUrl');
    } else {
      profileImageUrl.value = '';
      Console.info('No profile picture in response');
    }

    // Log final values
    Console.info('═══════════════════════════════════');
    Console.info('Profile Data Loaded:');
    Console.info('  Name: ${userName.value}');
    Console.info('  Email: ${userEmail.value}');
    Console.info('  Phone: ${userPhone.value}');
    Console.info('  Image URL: ${profileImageUrl.value}');
    Console.info('═══════════════════════════════════');
  }

  /// Toggle edit mode
  void toggleEditMode() {
    if (isEditMode.value) {
      nameController.clear();
      phoneController.clear();
      profileImagePath.value = '';
    } else {
      nameController.text = userName.value;
      phoneController.text = userPhone.value;
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
        Console.info('Image picked: ${image.path}');
        CustomeSnackbar.info('Profile picture selected');
      }
    } catch (e) {
      Console.error('Error picking image: $e');
      CustomeSnackbar.error('Failed to pick image');
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
        Console.info('Image captured: ${image.path}');
        CustomeSnackbar.info('Photo captured');
      }
    } catch (e) {
      Console.error('Error taking picture: $e');
      CustomeSnackbar.error('Failed to take picture');
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

  /// Update profile via API
  Future<void> updateProfile() async {
    if (!_validateInputs()) return;

    isLoading.value = true;

    try {
      Console.info('Updating profile...');

      final Map<String, String> fields = {
        'full_name': nameController.text.trim(),
        'mobile_number': phoneController.text.trim(),
      };

      final Map<String, File>? files = profileImagePath.value.isNotEmpty
          ? {'profile_picture': File(profileImagePath.value)}
          : null;

      Console.info('Fields: $fields');
      Console.info('Has image: ${files != null}');

      final response = await ApiService.uploadMultipart(
        url: ApiEndpoints.profile,
        method: 'PATCH',
        fields: fields,
        files: files,
      );

      if (response.success) {
        Console.success('Profile updated successfully');
        Console.info('Response: ${response.data}');

        profileImagePath.value = '';
        isEditMode.value = false;

        CustomeSnackbar.success('Profile updated successfully');

        // Refresh profile data
        await fetchProfile();
      } else {
        Console.error('Update failed: ${response.message}');
        CustomeSnackbar.error(response.message ?? 'Failed to update profile');
      }
    } catch (e) {
      Console.error('Update error: $e');
      CustomeSnackbar.error('Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  /// Validate input fields
  bool _validateInputs() {
    if (nameController.text.trim().isEmpty) {
      CustomeSnackbar.error('Please enter your name');
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      CustomeSnackbar.error('Please enter your phone number');
      return false;
    }

    if (phoneController.text.trim().length < 10) {
      CustomeSnackbar.error('Please enter a valid phone number');
      return false;
    }

    return true;
  }

  /// Logout user
  void logout() async {
    await StorageService.clearAll();
    Get.offAllNamed(RoutesName.login);
  }

  /// Get current profile image provider with debug logs
  ImageProvider? get currentProfileImage {
    Console.info('Getting current profile image...');
    Console.info('  Local path: ${profileImagePath.value}');
    Console.info('  Cloud URL: ${profileImageUrl.value}');

    // Show local image if selected during edit
    if (profileImagePath.value.isNotEmpty) {
      Console.info('  Returning: FileImage (local)');
      return FileImage(File(profileImagePath.value));
    }

    // Show cloud image if exists
    if (profileImageUrl.value.isNotEmpty) {
      Console.info('  Returning: NetworkImage (cloud)');
      return NetworkImage(profileImageUrl.value);
    }

    Console.info('  Returning: null (no image)');
    return null;
  }
}
