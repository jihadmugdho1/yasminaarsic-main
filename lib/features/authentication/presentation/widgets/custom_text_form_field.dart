import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final int? maxLength;
  final int? maxLines;
  final bool enabled;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final double borderRadius;
  final VoidCallback? onSuffixTap;

  // SVG support (optional)
  final Widget? suffixSvg;
  final String? suffixSvgPath;
  final double suffixIconSize;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.controller,
    this.focusNode,
    this.textStyle,
    this.hintStyle,
    this.fillColor = const Color(0xFFDFE3E8), // Light gray fill as in image
    this.borderRadius = 8.0,
    this.suffixSvg,
    this.suffixSvgPath,
    this.suffixIconSize = 24.0,
    this.onSuffixTap,
  });

  Widget? _buildSuffix() {
    if (suffixSvg != null) {
      return SizedBox(
        width: suffixIconSize,
        height: suffixIconSize,
        child: suffixSvg!,
      );
    }
    if (suffixSvgPath != null) {
      return SizedBox(
        width: suffixIconSize,
        height: suffixIconSize,
        child: SvgPicture.asset(suffixSvgPath!, fit: BoxFit.scaleDown),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget? suffix = _buildSuffix();

    // Wrap suffix with InkWell if tap handler is provided
    if (suffix != null && onSuffixTap != null) {
      suffix = InkWell(onTap: onSuffixTap, child: suffix);
    }

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textAlign: textAlign,
      maxLength: maxLength,
      maxLines: maxLines,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      style: textStyle,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none, // ✅ No border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none, // ✅ No border when focused
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none, // ✅ No border when enabled
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ), // ✅ Red border on error
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ), // ✅ Red border on focused error
        ),
        suffixIcon: suffix,
      ),
    );
  }
}
