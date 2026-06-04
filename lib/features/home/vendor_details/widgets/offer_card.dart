import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/offer_model.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  final VoidCallback? onTap;

  const OfferCard({super.key, required this.offer, this.onTap});

  static const String _fallbackImage = 'assets/images/app_logo.png';

  Widget _buildImage(String imageUrl, double width, double height) {
    final isRemote =
        imageUrl.startsWith('http://') ||
        imageUrl.startsWith('https://') ||
        imageUrl.startsWith('/');

    if (imageUrl.isEmpty || !isRemote) {
      return Image.asset(
        _fallbackImage,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }

    final fullUrl = imageUrl.startsWith('/')
        ? 'https://yasminaarsic-server.onrender.com$imageUrl'
        : imageUrl;

    return Image.network(
      fullUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) => Image.asset(
        _fallbackImage,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: _buildImage(offer.imageUrl, double.infinity, 120.h),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      offer.category,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: _buildImage(offer.imageUrl, 28.w, 28.w),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              offer.title,
                              style: primaryFontStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              offer.restaurantName,
                              style: secondaryFontStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    offer.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: secondaryFontStyle(fontSize: 12.sp, lineHeight: 10),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          offer.location,
                          style: secondaryFontStyle(fontSize: 12.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.calendar_today,
                        size: 15.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          DateFormat('dd/MM/yyyy').format(offer.expiryDate),
                          style: secondaryFontStyle(fontSize: 11.sp),
                        ),
                      ),
                    ],
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
