import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:yasminaarsic/core/services/storage_service.dart';
import 'package:yasminaarsic/core/utils/logging/logger.dart';

class FirebaseService {
  static Future<void> init() async {
    await Firebase.initializeApp(); // initializing firebase
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // iOS permissions
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // get device token
    String? _token = await messaging.getToken();

    // developer can save the FCM Token to lcal database from here
    print("FCM Token: $_token");
    AppLoggerHelper.info("FCM Token: $_token");

    if (_token != null) {
      await StorageService.saveFcmToken(_token);
    }
  }
}
