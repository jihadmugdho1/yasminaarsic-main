import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class VendorDetailsCardShimmer extends StatelessWidget {
  const VendorDetailsCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        color: Colors.white,
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Vendor image placeholder
                  Container(
                    width: 63.w,
                    height: 63.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vendor name placeholder
                        Container(
                          height: 16.sp,
                          width: 150.w,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 8.h),
                        // Rating placeholder
                        Row(
                          children: [
                            Container(
                              width: 16.sp,
                              height: 16.sp,
                              color: Colors.grey[300],
                            ),
                            SizedBox(width: 4.w),
                            Container(
                              height: 12.sp,
                              width: 60.w,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Category/Type placeholder
              Container(height: 14.sp, width: 100.w, color: Colors.grey[300]),
              SizedBox(height: 12.h),
              // Description placeholder
              Container(
                height: 12.sp,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              SizedBox(height: 6.h),
              Container(
                height: 12.sp,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              SizedBox(height: 16.h),
              // Location/Address placeholder
              Row(
                children: [
                  Container(
                    width: 18.sp,
                    height: 18.sp,
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Container(height: 12.sp, color: Colors.grey[300]),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Phone placeholder
              Row(
                children: [
                  Container(
                    width: 18.sp,
                    height: 18.sp,
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    height: 12.sp,
                    width: 120.w,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Opening hours placeholder
              Row(
                children: [
                  Container(
                    width: 18.sp,
                    height: 18.sp,
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    height: 12.sp,
                    width: 100.w,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
