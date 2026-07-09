import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendora/core/localization/localization_controller.dart';

class ProfileDetailsCard extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phone;
  final String? location;
  final String? birthDate;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? labelColor;
  final Color? iconColor;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onNameTap;
  final VoidCallback? onEmailTap;
  final VoidCallback? onPhoneTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onBirthDateTap;
  final VoidCallback? onTap;

  const ProfileDetailsCard({
    super.key,
    this.name,
    this.email,
    this.phone,
    this.location,
    this.birthDate,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.labelColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(20),
    this.onNameTap,
    this.onEmailTap,
    this.onPhoneTap,
    this.onLocationTap,
    this.onBirthDateTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            if (name != null)
              Obx(
                () => _buildField(
                  icon: Icons.person_outline,
                  label: locale.get('name'),
                  value: name!,
                  onTap: onNameTap,
                ),
              ),

            // Email
            if (email != null)
              Obx(
                () => _buildField(
                  icon: Icons.email_outlined,
                  label: locale.get('email'),
                  value: email!,
                  onTap: onEmailTap,
                ),
              ),

            // Phone
            if (phone != null)
              Obx(
                () => _buildField(
                  icon: Icons.phone_outlined,
                  label: locale.get('phone'),
                  value: phone!,
                  onTap: onPhoneTap,
                ),
              ),

            // Location
            if (location != null)
              Obx(
                () => _buildField(
                  icon: Icons.location_on_outlined,
                  label: locale.get('location'),
                  value: location!,
                  onTap: onLocationTap,
                ),
              ),

            // Birth Date
            if (birthDate != null)
              Obx(
                () => _buildField(
                  icon: Icons.calendar_today_outlined,
                  label: locale.get('birth_date'),
                  value: birthDate!,
                  onTap: onBirthDateTap,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(value, style: TextStyle(fontSize: 16, color: textColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
