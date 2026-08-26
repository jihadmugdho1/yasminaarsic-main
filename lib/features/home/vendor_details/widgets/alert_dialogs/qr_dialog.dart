import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vendora/core/core.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/features/home/vendor_details/models/alert_dialogs/qr_dialog_model.dart';

class QrRedemptionAlertDialog extends StatelessWidget {
  final QrOffer qrOffer;
  final VoidCallback? onClose;

  const QrRedemptionAlertDialog({
    super.key,
    required this.qrOffer,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 26.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Padding(
              padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
              child: Obx(
                () => Text(
                  locale.get('qr_code_title'),
                  style: primaryFontStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4C25C7),
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // QR Code - Hide if one-time offer is redeemed
            if (!(qrOffer.isRedeemed && !qrOffer.isReuseable))
              Container(
                width: 180.w,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFB2A8F5), width: 1.2),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                ),
                padding: const EdgeInsets.all(20),
                child: Opacity(
                  opacity: qrOffer.isRedeemed ? 0.3 : 1.0,
                  child: QrImageView(
                    data: qrOffer.qrCode,
                    version: QrVersions.auto,
                    size: 120.h,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            SizedBox(height: 12.h),
            // Details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          qrOffer.title,
                          style: primaryFontStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      // Show Reusable QR badge only for reuseable offers
                      if (qrOffer.isReuseable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: ShapeDecoration(
                            // color: const Color(0xFF6C63FE),
                            color: AppColors.success,
                            shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Obx(
                            () => Text(
                              locale.get('qr_reusable_badge'),
                              style: secondaryFontStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  if (qrOffer.description != null &&
                      qrOffer.description!.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Text(
                      qrOffer.description!,
                      style: secondaryFontStyle(
                        fontSize: 11.sp,
                        color: Colors.black54,
                        lineHeight: 9,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18.sp,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          qrOffer.location,
                          style: secondaryFontStyle(
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18.sp,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8.w),
                      Obx(
                        () => Text(
                          '${locale.get('qr_valid_until')} ${qrOffer.validUntil}',
                          style: secondaryFontStyle(
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.w),
            //   child: Divider(),
            // ),
            // Status Banner
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.yellowAccent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFF6E6B7), width: 1.5),
                ),
                child: Row(
                  children: [
                    Icon(
                      qrOffer.isRedeemed
                          ? Icons.check_circle
                          : Icons.qr_code_scanner,
                      color: Color(0xFFFBD105),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Obx(
                        () => Text(
                          qrOffer.isRedeemed
                              ? locale.get('qr_redeemed_message')
                              : locale.get('qr_show_at_vendor'),
                          style: secondaryFontStyle(
                            fontSize: 11.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // Buttons
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    side: BorderSide.none,
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    elevation: 0,
                  ),
                  child: Obx(
                    () => Text(
                      locale.get('qr_close_button'),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
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
