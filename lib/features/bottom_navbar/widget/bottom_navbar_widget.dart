import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendora/core/utils/constants/colors.dart';
import 'package:vendora/core/utils/constants/icon_path.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/features/bottom_navbar/controller/bottom_navbar_controller.dart';

class BottomNavbarWidget extends StatelessWidget {
  const BottomNavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();
    final locale = Get.find<LocalizationController>();

    // Define SVG paths for each tab
    final List<String> unselectedSvgPaths = [
      IconPath.homeIcon,
      IconPath.subscriptionsIcon,
      IconPath.savingsIcon,
      IconPath.alertsIcon,
      IconPath.profileIcon,
    ];

    final List<String> selectedSvgPaths = [
      IconPath.homeIcon,
      IconPath.subscriptionsIcon,
      IconPath.savingsIcon,
      IconPath.alertsIcon,
      IconPath.profileIcon,
    ];

    // Define tab labels
    final List<String> tabLabelKeys = [
      'nav_home',
      'nav_subscription',
      'nav_savings',
      'nav_alerts',
      'nav_profile',
    ];

    return SafeArea(
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            return Obx(() {
              final isActive = controller.currentIndex.value == index;

              return GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  // padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        isActive
                            ? selectedSvgPaths[index]
                            : unselectedSvgPaths[index],
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.contain,
                        color: isActive ? AppColors.primary : Colors.grey,
                      ),
                      SizedBox(height: 4.h),
                      Obx(
                        () => Text(
                          locale.get(tabLabelKeys[index]),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isActive ? AppColors.primary : Colors.grey,
                            fontFamily: 'poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          }),
        ),
      ),
    );
  }
}
