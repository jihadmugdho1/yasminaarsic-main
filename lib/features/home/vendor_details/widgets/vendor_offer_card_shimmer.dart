import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class VendorOfferCardShimmer extends StatelessWidget {
  const VendorOfferCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 120.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Small image placeholder
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title placeholder
                            Container(
                              height: 13.sp,
                              width: 150.w,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 8.h),
                            // Restaurant name placeholder
                            Container(
                              height: 12.sp,
                              width: 100.w,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Description placeholder
                  Container(
                    height: 12.sp,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      // Location icon placeholder
                      Container(
                        width: 18.sp,
                        height: 18.sp,
                        color: Colors.grey[300],
                      ),
                      SizedBox(width: 5.w),
                      // Location text placeholder
                      Expanded(
                        child: Container(
                          height: 12.sp,
                          width: 80.w,
                          color: Colors.grey[300],
                        ),
                      ),
                      Spacer(),
                      // Calendar icon placeholder
                      Container(
                        width: 15.sp,
                        height: 15.sp,
                        color: Colors.grey[300],
                      ),
                      SizedBox(width: 5.w),
                      // Date placeholder
                      Expanded(
                        child: Container(
                          height: 11.sp,
                          width: 60.w,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
