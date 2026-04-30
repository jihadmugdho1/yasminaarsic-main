import 'package:get/get.dart';
import 'package:yasminaarsic/features/editProfile/presentation/screens/edit_profile_screen.dart';
import 'package:yasminaarsic/features/authentication/presentation/screens/set_password_screen.dart';
import 'package:yasminaarsic/features/authentication/presentation/screens/sign_up_screen.dart';
import 'package:yasminaarsic/features/authentication/presentation/screens/login_screen.dart';
import 'package:yasminaarsic/features/bottom_navbar/screen/main_app_screen.dart';
import 'package:yasminaarsic/features/home/screen/home_screen.dart';
import 'package:yasminaarsic/features/home/vendor_details/screen/vendor_details_screen.dart';
import 'package:yasminaarsic/features/onboarding/screen/onborading_screen.dart';
import 'package:yasminaarsic/features/splash/screen/splash_screen.dart';
import 'package:yasminaarsic/features/subscription/presentation/screens/subscription_screen.dart';


class AppRoute {

  // bottom nav screens
  static String mainAppScreen = "/mainAppScreen";
  static String homeScreen = "/homeScreen";


  static String loginScreen = "/loginScreen";
  // Splash Screen
  static String splashScreen = "/splashScreen";
  // Onboarding Screen
  static String onboardingScreen = "/onboardingScreen";
  // Vendor Details Screen
  static String vendorDetailsScreen = "/vendorDetailsScreen";
   
   // +++++++++++++++++++++++++++++++++++++++++

  static String signUpScreen = "/signUpScreen";
  static String setPasswordScreen = "/setPasswordScreen";
  static String editProfileScreen = "/editProfileScreen";
  static String subscriptionScreen = "/subscriptionScreen";

  static String getLoginScreen() => loginScreen;
  // Splash Screen
  static String getSplashScreen() => splashScreen;
  // Onboarding Screen
  static String getOnboardingScreen() => onboardingScreen;
  // Offer Details Screen
  static String getVendorDetailsScreen() => vendorDetailsScreen;
  // Subscription Screen
  static String getSubscriptionScreen() => subscriptionScreen;
  
  // bottom nav screens
  static String getMainAppScreen() => mainAppScreen;
  static String getHomeScreen() => homeScreen;

   // +++++++++++++++++++++++++++++++++++++++++

  static List<GetPage> routes = [

    GetPage(name: loginScreen, page: () =>  LoginScreen()),
    // Splash Screen
    GetPage(name: splashScreen, page: () => const SplashScreen()),

    GetPage(name: signUpScreen, page: ()=> SignUpScreen()),

    GetPage(name: setPasswordScreen, page: ()=> SetPasswordScreen()),

    // bottom nav screens
    GetPage(name: mainAppScreen, page: () =>  MainAppScreen()),
    GetPage(name: homeScreen, page: () =>  HomeScreen()),



    GetPage(name: loginScreen, page: () => const LoginScreen()),
    // Splash Screen
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    // Onboarding Screen
    GetPage(name: onboardingScreen, page: () => const OnboradingScreen()),
    // Offer Details Screen
    GetPage(name: vendorDetailsScreen, page: () =>  VendorDetailsScreen()),

    GetPage(name: editProfileScreen, page:()=> EditProfileScreen()),
    // Subscription Screen
    GetPage(name: subscriptionScreen, page:()=> const SubscriptionScreen()), 

  ];
}
