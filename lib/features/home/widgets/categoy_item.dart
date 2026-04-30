import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yasminaarsic/core/core.dart';

class CategoryGridItem extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryGridItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

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
        splashColor: AppColors.primary.withOpacity(0.2),
        highlightColor: AppColors.primary.withOpacity(0.1),
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
        height: widget.height,
        width: widget.width,
        color: widget.color,
      );
    }

    return Image.network(
      widget.imageUrl,
      height: widget.height,
      width: widget.width,
      color: widget.color,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          // Image loaded successfully
          return child;
        }
        // Still loading, show nothing or a placeholder
        return SizedBox(height: widget.height, width: widget.width);
      },
      errorBuilder: (context, error, stackTrace) {
        // Show fallback on error
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
