import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/utils/constants/icon_path.dart';

class VerificationCodeDialog extends StatefulWidget {
  final String title;
  final String description;
  final String inputLabel;
  final String submitButtonText;
  final String resetButtonText;
  final String changeEmailText;
  final Color primaryColor;
  final Color backgroundColor;
  final Color inputBackgroundColor;
  final Color buttonTextColor;
  final RxBool? loading;
  final Function(String code)? onSubmitPressed;
  final VoidCallback? onResetPressed;
  final VoidCallback onChangeEmailPressed;
  final VoidCallback onClosePressed;

  const VerificationCodeDialog({
    super.key,
    this.title = 'Email Verification',
    this.description = 'A verification code has been sent to your email.',
    this.inputLabel = 'Verification Code',
    this.submitButtonText = 'Verify',
    this.resetButtonText = 'Reset Password',
    this.changeEmailText = 'Change Email',
    this.primaryColor = const Color(0xFF6C5CE7),
    this.backgroundColor = Colors.white,
    this.inputBackgroundColor = Colors.transparent,
    this.buttonTextColor = Colors.white,
    this.loading,
    this.onSubmitPressed,
    this.onResetPressed,
    required this.onChangeEmailPressed,
    required this.onClosePressed,
  });

  @override
  State<VerificationCodeDialog> createState() => _VerificationCodeDialogState();
}

class _VerificationCodeDialogState extends State<VerificationCodeDialog> {
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    // Intentionally not disposing controller to avoid use-after-dispose errors
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87.withOpacity(0.7),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Verification Code Input Field
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: widget.inputLabel,
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                ),
                filled: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: const Color(0xFFFFD700),
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: const Color(0xFFFFD700),
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: const Color(0xFFFFD700),
                    width: 2.0,
                    style: BorderStyle.solid,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Submit/Reset Button
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: (widget.loading?.value ?? false)
                      ? null
                      : () {
                          if (codeController.text.isNotEmpty) {
                            widget.onSubmitPressed?.call(codeController.text);
                            widget.onResetPressed?.call();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide.none,
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
                        ? '${widget.onSubmitPressed != null ? widget.submitButtonText : widget.resetButtonText}..'
                        : widget.onSubmitPressed != null
                        ? widget.submitButtonText
                        : widget.resetButtonText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Change Email Button (Text Only)
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: widget.onChangeEmailPressed,
                child: Text(
                  widget.changeEmailText,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
