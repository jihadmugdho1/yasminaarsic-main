// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:vendora/core/utils/constants/colors.dart';
// import 'package:vendora/features/subscription/controller/payment_method_controller.dart';

// class UpdatePaymentMethodDialog extends StatefulWidget {
//   const UpdatePaymentMethodDialog({Key? key}) : super(key: key);

//   @override
//   State<UpdatePaymentMethodDialog> createState() =>
//       _UpdatePaymentMethodDialogState();
// }

// class _UpdatePaymentMethodDialogState extends State<UpdatePaymentMethodDialog> {
//   late PaymentController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = PaymentController();
//   }

//   @override
//   void dispose() {
//     // Intentionally not disposing controller to keep text fields alive
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
//       child: Container(
//         width: 400.w,
//         padding: EdgeInsets.all(24.w),
//         child: ListenableBuilder(
//           listenable: _controller,
//           builder: (context, _) {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Make Payment',
//                       style: TextStyle(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close, size: 18.sp),
//                       onPressed: () => Navigator.of(context).pop(),
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   'Update your payment method for your subscription.',
//                   style: TextStyle(color: Colors.grey, fontSize: 14.sp),
//                 ),
//                 SizedBox(height: 24.h),
//                 _buildTextField(
//                   label: 'Card Number',
//                   value: _controller.paymentMethod.cardNumber,
//                   onChanged: _controller.updateCardNumber,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(16),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 _buildTextField(
//                   label: 'Expiry Date',
//                   hint: 'MM/YY',
//                   value: _controller.paymentMethod.expiryDate,
//                   onChanged: _controller.updateExpiryDate,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(4),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 _buildTextField(
//                   label: 'CVV',
//                   value: _controller.paymentMethod.cvv,
//                   onChanged: _controller.updateCVV,
//                   keyboardType: TextInputType.number,
//                   obscureText: true,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(3),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 _buildTextField(
//                   label: 'Cardholder Name',
//                   value: _controller.paymentMethod.cardholderName,
//                   onChanged: _controller.updateCardholderName,
//                 ),
//                 SizedBox(height: 24.h),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed:
//                             (_controller.canSubmit && !_controller.isLoading)
//                             ? () async {
//                                 final success = await _controller
//                                     .submitPaymentMethod();
//                                 if (success && context.mounted) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: const Text(
//                                         'Payment successful!',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                       backgroundColor: Colors.green,
//                                       duration: const Duration(seconds: 3),
//                                       behavior: SnackBarBehavior.floating,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(
//                                           8.r,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                   Navigator.of(context).pop(true);
//                                 }
//                               }
//                             : () {},
//                         style: ElevatedButton.styleFrom(
//                           side: BorderSide.none,

//                           backgroundColor: AppColors.primary,
//                           foregroundColor: Colors.white,
//                           disabledBackgroundColor: AppColors.primary
//                               .withOpacity(0.5),
//                           disabledForegroundColor: Colors.white.withOpacity(
//                             0.7,
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 12.h),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                         ),
//                         child: _controller.isLoading
//                             ? SizedBox(
//                                 height: 20.h,
//                                 width: 20.w,
//                                 child: const CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                 ),
//                               )
//                             : Text(
//                                 'Make Payment',
//                                 style: TextStyle(fontSize: 14.sp),
//                               ),
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                     GestureDetector(
//                       onTap: _controller.isLoading
//                           ? null
//                           : () => Navigator.of(context).pop(),
//                       child: Container(
//                         width: 76.w,
//                         height: 36.h,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16.w,
//                           vertical: 8.h,
//                         ),
//                         decoration: ShapeDecoration(
//                           color: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             side: BorderSide(
//                               width: 1.w,
//                               color: Colors.black.withValues(alpha: 0.10),
//                             ),
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'Cancel',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 12.sp,
//                               fontFamily: 'Arial',
//                               fontWeight: FontWeight.w400,
//                               height: 1.43,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     String? hint,
//     required String value,
//     required ValueChanged<String> onChanged,
//     TextInputType? keyboardType,
//     bool obscureText = false,
//     List<TextInputFormatter>? inputFormatters,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
//         ),
//         SizedBox(height: 8.h),
//         TextFormField(
//           initialValue: value,
//           onChanged: onChanged,
//           keyboardType: keyboardType,
//           obscureText: obscureText,
//           inputFormatters: inputFormatters,
//           enabled: !_controller.isLoading,
//           decoration: InputDecoration(
//             hintText: hint,
//             filled: true,
//             fillColor: Colors.grey[100],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.r),
//               borderSide: BorderSide.none,
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.r),
//               borderSide: BorderSide.none,
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.r),
//               borderSide: BorderSide(color: AppColors.primary, width: 2.w),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.r),
//               borderSide: BorderSide.none,
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.r),
//               borderSide: BorderSide.none,
//             ),
//             disabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.r),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: EdgeInsets.symmetric(
//               horizontal: 16.w,
//               vertical: 12.h,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
