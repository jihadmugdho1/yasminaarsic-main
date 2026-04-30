import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yasminaarsic/features/editProfile/data/edit_profile_model.dart';
import 'package:yasminaarsic/features/editProfile/service/edit_profile_service.dart';
import 'package:yasminaarsic/features/editProfile/service/upload_image_service.dart';
import 'package:yasminaarsic/features/profile/controller/profile_controller.dart';

class EditProfileController extends GetxController {
  final EditProfileService _editProfileService = EditProfileService();
  final UploadImageService _uploadImageService =
      UploadImageService(); // ✅ New service

  final profile = UserData(
    id: '',
    name: '',
    email: '',
    phone: '',
    location: '',
    dateOfBirth: null,
    imageUrl: null,
    role: 'USER',
    status: 'ACTIVE',
    isEmailVerified: false,
    updatedAt: DateTime.now(),
  ).obs;

  final RxBool isSaving = false.obs;
  final RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController locationController;
  late final TextEditingController birthDateController;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    locationController = TextEditingController();
    birthDateController = TextEditingController();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    final user = await _editProfileService.getProfile();
    if (user != null) {
      profile.value = user;
      nameController.text = user.name;
      emailController.text = user.email;
      phoneController.text = user.phone ?? '';
      locationController.text = user.location ?? '';
      if (user.dateOfBirth != null) {
        birthDateController.text = DateFormat(
          'MM/dd/yyyy',
        ).format(user.dateOfBirth!);
      }
    } else {
      Get.snackbar('Error', 'Failed to load profile');
    }
    isLoading.value = false;
  }

  void onBackPressed() => Get.back();
  void onCancelPressed() => Get.back();

  void onSavePressed() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (profile.value.id.isEmpty) {
      Get.snackbar('Error', 'Profile not loaded');
      return;
    }

    isSaving.value = true;

    DateTime? dob;
    if (birthDateController.text.isNotEmpty) {
      try {
        dob = DateFormat('MM/dd/yyyy').parse(birthDateController.text);
      } catch (e) {
        Get.snackbar('Error', 'Invalid date');
        isSaving.value = false;
        return;
      }
    }

    // ✅ Use dedicated upload service
    String? newImageUrl;
    if (selectedImage.value != null) {
      final uploadResult = await _uploadImageService.uploadImage(
        selectedImage.value!,
      );
      if (uploadResult != null) {
        newImageUrl = uploadResult.imageUrl;
      } else {
        Get.snackbar('Error', 'Image upload failed');
        isSaving.value = false;
        return;
      }
    }

    final updatedData = <String, dynamic>{
      'name': nameController.text.trim(),
      if (phoneController.text.trim().isNotEmpty)
        'phone': phoneController.text.trim(),
      if (locationController.text.trim().isNotEmpty)
        'location': locationController.text.trim(),
      if (dob != null) 'dateOfBirth': dob.toIso8601String(),
      if (newImageUrl != null && newImageUrl.isNotEmpty)
        'imageUrl': newImageUrl,
    };

    final updatedUser = await _editProfileService.updateProfile(
      profile.value.id,
      updatedData,
    );
    isSaving.value = false;

    if (updatedUser != null) {
      profile.value = updatedUser;
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().updateProfileFromEdit(updatedUser);
      }
      Get.back();
    } else {
      Get.snackbar('Error', 'Failed to update profile');
    }
  }

  // Validation methods (unchanged)
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(value) ? null : 'Invalid email';
  }

  String? validatePhone(String? value) => null;
  String? validateLocation(String? value) {
    if (value != null && value.isNotEmpty && value.length < 3) {
      return 'Location too short';
    }
    return null;
  }

  String? validateBirthDate(String? value) => null;

  Future<void> onBirthDatePressed() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: profile.value.dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      birthDateController.text = DateFormat('MM/dd/yyyy').format(picked);
    }
  }

  Future<void> onCameraPressed() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image?.path.isNotEmpty == true) {
      selectedImage.value = File(image!.path);
    }
  }

  @override
  void onClose() {
    // Intentionally not disposing controllers to avoid use-after-dispose errors
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    birthDateController.dispose();
    super.onClose();
  }
}
