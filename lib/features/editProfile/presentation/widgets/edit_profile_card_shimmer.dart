import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class EditProfileCardShimmer extends StatelessWidget {
  const EditProfileCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: const Color(0xFF6C63FE),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.r),
            bottomRight: Radius.circular(10.r),
          ),
        ),
        child: Column(
          children: [
            // Top Bar: Cancel and Save Buttons at Right Top
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 18.sp,
                        height: 18.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.w),
                      Container(width: 50.w, height: 14.h, color: Colors.white),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 18.sp,
                        height: 18.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Container(width: 70.w, height: 14.h, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Avatar Circle + Camera Icon (Centered)
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.w),
                  ),
                  child: Center(
                    child: Container(
                      width: 40.sp,
                      height: 40.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1.w),
                  ),
                  child: Container(
                    width: 16.sp,
                    height: 16.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Name Display
            Container(width: 120.w, height: 20.h, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
