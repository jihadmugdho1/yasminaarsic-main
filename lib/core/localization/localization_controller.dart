import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_translations.dart';

class LocalizationController extends GetxController {
  static const _kPrefKey = 'app_language';

  final currentLanguage = 'en'.obs;
  final translations = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kPrefKey) ?? 'en';
    await setLanguage(saved);
  }

  Future<void> setLanguage(String code) async {
    if (!AppTranslations.translations.containsKey(code)) code = 'en';
    currentLanguage.value = code;

    // Update translations map
    final map = AppTranslations.translations[code] ?? {};
    translations.assignAll(map);

    // Persist
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefKey, code);

    // Update Get locale as well
    Get.updateLocale(Locale(code));

    update();
  }

  String get(String key) {
    return translations[key] ?? key;
  }

  Locale getLocale() => Locale(currentLanguage.value);
}
