import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class VendorDetailsCardShimmer extends StatelessWidget {
  const VendorDetailsCardShimmer({super.key});

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
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 63.w,
                    height: 63.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F3F8),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBar(height: 16.h, width: 150.w, radius: 10.r),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            _ShimmerBar(height: 16.h, width: 16.w, radius: 8.r),
                            SizedBox(width: 4.w),
                            _ShimmerBar(height: 12.h, width: 60.w, radius: 8.r),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _ShimmerBar(height: 14.h, width: 100.w, radius: 999.r),
              SizedBox(height: 12.h),
              _ShimmerBar(height: 12.h, width: double.infinity, radius: 8.r),
              SizedBox(height: 6.h),
              _ShimmerBar(height: 12.h, width: 0.78.sw, radius: 8.r),
              SizedBox(height: 16.h),
              Row(
                children: [
                  _ShimmerBar(height: 18.h, width: 18.w, radius: 9.r),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _ShimmerBar(
                      height: 12.h,
                      width: double.infinity,
                      radius: 8.r,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _ShimmerBar(height: 18.h, width: 18.w, radius: 9.r),
                  SizedBox(width: 8.w),
                  _ShimmerBar(height: 12.h, width: 120.w, radius: 8.r),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  _ShimmerBar(height: 18.h, width: 18.w, radius: 9.r),
                  SizedBox(width: 8.w),
                  _ShimmerBar(height: 12.h, width: 100.w, radius: 8.r),
                ],
              ),
            ],
          ),
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
