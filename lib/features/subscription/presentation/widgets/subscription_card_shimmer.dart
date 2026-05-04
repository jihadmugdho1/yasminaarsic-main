import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// ── Entry point ──────────────────────────────────────────────────────────────

class SubscriptionShimmer extends StatelessWidget {
  const SubscriptionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SubscriptionHeaderShimmer(),
          SizedBox(height: 12.h),
          const _CurrentPlanCardShimmer(),
          SizedBox(height: 12.h),
          const _AvailablePlansSectionShimmer(),
        ],
      ),
    );
  }
}

// ── Header (purple app bar area) ─────────────────────────────────────────────

class _SubscriptionHeaderShimmer extends StatelessWidget {
  const _SubscriptionHeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.25),
      highlightColor: Colors.white.withValues(alpha: 0.50),
      period: const Duration(milliseconds: 1600),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        decoration: const BoxDecoration(
          color: Color(0xFF6C5CE7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBox(width: 110.w, height: 14.h),
            SizedBox(height: 8.h),
            _ShimmerBox(width: 180.w, height: 11.h),
          ],
        ),
      ),
    );
  }
}

// ── Current Plan card ─────────────────────────────────────────────────────────

class _CurrentPlanCardShimmer extends StatelessWidget {
  const _CurrentPlanCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: _CardWrapper(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[50]!,
          period: const Duration(milliseconds: 1600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PlanTitleRow(),
              SizedBox(height: 4.h),
              _ShimmerBox(width: 130.w, height: 12.h),
              const _CardDivider(),
              _PlanInfoRow(hasTrailingBadge: false),
              const _RowSeparator(),
              _PlanInfoRow(hasTrailingBadge: true),
              const _RowSeparator(),
              _PlanInfoRow(hasTrailingBadge: false),
              const _CardDivider(),
              _ShimmerBox(
                width: double.infinity,
                height: 48.h,
                radius: 12.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Plan title row: "Current Plan" label + Active badge ──────────────────────

class _PlanTitleRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ShimmerBox(width: 100.w, height: 16.h),
        _ShimmerBox(width: 52.w, height: 24.h, radius: 20.r),
      ],
    );
  }
}

// ── Single info row (icon + label + date + optional trailing badge) ───────────

class _PlanInfoRow extends StatelessWidget {
  const _PlanInfoRow({required this.hasTrailingBadge});

  final bool hasTrailingBadge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          _ShimmerBox(width: 32.w, height: 32.h, radius: 8.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(width: 110.w, height: 13.h),
                SizedBox(height: 6.h),
                _ShimmerBox(width: 80.w, height: 11.h),
              ],
            ),
          ),
          if (hasTrailingBadge) ...[
            SizedBox(width: 8.w),
            _ShimmerBox(width: 72.w, height: 26.h, radius: 20.r),
          ],
        ],
      ),
    );
  }
}

// ── Available Plans section label ─────────────────────────────────────────────

class _AvailablePlansSectionShimmer extends StatelessWidget {
  const _AvailablePlansSectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        period: const Duration(milliseconds: 1600),
        child: _CardWrapper(
          child: _ShimmerBox(width: 120.w, height: 14.h),
        ),
      ),
    );
  }
}

// ── Shared layout helpers ─────────────────────────────────────────────────────

class _CardWrapper extends StatelessWidget {
  const _CardWrapper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!, width: 0.5),
      ),
      child: child,
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Divider(height: 1, color: Colors.grey[100]),
    );
  }
}

class _RowSeparator extends StatelessWidget {
  const _RowSeparator();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 44.w,
      color: Colors.grey[100],
    );
  }
}

// ── Current plan card shimmer (public) ───────────────────────────────────────

class SubscriptionCurrentPlanShimmer extends StatelessWidget {
  const SubscriptionCurrentPlanShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: _CardWrapper(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[50]!,
          period: const Duration(milliseconds: 1600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PlanTitleRow(),
              SizedBox(height: 4.h),
              _ShimmerBox(width: 130.w, height: 12.h),
              const _CardDivider(),
              _PlanInfoRow(hasTrailingBadge: false),
              const _RowSeparator(),
              _PlanInfoRow(hasTrailingBadge: true),
              const _RowSeparator(),
              _PlanInfoRow(hasTrailingBadge: false),
              const _CardDivider(),
              _ShimmerBox(width: double.infinity, height: 36.h, radius: 8.r),
            ],
          ),
        ),
      ),
    );
  }
}

// ── History section shimmer ───────────────────────────────────────────────────

class SubscriptionHistoryShimmer extends StatelessWidget {
  final int itemCount;
  const SubscriptionHistoryShimmer({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (_) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            period: const Duration(milliseconds: 1600),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey[200]!, width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(width: 20.w, height: 20.h, radius: 10.r),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBox(width: 80.w, height: 14.h),
                        SizedBox(height: 8.h),
                        _ShimmerBox(width: 160.w, height: 11.h),
                        SizedBox(height: 6.h),
                        _ShimmerBox(width: 120.w, height: 11.h),
                      ],
                    ),
                  ),
                  _ShimmerBox(width: 58.w, height: 24.h, radius: 12.r),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable shimmer placeholder ──────────────────────────────────────────────

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 6.r),
      ),
    );
  }
}