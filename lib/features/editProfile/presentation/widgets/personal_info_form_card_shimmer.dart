import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class PersonalInfoFormCardShimmer extends StatelessWidget {
  const PersonalInfoFormCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(width: 150.w, height: 16.h, color: Colors.grey),
            SizedBox(height: 24.h),
            // Fields
            ...List.generate(5, (index) => _buildFieldShimmer()),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldShimmer() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 80.w, height: 14.h, color: Colors.grey),
          SizedBox(height: 4.h),
          Row(
            children: [
              Container(width: 20.sp, height: 20.sp, color: Colors.grey),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
