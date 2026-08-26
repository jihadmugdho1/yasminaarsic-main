import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendora/features/bottom_navbar/controller/bottom_navbar_controller.dart';

class SubscribeRequiredDialog extends StatelessWidget {
  const SubscribeRequiredDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'SubscribeDialog',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const Center(
          child: Material(
            type: MaterialType.transparency,
            child: SubscribeRequiredDialog(),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FE).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              size: 36.sp,
              color: const Color(0xFF6C63FE),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Subscription Required',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
              color: const Color(0xFF101828),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please subscribe to a plan to access this offer.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[600],
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.until((route) => route.isFirst);
                Get.find<BottomNavController>().changeTab(1);
              },
              style: ElevatedButton.styleFrom(
                side: BorderSide.none,
                backgroundColor: const Color(0xFF6C63FE),
                minimumSize: Size(0, 44.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Go to Subscription',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Maybe Later',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
