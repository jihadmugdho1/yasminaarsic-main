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
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF101828).withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              margin: EdgeInsets.only(top: 36.h),
              child: Shimmer.fromColors(
                baseColor: const Color(0xFFF0F3F8),
                highlightColor: const Color(0xFFFFFFFF),
                period: const Duration(milliseconds: 1400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 190.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F3F8),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22.r),
                          topRight: Radius.circular(22.r),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 14.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _ShimmerBar(
                              height: 16.h,
                              width: 200.w,
                              radius: 10.r,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _ShimmerBar(
                              height: 14.h,
                              width: 150.w,
                              radius: 10.r,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: [
                              _ShimmerBar(
                                height: 12.h,
                                width: double.infinity,
                                radius: 8.r,
                              ),
                              SizedBox(height: 4.h),
                              _ShimmerBar(
                                height: 12.h,
                                width: double.infinity,
                                radius: 8.r,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              _ShimmerBar(
                                height: 18.h,
                                width: 18.w,
                                radius: 9.r,
                              ),
                              SizedBox(width: 8.w),
                              _ShimmerBar(
                                height: 12.h,
                                width: 120.w,
                                radius: 8.r,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              _ShimmerBar(
                                height: 18.h,
                                width: 18.w,
                                radius: 9.r,
                              ),
                              SizedBox(width: 8.w),
                              _ShimmerBar(
                                height: 12.h,
                                width: 100.w,
                                radius: 8.r,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              _ShimmerBar(
                                height: 18.h,
                                width: 18.w,
                                radius: 9.r,
                              ),
                              SizedBox(width: 8.w),
                              _ShimmerBar(
                                height: 12.h,
                                width: 140.w,
                                radius: 8.r,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: _ShimmerBar(
                            height: 1.2.h,
                            width: double.infinity,
                            radius: 999.r,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _ShimmerBar(
                              height: 14.h,
                              width: 150.w,
                              radius: 8.r,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: [
                              _ShimmerBar(
                                height: 12.h,
                                width: double.infinity,
                                radius: 8.r,
                              ),
                              SizedBox(height: 4.h),
                              _ShimmerBar(
                                height: 12.h,
                                width: double.infinity,
                                radius: 8.r,
                              ),
                              SizedBox(height: 4.h),
                              _ShimmerBar(
                                height: 12.h,
                                width: 200.w,
                                radius: 8.r,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            width: double.infinity,
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F3F8),
                              borderRadius: BorderRadius.circular(14.r),
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
        ],
      ),
    );
  }
}

class _ShimmerBar extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const _ShimmerBar({
    required this.height,
    required this.width,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F8),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
