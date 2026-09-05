import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendora/core/core.dart';
import 'package:vendora/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:vendora/features/home/controller/pop_up_controller.dart';
import 'package:vendora/features/profile/controller/profile_controller.dart';

class PopupOfferWidget extends StatelessWidget {
  final PopupOfferController controller;

  const PopupOfferWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isVisible.value) return const SizedBox.shrink();

      final profileController = Get.find<ProfileController>();
      if (profileController.isSubscribed.value) return const SizedBox.shrink();

      final trialDays = profileController.trialDaysRemaining.value;

      final bool isExpired = trialDays == 0;

      // Premium gradients and theme configuration
      final gradient = isExpired
          ? const LinearGradient(
              colors: [Color(0xFFFF5252), Color(0xFFFF1744)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : const LinearGradient(
              colors: [Color(0xFF6C63FE), Color(0xFF4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            );

      final icon = isExpired
          ? Icons.lock_outline_rounded
          : Icons.auto_awesome_rounded;
      final title = isExpired ? "Trial Expired ⚡" : "Free Trial Active ✨";
      final subtitle = isExpired
          ? "Subscribe now to keep unlocking premium BOGO deals!"
          : "You have $trialDays ${trialDays == 1 ? 'day' : 'days'} left. Enjoy your free offers!";
      final buttonText = isExpired ? "Upgrade" : "Go Premium";
      final buttonColor = isExpired
          ? const Color(0xFFFF1744)
          : const Color(0xFF6C63FE);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5.w,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    (isExpired
                            ? const Color(0xFFFF1744)
                            : const Color(0xFF6C63FE))
                        .withOpacity(0.35),
                blurRadius: 16.r,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Stack(
              children: [
                // Soft background glow circle pattern
                Positioned(
                  right: -20.w,
                  top: -20.h,
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      // Elegant circular container for icon
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: Colors.white, size: 18.sp),
                      ),
                      SizedBox(width: 12.w),
                      // Text details (Title and Subtitle)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: primaryFontStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // Dynamic CTA Button
                      ElevatedButton(
                        onPressed: () {
                          controller.hidePopup();
                          Get.until((route) => route.isFirst);
                          Get.find<BottomNavController>().changeTab(
                            1,
                          ); // Subscription Tab
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: Colors.white,
                          foregroundColor: buttonColor,
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.1),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 8.h,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                        ),
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Premium dismiss button on the top right
                Positioned(
                  top: 2.h,
                  right: 2.w,
                  child: GestureDetector(
                    onTap: () => controller.hidePopup(),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white.withOpacity(0.7),
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
