import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/features/onboarding/controller/onboarding_controller.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';

import '../../../../core/common/widgets/custom_button.dart';

class OnboradingScreen extends StatelessWidget {
  const OnboradingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    final locale = Get.find<LocalizationController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main icon changes with page
                    CircleAvatar(
                      backgroundColor: Color(0xFFE0E7FF),
                      radius: 38.r,
                      child: Image.asset(
                        controller.icons[controller.currentIndex.value],
                        height: 48.h,
                        width: 48.w,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Obx(
                        () => Text(
                          locale.get(
                            'onboarding_title_${controller.currentIndex.value + 1}',
                          ),
                          style: tertiaryFontStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Obx(
                        () => Text(
                          locale.get(
                            'onboarding_description_${controller.currentIndex.value + 1}',
                          ),
                          style: tertiaryFontStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            lineHeight: 9,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (i) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: i == controller.currentIndex.value
                              ? 36.w
                              : 20.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: i == controller.currentIndex.value
                                ? AppColors.primary
                                : Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    CustomButton(
                      text: locale.get(
                        controller.isLastSlide ? 'get_started' : 'next',
                      ),
                      textColor: Colors.white,
                      type: ButtonType.filled,
                      minWidth: double.infinity,
                      borderRadius: 12.r,
                      gradient: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(1.0),
                      ],
                      height: 45.h,
                      onPressed: controller.isLastSlide
                          ? controller.getStarted
                          : controller.next,
                    ),
                    SizedBox(height: 12.h),
                    CustomButton(
                      text: locale.get('skip'),
                      textColor: Colors.black,
                      type: ButtonType.outlined,
                      minWidth: double.infinity,
                      borderRadius: 12.r,
                      backgroundColor: Colors.yellow[600],
                      height: 45.h,
                      onPressed: controller.skip,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
