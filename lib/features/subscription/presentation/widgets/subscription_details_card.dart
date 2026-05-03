import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/common/widgets/custom_button.dart';
import 'package:yasminaarsic/core/utils/constants/colors.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart'; 

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
    this.trailingBadgeColor = const Color(0xFFF4DB35), // Yellow
    this.startDate,
    this.renewalDate,
    this.planDescription = 'Subscription Plan for One Year',
    this.pricePerYear = r'$99.99 / year',
    this.isAutoRenewEnabled = true,
    this.autoRenewMessage =
        'Your subscription will automatically renew on {date}',
    this.updatePaymentButtonText = 'Update Payment Method',
    this.cancelSubscriptionButtonText = 'Cancel Subscription',
    this.onUpdatePaymentPressed,
    this.onCancelSubscriptionPressed,
    this.onCardTap,
    this.backgroundColor = Colors.white,
    this.titleColor = const Color(0xFF101828),
    this.subtitleColor = const Color(0xFF4A5565),
    this.badgeTextColor = Colors.black,
    this.dividerColor = Colors.grey,
    this.buttonTextColor = Colors.white,
    this.primaryButtonColor = const Color(0xFF6C5CE7), // Purple
    this.secondaryButtonColor = const Color(0xFFFFD700), // Yellow
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(20),
  });

  // ✅ Helper to format date as "Month dd, yyyy"
  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  // ✅ Helper to format date as "dd/MM/yyyy"

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
          border: Border.all(color: dividerColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Plan Title + Badge
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planTitle,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Arial',
                          color: titleColor,
                        ),
                      ),
                      if (planSubtitle.isNotEmpty)
                        Text(
                          planSubtitle,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                            color: subtitleColor,
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailingBadgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: trailingBadgeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      trailingBadgeText!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: badgeTextColor,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Subscription Info List
            _buildInfoRow(
              context: context,
              icon: Icons.calendar_today_outlined,
              label: locale.get('subscription_start'),
              value: startDate != null ? _formatDate(startDate!) : '-',
            ),
            Divider(color: dividerColor.withOpacity(0.3)),
            _buildInfoRow(
              context: context,
              icon: Icons.event_available_outlined,
              label: locale.get('renewal_date'),
              value: renewalDate != null ? _formatDate(renewalDate!) : '-',
              trailing: renewalDate != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        locale
                            .get('days_left')
                            .replaceFirst(
                              '{days}',
                              _daysLeft(renewalDate!).toString(),
                            ),
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    )
                  : null,
            ),
            Divider(color: dividerColor.withOpacity(0.3)),
            _buildInfoRow(
              context: context,
              icon: Icons.card_membership_outlined,
              label: planDescription ?? '',
              value: pricePerYear ?? '',
            ),
            Divider(color: dividerColor.withOpacity(0.3)),

            // // apply promo code
            // _buildPromoCodeInputWidget(
            //   locale: locale,
            //   labelText: locale.get('have_promo_code'),
            //   hintText: locale.get('enter_promo_code'),
            //   applyButtonText: locale.get('apply'),
            //   onApplyPressed: () {},
            // ),
            SizedBox(height: 10.h),

            Align(
              alignment: Alignment.center,
              child: CustomButton(
                text: cancelSubscriptionButtonText,
                textColor: Colors.black,
                backgroundColor: AppColors.yellow,
                type: ButtonType.outlined,
                minWidth: double.infinity,
                borderRadius: 8.r,
                height: 36.h,
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

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Arial',
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w400,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }


  int _daysLeft(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    return difference.inDays > 0 ? difference.inDays : 0;
  }
}
