import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class LanguageSelectionCardShimmer extends StatelessWidget {
  const LanguageSelectionCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(width: 100.w, height: 16.h, color: Colors.grey),
            SizedBox(height: 16.h),
            // English Option
            _buildLanguageOptionShimmer(),
            SizedBox(height: 12.h),
            // Serbian Option
            _buildLanguageOptionShimmer(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOptionShimmer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          // Flag Placeholder
          Container(width: 24.sp, height: 24.sp, color: Colors.grey),
          SizedBox(width: 12.w),
          // Language Name
          Expanded(
            child: Container(width: 80.w, height: 14.h, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
