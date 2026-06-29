import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class OfferCardShimmer extends StatelessWidget {
  const OfferCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 164.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
       
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 110.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    height: 14.sp,
                    width: 120.w,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      // Location icon placeholder
                      Container(
                        height: 18.sp,
                        width: 18.sp,
                        color: Colors.grey[300],
                      ),
                      SizedBox(width: 5.w),
                      // Location text placeholder
                      Container(
                        height: 12.sp,
                        width: 80.w,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  SizedBox(height: 7.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
