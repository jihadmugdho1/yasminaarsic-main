import 'package:get/get.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/core/services/storage_service.dart';
import 'package:yasminaarsic/core/utils/logging/logger.dart';
import 'package:yasminaarsic/features/editProfile/data/edit_profile_model.dart';
import 'package:yasminaarsic/features/profile/data/models/notification_model.dart';
import 'package:yasminaarsic/features/profile/data/models/notification_preference_model.dart';
import 'package:yasminaarsic/features/profile/data/models/user_model.dart';
import 'package:yasminaarsic/features/profile/data/profile_model.dart';
import 'package:yasminaarsic/features/authentication/controllers/login_controller.dart';
import 'package:yasminaarsic/features/profile/data/services/notification_preference_service.dart';
import 'package:yasminaarsic/features/profile/data/services/profile_service.dart';
import 'package:yasminaarsic/routes/app_routes.dart';

class ProfileController extends GetxController {
  late LocalizationController _localeController;
  final ProfileService _profileService = ProfileService();
  final NotificationPreferenceService _notificationService =
      NotificationPreferenceService();

  final profile = ProfileModel(
    name: '',
    email: '',
    phone: '',
    location: '',
    birthDate: '',
    avatarInitials: '',
    notificationPreferences: [],
  ).obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  var selectedLanguage = 'en'.obs;
  final isSubscribed = false.obs;

  @override
  void onInit() {
    super.onInit();
    _localeController = Get.find<LocalizationController>();
    selectedLanguage.value = _localeController.currentLanguage.value;
    _fetchFullProfile();
  }

  Future<void> fetchProfileData() async {
    await _fetchFullProfile();
  }

  Future<void> _fetchFullProfile() async {
    isLoading.value = true;
    try {
      final token = StorageService.token;
      if (token == null) {
        Get.snackbar('Auth Error', 'Session expired');
        Get.offAllNamed(AppRoute.loginScreen);
        return;
      }

      final profileResp = await _profileService.getProfile('Bearer $token');
      if (!profileResp.isSuccess || profileResp.responseData == null) {
        Get.snackbar('Error', profileResp.errorMessage);
        return;
      }

      final user = profileResp.responseData as UserModel;

      isSubscribed.value = user.isSubscribed;

      // Notification preferences come embedded in the profile response (notifications[0])
      final notifData = user.notifications.isNotEmpty ? user.notifications.first : null;
      AppLoggerHelper.debug('[ProfileController] notifications from profile: $notifData');

      final prefs = _buildNotificationPreferences(notifData);

      String formatBirthDate(String? raw) {
        if (raw == null || raw.isEmpty) return 'Not specified';
        try {
          if (raw.contains('T')) return raw.split('T')[0];
          final d = DateTime.parse(raw);
          return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        } catch (e) {
          return raw;
        }
      }

      profile.value = ProfileModel(
        name: user.name,
        email: user.email,
        phone: user.phone ?? 'Not specified',
        location: user.location ?? 'Not specified',
        birthDate: formatBirthDate(user.dateOfBirth),
        avatarInitials: _getInitials(user.name),
        imageUrl: user.imageUrl,
        notificationPreferences: prefs,
      );
    } catch (e) {
      AppLoggerHelper.error('Profile Load Error', e);
      Get.snackbar('Error', 'Failed to load profile data');
    } finally {
      isLoading.value = false;
    }
  }

  List<NotificationPreferenceModel> _buildNotificationPreferences(
    NotificationModel? apiData,
  ) {
    return [
      NotificationPreferenceModel(
        label: _localeController.get('new_offers'),
        description: _localeController.get('get_notified_offers'),
        isEnabled: apiData?.newOffer ?? false,
      ),
      NotificationPreferenceModel(
        label: _localeController.get('renewal_reminders'),
        description: _localeController.get('subscription_renewal'),
        isEnabled: apiData?.renewalReminder ?? false,
      ),
      NotificationPreferenceModel(
        label: _localeController.get('promotions'),
        description: _localeController.get('special_deals'),
        isEnabled: apiData?.promotional ?? false,
      ),
    ];
  }

