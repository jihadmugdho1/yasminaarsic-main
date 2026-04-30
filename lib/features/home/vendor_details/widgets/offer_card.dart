import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/offer_model.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  final VoidCallback? onTap;

  const OfferCard({Key? key, required this.offer, this.onTap})
    : super(key: key);

  /// Check if image URL is a remote URL or local asset
  bool _isRemoteUrl(String url) {
    return url.startsWith('http://') ||
        url.startsWith('https://') ||
        url.startsWith('/uploads/');
  }

  /// Build image widget based on URL type
  Widget _buildImage(String imageUrl, double width, double height) {
    if (_isRemoteUrl(imageUrl)) {
      final fullUrl = imageUrl.startsWith('/')
          ? 'https://yasminaarsic-server.onrender.com$imageUrl'
          : imageUrl;

      return _NetworkImageWithTimeout(
        imageUrl: fullUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        timeoutSeconds: 5,
        fallbackImage: 'assets/images/app_logo.png',
      );
    } else {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // ✅ Show "Redeemed" badge if offer is redeemed
                if (offer.isRedeemed)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'REDEEMED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
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

class _NetworkImageWithTimeout extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final int timeoutSeconds;
  final String fallbackImage;

  const _NetworkImageWithTimeout({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.fit,
    required this.timeoutSeconds,
    required this.fallbackImage,
  }) : super(key: key);

  @override
  _NetworkImageWithTimeoutState createState() =>
      _NetworkImageWithTimeoutState();
}

class _NetworkImageWithTimeoutState extends State<_NetworkImageWithTimeout> {
  bool _showFallback = false;

  @override
  void initState() {
    super.initState();
    // Start a timer to show fallback after timeout
    Future.delayed(Duration(seconds: widget.timeoutSeconds), () {
      if (mounted && !_showFallback) {
        setState(() {
          _showFallback = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showFallback) {
      // Show fallback image after timeout
      return Image.asset(
        widget.fallbackImage,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    return Image.network(
      widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          // Image loaded successfully
          return child;
        }
        // Show loading indicator while loading
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Show fallback on error
        return Image.asset(
          widget.fallbackImage,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      },
    );
  }
}
