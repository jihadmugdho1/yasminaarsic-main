import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeaderCardShimmer extends StatelessWidget {
  const ProfileHeaderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF6C5CE7),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.r),
            bottomRight: Radius.circular(10.r),
          ),
        ),
        child: Column(
          children: [
            // Top Bar: Back + Edit
            Row(
              children: [
                const Spacer(),
                // Edit Button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(width: 18, height: 18, color: Colors.white),
                      const SizedBox(width: 8),
                      Container(width: 60.w, height: 14.h, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Avatar Circle
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Center(
                child: Container(width: 32, height: 32, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            // Name
            Container(width: 120.w, height: 16.h, color: Colors.white),
            const SizedBox(height: 4),
            // Email
            Container(width: 150.w, height: 16.h, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
