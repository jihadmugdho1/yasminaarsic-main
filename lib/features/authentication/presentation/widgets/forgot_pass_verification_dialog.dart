import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';

class ForgotPassVerificationDialog extends StatefulWidget {
  final String title;
  final String description;
  final String codeLabel;
  final String verifyButtonText;
  final String resendButtonText;
  final Color primaryColor;
  final Color backgroundColor;
  final Color inputBackgroundColor;
  final Color buttonTextColor;
  final RxBool? loading;
  final Function(String code) onVerifyPressed;
  final VoidCallback? onResendPressed;
  final VoidCallback onClosePressed;

  const ForgotPassVerificationDialog({
    super.key,
    this.title = 'Verify Code',
    this.description = 'Enter the verification code sent to your email',
    this.codeLabel = 'Verification Code',
    this.verifyButtonText = 'Verify Code',
    this.resendButtonText = 'Resend Code',
    this.primaryColor = const Color(0xFF6C5CE7),
    this.backgroundColor = Colors.white,
    this.inputBackgroundColor = const Color(0xFFF5F5F5),
    this.buttonTextColor = Colors.white,
    this.loading,
    required this.onVerifyPressed,
    this.onResendPressed,
    required this.onClosePressed,
  });

  @override
  State<ForgotPassVerificationDialog> createState() =>
      _ForgotPassVerificationDialogState();
}

class _ForgotPassVerificationDialogState
    extends State<ForgotPassVerificationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  late LocalizationController locale;

  @override
  void initState() {
    super.initState();
    locale = Get.find<LocalizationController>();
  }

  String? validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Verification code is required';
    }
    if (value.length != 6) {
      return 'Please enter a valid 6-digit code';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Code must contain only numbers';
    }
    return null;
  }

  void _onVerifyPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onVerifyPressed(_codeController.text);
    }
  }

  @override
  void dispose() {
    // Intentionally not disposing the controller to avoid use-after-dispose errors
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
              const SizedBox(height: 8),

              // Description
              Align(
                alignment: Alignment.center,
                child: Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // Code Label
              Obx(() {
                locale.currentLanguage.value;
                return Text(
                  widget.codeLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                );
              }),
              const SizedBox(height: 8),

              // Verification Code Input Field
              TextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                validator: validateCode,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: '000000',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18.sp,
                    fontFamily: 'Inter',
                    letterSpacing: 8,
                  ),
                  filled: true,
                  fillColor: widget.inputBackgroundColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
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
                    borderSide: BorderSide(
                      color: widget.primaryColor,
                      width: 2.0,
                    ),
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
                  counterText: '', // Hide character counter
                ),
              ),
              const SizedBox(height: 32),

              // Verify Code Button
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  locale.currentLanguage.value;
                  return ElevatedButton(
                    onPressed: (widget.loading?.value ?? false)
                        ? null
                        : _onVerifyPressed,
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
                          ? '${widget.verifyButtonText}..'
                          : widget.verifyButtonText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Resend Code Button
              // if (widget.onResendPressed != null)
              //   Align(
              //     alignment: Alignment.center,
              //     child: TextButton(
              //       onPressed: widget.onResendPressed,
              //       child: Obx(() {
              //         locale.currentLanguage.value;
              //         return Text(
              //           widget.resendButtonText,
              //           style: TextStyle(
              //             color: widget.primaryColor,
              //             fontSize: 14,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         );
              //       }),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
