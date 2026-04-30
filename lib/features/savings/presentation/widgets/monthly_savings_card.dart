import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlySavingsCard extends StatelessWidget {
  final String title;
  final double amount;
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

  const MonthlySavingsCard({
    super.key,
    this.title = 'This Month',
    required this.amount,
    this.description = '',
    this.backgroundColor = const Color(0xFFF0F5FF), // Light blue as in image
    this.titleColor =const Color(0xFF1C398E),
    this.amountColor =const Color(0xFF1C398E),
    this.descriptionColor = const Color(0xFF6C63FE), // Purple-blue text
    this.iconBackgroundColor = const Color(0xFF6C5CE7), // Dark purple
    this.iconForegroundColor = Colors.white,
    this.icon = Icons.trending_up, // Default upward arrow
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
          border: Border.all(
            color: Color(0xFFBEDBFF)
          ),
        ),
        child: Row(
          children: [
            // Icon Circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconForegroundColor,
                size: 24,
              ),
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
                    '\$${amount.toStringAsFixed(2)}',
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
                        fontFamily: 'Arial',
                        color: descriptionColor,
                        fontWeight: FontWeight.w400,
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