  void updateProfileFromEdit(UserData updatedUserData) {
    profile.value = ProfileModel(
      name: updatedUserData.name,
      email: updatedUserData.email,
      phone: updatedUserData.phone ?? 'Not specified',
      location: updatedUserData.location ?? 'Not specified',
      birthDate: updatedUserData.dateOfBirth != null
          ? '${updatedUserData.dateOfBirth!.year}-${updatedUserData.dateOfBirth!.month.toString().padLeft(2, '0')}-${updatedUserData.dateOfBirth!.day.toString().padLeft(2, '0')}'
          : 'Not specified',
      avatarInitials: _getInitials(updatedUserData.name),
      imageUrl: updatedUserData.imageUrl,
      notificationPreferences: profile.value.notificationPreferences,
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    String joined = name.split(' ').map((s) => s.isNotEmpty ? s[0] : '').join();
    return joined
        .substring(0, joined.length < 2 ? joined.length : 2)
        .toUpperCase();
  }

  void onLanguageChanged(String languageCode) async {
    await _localeController.setLanguage(languageCode);
    selectedLanguage.value = languageCode;

    // Re-build preferences with new locale, but preserve enabled status
    final currentPrefs = profile.value.notificationPreferences;
    final newPrefs = _buildNotificationPreferences(
      null,
    ); // This gives us new labels

    // Preserve the isEnabled state from the old preferences
    for (int i = 0; i < newPrefs.length; i++) {
      if (i < currentPrefs.length) {
        newPrefs[i].isEnabled = currentPrefs[i].isEnabled;
      }
    }

    profile.value = ProfileModel(
      name: profile.value.name,
      email: profile.value.email,
      phone: profile.value.phone,
      location: profile.value.location,
      birthDate: profile.value.birthDate,
      avatarInitials: profile.value.avatarInitials,
      notificationPreferences: newPrefs,
    );
  }

  void onNotificationToggle(int index, bool value) async {
    // Create a new list with the updated item
    final newPrefs = List<NotificationPreferenceModel>.from(
      profile.value.notificationPreferences,
    );
    newPrefs[index] = NotificationPreferenceModel(
      label: newPrefs[index].label,
      description: newPrefs[index].description,
      isEnabled: value,
    );

    // Optimistic UI update with the new list
    profile.value = ProfileModel(
      name: profile.value.name,
      email: profile.value.email,
      phone: profile.value.phone,
      location: profile.value.location,
      birthDate: profile.value.birthDate,
      avatarInitials: profile.value.avatarInitials,
      notificationPreferences: newPrefs,
    );

    // Build API payload from current state
    final currentPrefs = profile.value.notificationPreferences;
    final payload = {
      'newOffer': currentPrefs[0].isEnabled,
      'renewalReminder': currentPrefs[1].isEnabled,
      'promotional': currentPrefs[2].isEnabled,
    };

    AppLoggerHelper.debug('[ProfileController] onNotificationToggle index=$index value=$value payload=$payload');

    final response = await _notificationService.updateNotificationPreferences(
      payload,
    );

    AppLoggerHelper.debug('[ProfileController] onNotificationToggle response: isSuccess=${response.isSuccess} statusCode=${response.statusCode} data=${response.responseData} error=${response.errorMessage}');

    if (!response.isSuccess) {
      // Revert on failure
      final revertedPrefs = List<NotificationPreferenceModel>.from(
        profile.value.notificationPreferences,
      );
      revertedPrefs[index] = NotificationPreferenceModel(
        label: revertedPrefs[index].label,
        description: revertedPrefs[index].description,
        isEnabled: !value,
      );
      profile.value = ProfileModel(
        name: profile.value.name,
        email: profile.value.email,
        phone: profile.value.phone,
        location: profile.value.location,
        birthDate: profile.value.birthDate,
        avatarInitials: profile.value.avatarInitials,
        notificationPreferences: revertedPrefs,
      );
      Get.snackbar('Error', response.errorMessage);
    }
  }

  void onLogoutPressed() async {
    await StorageService.logoutUser();
    await Get.find<LoginController>().signOutGoogle();
    AppLoggerHelper.info(
      '🚪 User logged out, token and data cleared from storage',
    );
    Get.offAllNamed(AppRoute.loginScreen);
  }

  // UI handlers (unchanged)
  void onEditPressed() async {
    await Get.toNamed(AppRoute.editProfileScreen);
  }

  void onProfileCardTap() {}
  void onEmailTap() {}
  void onPhoneTap() {}
  void onChangePasswordPressed() {
    Get.toNamed(AppRoute.setPasswordScreen);
  }

  void onPasswordCardTap() {}
  void onNotificationPreferencesTap() {}
}
