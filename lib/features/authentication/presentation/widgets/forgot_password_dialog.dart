import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String title;
  final String emailLabel;
  final String resetButtonText;
  final Color primaryColor;
  final Color backgroundColor;
  final Color inputBackgroundColor;
  final Color buttonTextColor;
  final RxBool? loading;
  final Function(String email) onResetPressed;
  final VoidCallback onClosePressed;

  const ForgotPasswordDialog({
    super.key,
    this.title = 'Forgot Password.',
    this.emailLabel = 'Email or Mobile Number',
    this.resetButtonText = 'Reset Password',
    this.primaryColor = const Color(0xFF6C5CE7),
    this.backgroundColor = Colors.white,
    this.inputBackgroundColor = const Color(0xFFF5F5F5),
    this.buttonTextColor = Colors.white,
    this.loading,
    required this.onResetPressed,
    required this.onClosePressed,
  });

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late LocalizationController locale;

  @override
  void initState() {
    super.initState();
    locale = Get.find<LocalizationController>();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return locale.get('email_required');
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return locale.get('valid_email');
    }
    return null;
  }

  void _onResetPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onResetPressed(_emailController.text);
    }
  }

  @override
  void dispose() {
    // Intentionally not disposing controller to avoid use-after-dispose errors
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button (Top Right)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: widget.onClosePressed,
                  child: SvgPicture.asset(IconPath.crossIcon),
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Align(
                alignment: Alignment.center,
                child: Obx(() {
                  locale.currentLanguage.value;
                  return Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Email Label
              Obx(() {
                locale.currentLanguage.value;
                return Text(
                  widget.emailLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                );
              }),
              const SizedBox(height: 8),

              // Email Input Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
                decoration: InputDecoration(
                  hintText: locale.get('example_email'),
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red, width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red, width: 1.5),
                  ),
                  errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              ),
              const SizedBox(height: 32),

              // Reset Password Button
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  locale.currentLanguage.value;
                  return ElevatedButton(
                    onPressed: (widget.loading?.value ?? false)
                        ? null
                        : _onResetPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (widget.loading?.value ?? false)
                          ? Colors.grey
                          : widget.primaryColor,
                      foregroundColor: widget.buttonTextColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      (widget.loading?.value ?? false)
                          ? '${widget.resetButtonText}..'
                          : widget.resetButtonText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
