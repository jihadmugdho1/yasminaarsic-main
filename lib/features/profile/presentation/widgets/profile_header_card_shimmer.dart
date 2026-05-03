// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeaderCardShimmer extends StatelessWidget {
  const ProfileHeaderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 28.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF8B7CF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.25),
        highlightColor: Colors.white.withOpacity(0.55),
        period: const Duration(milliseconds: 1500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TopBar(),
            SizedBox(height: 28.h),
            _AvatarSection(),
            SizedBox(height: 24.h),
            _StatsRow(),
          ],
        ),
      ),
    );
  }
}

// ── Top bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ShimmerBox(width: 18.w, height: 18.h, radius: 4.r),
              SizedBox(width: 8.w),
              _ShimmerBox(width: 52.w, height: 13.h),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Avatar + name + email ────────────────────────────────────────────────────

class _AvatarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.15),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 3.5,
            ),
          ),
          child: Center(
            child: _ShimmerBox(
              width: 36.w,
              height: 36.w,
              radius: 36.r, // circle icon placeholder
            ),
          ),
        ),
        SizedBox(height: 14.h),
        _ShimmerBox(width: 130.w, height: 15.h),
        SizedBox(height: 8.h),
        _ShimmerBox(width: 160.w, height: 13.h),
      ],
    );
  }
}

// ── Stat counters row ────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatItem(),
        _Divider(),
        _StatItem(),
        _Divider(),
        _StatItem(),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          _ShimmerBox(width: 36.w, height: 18.h),
          SizedBox(height: 6.h),
          _ShimmerBox(width: 52.w, height: 11.h),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28.h,
      color: Colors.white.withOpacity(0.2),
    );
  }
}

// ── Reusable shimmer placeholder block ──────────────────────────────────────

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius,
  });

  final double width;
  final double height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // shimmer colours override this
        borderRadius: BorderRadius.circular(radius ?? 6.r),
      ),
    );
  }
}