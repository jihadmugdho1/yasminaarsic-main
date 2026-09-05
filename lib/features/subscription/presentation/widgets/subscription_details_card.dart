import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:vendora/core/common/widgets/custom_button.dart';
import 'package:vendora/core/utils/constants/colors.dart';
import 'package:vendora/core/localization/localization_controller.dart';

class SubscriptionDetailsCard extends StatelessWidget {
  final String planTitle;
  final String planSubtitle;
  final String? trailingBadgeText;
  final Color? trailingBadgeColor;
  final DateTime? startDate;
  final DateTime? renewalDate;
  final String? planDescription;
  final String? pricePerYear;
  final bool isAutoRenewEnabled;
  final String? autoRenewMessage;
  final String updatePaymentButtonText;
  final String cancelSubscriptionButtonText;
  final bool showCancelButton;
  final VoidCallback? onUpdatePaymentPressed;
  final VoidCallback? onCancelSubscriptionPressed;
  final VoidCallback? onCardTap;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color badgeTextColor;
  final Color dividerColor;
  final Color buttonTextColor;
  final Color primaryButtonColor;
  final Color secondaryButtonColor;
  final double borderRadius;
  final EdgeInsets padding;

  const SubscriptionDetailsCard({
    super.key,
    this.planTitle = 'Current Plan',
    this.planSubtitle = 'Annual Subscription',
    this.trailingBadgeText = 'Active',
    this.trailingBadgeColor,
    this.startDate,
    this.renewalDate,
    this.planDescription = 'Subscription Plan for One Year',
    this.pricePerYear = r'$99.99 / year',
    this.isAutoRenewEnabled = true,
    this.autoRenewMessage =
        'Your subscription will automatically renew on {date}',
    this.updatePaymentButtonText = 'Update Payment Method',
    this.cancelSubscriptionButtonText = 'Cancel Subscription',
    this.showCancelButton = true,
    this.onUpdatePaymentPressed,
    this.onCancelSubscriptionPressed,
    this.onCardTap,
    this.backgroundColor = Colors.white,
    this.titleColor = const Color(0xFF101828),
    this.subtitleColor = const Color(0xFF4A5565),
    this.badgeTextColor = Colors.white,
    this.dividerColor = Colors.grey,
    this.buttonTextColor = Colors.white,
    this.primaryButtonColor = const Color(0xFF6C5CE7), // Purple
    this.secondaryButtonColor = AppColors.blueColor, // Yellow
    this.borderRadius = 18.0,
    this.padding = const EdgeInsets.all(20),
  });

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: dividerColor.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon chip + Title/Subtitle + Status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 44.h,
                  width: 44.h,
                  padding: EdgeInsets.all(8.r),

                  child: Image.asset(
                    "assets/icons/image.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        planTitle,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Arial',
                          color: titleColor,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (planSubtitle.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          planSubtitle,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailingBadgeText != null) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: _badgeBgColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          trailingBadgeText!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: _badgeTextColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 22.h),

            // Subscription Info List
            _buildInfoRow(
              icon: Icons.calendar_today_outlined,
              label: locale.get('subscription_start'),
              value: startDate != null ? _formatDate(startDate!) : '-',
            ),
            _buildDivider(),
            _buildInfoRow(
              icon: Icons.event_available_outlined,
              label: locale.get('renewal_date'),
              value: renewalDate != null ? _formatDate(renewalDate!) : '-',
              trailing: renewalDate != null
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: primaryButtonColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        locale
                            .get('days_left')
                            .replaceFirst(
                              '{days}',
                              _daysLeft(renewalDate!).toString(),
                            ),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: primaryButtonColor,
                        ),
                      ),
                    )
                  : null,
            ),
            _buildDivider(),
            _buildInfoRow(
              icon: Icons.card_membership_outlined,
              label: planDescription ?? '',
              value: pricePerYear ?? '',
              emphasizeValue: true,
            ),
            SizedBox(height: 20.h),

            if (showCancelButton)
              Align(
                alignment: Alignment.center,
                child: CustomButton(
                  text: cancelSubscriptionButtonText,
                  textColor: Colors.black,
                  backgroundColor: AppColors.yellow,
                  type: ButtonType.outlined,
                  minWidth: double.infinity,
                  borderRadius: 10.r,
                  height: 44.h,
                  onPressed: () {
                    if (onCancelSubscriptionPressed != null) {
                      onCancelSubscriptionPressed!();
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: CustomPaint(
        size: const Size(double.infinity, 1),
        painter: DottedLinePainter(
          color: dividerColor.withValues(alpha: 0.25),
          dashWidth: 4.0,
          dashSpace: 4.0,
          strokeWidth: 1.0,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
    bool emphasizeValue = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 25.h,
            width: 25.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: subtitleColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 17.sp, color: subtitleColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Arial',
                    color: subtitleColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: emphasizeValue ? 14.sp : 12.sp,
                    fontFamily: 'Arial',
                    fontWeight: emphasizeValue
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: titleColor,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[SizedBox(width: 8.w), trailing],
        ],
      ),
    );
  }

  Color get _badgeBgColor {
    final text = trailingBadgeText?.toLowerCase().trim();
    if (text == 'active') {
      return trailingBadgeColor ?? const Color(0xFF17A34A); // Green for active
    } else if (text == 'available') {
      return trailingBadgeColor ??
          const Color(0xFFFFD700); // Gold/Yellow for available
    } else if (text == 'inactive' || text == 'expired') {
      return trailingBadgeColor ?? Colors.grey;
    }
    return trailingBadgeColor ?? const Color(0xFF17A34A);
  }

  Color get _badgeTextColor {
    final text = trailingBadgeText?.toLowerCase().trim();
    if (text == 'active') {
      return Colors.white;
    } else if (text == 'available') {
      return Colors.black87;
    } else if (text == 'inactive' || text == 'expired') {
      return Colors.white;
    }
    return badgeTextColor;
  }

  int _daysLeft(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    return difference.inDays > 0 ? difference.inDays : 0;
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  const DottedLinePainter({
    required this.color,
    this.dashWidth = 4.0,
    this.dashSpace = 4.0,
    this.strokeWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset((startX + dashWidth).clamp(0, size.width), size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DottedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
