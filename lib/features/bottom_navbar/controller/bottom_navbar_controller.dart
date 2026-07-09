import 'package:get/get.dart';
import 'package:vendora/features/alerts/presentation/screens/alerts_screen.dart';
import 'package:vendora/features/profile/presentation/screens/profile_screen.dart';
import 'package:vendora/features/home/screen/home_screen.dart';
import 'package:vendora/features/savings/presentation/screens/savings_screen.dart';
import 'package:vendora/features/subscription/presentation/screens/subscription_screen.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  final screens = [

     HomeScreen(),
    const SubscriptionScreen(),
    const SavingsScreen(),
    const AlertsScreen(),
    const ProfileScreen()

  ];

  void changeTab(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
    }
  }
}
