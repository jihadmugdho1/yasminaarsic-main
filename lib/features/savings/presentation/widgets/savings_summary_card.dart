import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavingsSummaryCard extends StatelessWidget {
  final String title;
  final double savingsAmount;
  final String description;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? amountColor;
  final Color? descriptionColor;
  final Color? iconBackgroundColor;
  final Color? iconForegroundColor;
  final IconData? icon;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const SavingsSummaryCard({
    super.key,
    this.title = 'Total Savings',
    required this.savingsAmount,
    this.description = '',
    this.backgroundColor = const Color(0xFFFFFCE6), // Light yellow as in image
    this.titleColor = const Color(0xFF000000),
    this.amountColor = const Color(0xFF707672),
    this.descriptionColor = const Color(0xFFF4DB35), // Yellow text
    this.iconBackgroundColor = const Color(0xFFFFD700), // Gold/Yellow
    this.iconForegroundColor = Colors.white,
    this.icon = Icons.balance, // Default piggy bank
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconForegroundColor, size: 24),
            ),

            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Arial',
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Amount
                  Text(
                    '\$${savingsAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Arial',
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Description
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: descriptionColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Arial',
                      ),
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
