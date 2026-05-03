import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class OfferDialogShimmer extends StatelessWidget {
  const OfferDialogShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 26.h),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              margin: EdgeInsets.only(top: 36.h),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image placeholder
                    Container(
                      height: 190.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 14.h),
                        // Title placeholder
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 16.sp,
                              width: 200.w,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        // Restaurant name placeholder
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 14.sp,
                              width: 150.w,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Description placeholder
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: [
                              Container(
                                height: 12.sp,
                                width: double.infinity,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                height: 12.sp,
                                width: double.infinity,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Location placeholder
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
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
                        ),
                        SizedBox(height: 5.h),
                        // Date placeholder
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
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
                        ),
                        SizedBox(height: 5.h),
                        // Value placeholder
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Container(
                                width: 18.sp,
                                height: 18.sp,
                                color: Colors.grey[300],
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                height: 12.sp,
                                width: 140.w,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // Divider placeholder
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Terms title placeholder
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 14.sp,
                              width: 150.w,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Terms content placeholder
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: [
                              Container(
                                height: 12.sp,
                                width: double.infinity,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                height: 12.sp,
                                width: double.infinity,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                height: 12.sp,
                                width: 200.w,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // Button placeholder
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            width: double.infinity,
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Close button placeholder
          // Positioned(
          //   top: 10.h,
          //   right: 10.w,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       shape: BoxShape.circle,
          //     ),
          //     child: Shimmer.fromColors(
          //       baseColor: Colors.grey[300]!,
          //       highlightColor: Colors.grey[100]!,
          //       child: Container(
          //         width: 40.w,
          //         height: 40.w,
          //         decoration: BoxDecoration(
          //           color: Colors.grey[300],
          //           shape: BoxShape.circle,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
