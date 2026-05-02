import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yasminaarsic/core/core.dart';

class CategoryGridItem extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryGridItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedIcon = (icon).trim().isEmpty ? IconPath.offerIcon : icon;

    Widget iconWidget;
    if (resolvedIcon.startsWith('http') || resolvedIcon.startsWith('https')) {
      // Absolute network image with timeout
      iconWidget = _NetworkImageWithTimeout(
        imageUrl: resolvedIcon,
        height: 28.sp,
        width: 28.sp,
        color: isSelected ? Colors.white : AppColors.primary,
        timeoutSeconds: 5,
        fallbackImage: IconPath.offerIcon,
      );
    } else if (resolvedIcon.startsWith('/')) {
      // Relative URL, prepend server URL
      final serverUrl = ApiConstants.baseUrl.replaceAll('/api/v1/', '');
      iconWidget = _NetworkImageWithTimeout(
        imageUrl: '$serverUrl$resolvedIcon',
        height: 28.sp,
        width: 28.sp,
        color: isSelected ? Colors.white : AppColors.primary,
        timeoutSeconds: 5,
        fallbackImage: IconPath.offerIcon,
      );
    } else if (resolvedIcon.length == 1 || resolvedIcon.contains('🏪')) {
      // Emoji
      iconWidget = Text(
        resolvedIcon,
        style: TextStyle(
          fontSize: 28.sp,
          color: isSelected ? Colors.white : AppColors.primary,
        ),
      );
    } else {
      // Asset image
      iconWidget = Image.asset(
        resolvedIcon,
        height: 28.sp,
        width: 28.sp,
        color: isSelected ? Colors.white : AppColors.primary,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            IconPath.offerIcon,
            height: 28.sp,
            width: 28.sp,
            color: isSelected ? Colors.white : AppColors.primary,
          );
        },
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isSelected ? AppColors.primary : Colors.white,
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.0)
                  : Colors.grey.withOpacity(0.22),
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.10),
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.yellow.withOpacity(0.20),
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                iconWidget,
                SizedBox(height: 8.h),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NetworkImageWithTimeout extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double width;
  final Color? color;
  final int timeoutSeconds;
  final String fallbackImage;

  const _NetworkImageWithTimeout({
    Key? key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.color,
    required this.timeoutSeconds,
    required this.fallbackImage,
  }) : super(key: key);

  @override
  _NetworkImageWithTimeoutState createState() =>
      _NetworkImageWithTimeoutState();
}

class _NetworkImageWithTimeoutState extends State<_NetworkImageWithTimeout> {
  bool _showFallback = false;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: widget.timeoutSeconds), () {
      if (mounted && !_showFallback && !_imageLoaded) {
        setState(() {
          _showFallback = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showFallback) {
      return Image.asset(
        widget.fallbackImage,
        height: widget.height,
        width: widget.width,
        color: widget.color,
      );
    }

    return Image.network(
      widget.imageUrl,
      height: widget.height,
      width: widget.width,
      // No color tint — real S3 photos should not be color-filtered
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          _imageLoaded = true;
          return child;
        }
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          widget.fallbackImage,
          height: widget.height,
          width: widget.width,
          color: widget.color,
        );
      },
    );
  }
}
