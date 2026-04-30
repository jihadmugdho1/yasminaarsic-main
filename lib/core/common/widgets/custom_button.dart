import 'package:flutter/material.dart';

enum ButtonType { filled, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? textColor;
  final Color? disabledTextColor;

  final Color? borderColor;

  final double? borderRadius;
  final double? minWidth;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool loading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final TextStyle? textStyle;
  final double? elevation;
  final bool expand;
  final List<Color>? gradient;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.filled,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.textColor,
    this.disabledTextColor,
    this.borderColor,
    this.borderRadius,
    this.minWidth,
    this.height = 50,
    this.padding,
    this.loading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.textStyle,
    this.elevation,
    this.expand = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !loading;
    final double resolvedBorderRadius = borderRadius ?? 8.0;
    final EdgeInsetsGeometry resolvedPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 20);

    Color textCol = isEnabled
        ? textColor ??
              (type == ButtonType.text
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white)
        : disabledTextColor ??
              Theme.of(context).disabledColor.withOpacity(0.38);

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null && !loading) leadingIcon!,
        if (leadingIcon != null && !loading) const SizedBox(width: 8),
        Text(
          loading ? '$text..' : text,
          style:
              textStyle ??
              TextStyle(
                color: loading ? Colors.grey : textCol,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
        ),
        if (trailingIcon != null && !loading) const SizedBox(width: 8),
        if (trailingIcon != null && !loading) trailingIcon!,
      ],
    );

    child = Padding(padding: resolvedPadding, child: child);

    // If gradient is provided and enabled, use custom container
    if (type == ButtonType.filled && gradient != null && isEnabled) {
      Widget button = Container(
        width: minWidth,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient!,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(resolvedBorderRadius),
          border: null,
          boxShadow: elevation != null && elevation! > 0
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: elevation! * 2,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(resolvedBorderRadius),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(resolvedBorderRadius),
            child: Center(child: child),
          ),
        ),
      );
      return expand ? SizedBox.expand(child: button) : button;
    }

    // For all other cases, build shape with border
    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(resolvedBorderRadius),
      side: BorderSide.none,
    );

    Widget button;

    switch (type) {
      case ButtonType.filled:
        final Color? bg = isEnabled
            ? backgroundColor ?? Theme.of(context).colorScheme.primary
            : disabledBackgroundColor ?? Theme.of(context).disabledColor;

        button = FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: textCol,
            disabledBackgroundColor: disabledBackgroundColor,
            disabledForegroundColor: disabledTextColor,
            elevation: isEnabled ? elevation ?? 2 : 0,
            minimumSize: Size(minWidth ?? 0, height ?? 50),
            padding: EdgeInsets.zero,
            shape: shape,
          ),
          child: child,
        );
        break;

      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: isEnabled
                ? backgroundColor ?? Colors.transparent
                : disabledBackgroundColor ?? Colors.transparent,
            foregroundColor: textCol,
            disabledForegroundColor: disabledTextColor,
            minimumSize: Size(minWidth ?? 0, height ?? 50),
            padding: EdgeInsets.zero,
            side: BorderSide.none, // We handle border in shape
            shape: shape,
          ),
          child: child,
        );
        break;

      case ButtonType.text:
        button = TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: isEnabled
                ? backgroundColor ?? Colors.transparent
                : disabledBackgroundColor ?? Colors.transparent,
            foregroundColor: textCol,
            disabledForegroundColor: disabledTextColor,
            minimumSize: Size(minWidth ?? 0, height ?? 50),
            padding: EdgeInsets.zero,
            shape: shape,
          ),
          child: child,
        );
        break;
    }

    return expand ? SizedBox.expand(child: button) : button;
  }
}
