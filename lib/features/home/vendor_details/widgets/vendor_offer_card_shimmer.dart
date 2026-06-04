import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class VendorOfferCardShimmer extends StatelessWidget {
  const VendorOfferCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFF0F3F8),
      highlightColor: const Color(0xFFFFFFFF),
      period: const Duration(milliseconds: 1400),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFE6ECF4)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF101828).withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F3F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F3F8),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ShimmerBar(
                              height: 13.h,
                              width: 150.w,
                              radius: 8.r,
                            ),
                            SizedBox(height: 8.h),
                            _ShimmerBar(
                              height: 12.h,
                              width: 100.w,
                              radius: 8.r,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  _ShimmerBar(
                    height: 12.h,
                    width: double.infinity,
                    radius: 8.r,
                  ),
                  SizedBox(height: 6.h),
                  _ShimmerBar(height: 12.h, width: 0.7.sw, radius: 8.r),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      _ShimmerBar(height: 18.h, width: 18.w, radius: 9.r),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: _ShimmerBar(
                          height: 12.h,
                          width: double.infinity,
                          radius: 8.r,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Calendar icon placeholder
                      _ShimmerBar(height: 15.h, width: 15.w, radius: 8.r),
                      SizedBox(width: 5.w),
                      _ShimmerBar(height: 11.h, width: 60.w, radius: 8.r),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _ShimmerBar(height: 26.h, width: 80.w, radius: 999.r),
                      const Spacer(),
                      _ShimmerBar(height: 10.h, width: 44.w, radius: 999.r),
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
