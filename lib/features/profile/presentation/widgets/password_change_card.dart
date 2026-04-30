import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/common/widgets/custom_button.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/routes/app_routes.dart';

class PasswordChangeCard extends StatelessWidget {
  final String title;
  final String buttonText;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final IconData? icon;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onPressed;
  final VoidCallback? onTap;

  const PasswordChangeCard({
    super.key,
    this.title = 'Password',
    this.buttonText = 'Change Password',
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black87,
    this.buttonColor = const Color(0xFFFFD700), // Yellow
    this.buttonTextColor = Colors.black,
    this.icon = Icons.lock_outlined,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(20),
    this.onPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 16),

            // Change Password Button
            Align(
              alignment: Alignment.center,
              child: CustomButton(
                text: locale.get('change_password'),
                textColor: Colors.black,
                backgroundColor: AppColors.yellow,
                leadingIcon: SvgPicture.asset(IconPath.lockIcon),
                type: ButtonType.outlined,
                minWidth: double.infinity,
                borderRadius: 8.r,
                height: 36.h,
                onPressed: () {
                  Get.toNamed(AppRoute.setPasswordScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
