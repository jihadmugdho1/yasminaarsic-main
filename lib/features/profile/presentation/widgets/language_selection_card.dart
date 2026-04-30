import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageSelectionCard extends StatelessWidget {
  final String title;
  final String selectedLanguage;
  final Function(String) onLanguageChanged;
  final Color? backgroundColor;
  final Color? titleColor;

  const LanguageSelectionCard({
    super.key,
    this.title = 'Language',
    required this.selectedLanguage,
    required this.onLanguageChanged,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          ),
          SizedBox(height: 16.h),

          // English Option
          _buildLanguageOption(
            code: 'en',
            flag: '🇬🇧',
            name: 'English',
            isSelected: selectedLanguage == 'en',
          ),

          SizedBox(height: 12.h),

          // Serbian Option
          _buildLanguageOption(
            code: 'sr',
            flag: '🇷🇸',
            name: 'Serbian',
            isSelected: selectedLanguage == 'sr',
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required String code,
    required String flag,
    required String name,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onLanguageChanged(code),
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6C63FE).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C63FE)
                : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag Icon
            Text(flag, style: TextStyle(fontSize: 24.sp)),
            SizedBox(width: 12.w),
            // Language Name
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? const Color(0xFF6C63FE) : titleColor,
                ),
              ),
            ),
            // Check Icon
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF6C63FE)),
          ],
        ),
      ),
    );
  }
}
