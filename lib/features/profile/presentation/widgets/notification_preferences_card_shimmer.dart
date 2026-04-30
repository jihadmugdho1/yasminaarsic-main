import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class NotificationPreferencesCardShimmer extends StatelessWidget {
  const NotificationPreferencesCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title + Icon
            Row(
              children: [
                Container(width: 20, height: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Container(width: 150.w, height: 16.h, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 24),
            // Preferences List
            ...List.generate(3, (index) => _buildPreferenceItemShimmer()),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItemShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 120.w, height: 16.h, color: Colors.grey),
                const SizedBox(height: 4),
                Container(width: 180.w, height: 14.h, color: Colors.grey),
              ],
            ),
          ),
          Container(width: 40, height: 24, color: Colors.grey),
        ],
      ),
    );
  }
}
