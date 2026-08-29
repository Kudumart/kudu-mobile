import 'package:flutter/material.dart';
import 'package:kudu/core/colors.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, text, danger, success }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final double? height;
  final double? fontSize;
  final double borderRadius;
  final Color? textColor;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height,
    this.fontSize,
    this.borderRadius = 10.0,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? _getTextColor();

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: effectiveTextColor,
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: icon!,
          ),
        if (!isLoading && text.isNotEmpty)
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                text,
                maxLines: 1,
                style: TextStyle(
                  fontSize: fontSize ?? 13.5,
                  fontWeight: FontWeight.w700,
                  color: effectiveTextColor,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
      ],
    );

    final isInteractive = !isLoading && onPressed != null;

    final container = Material(
      color: isInteractive ? _getBackgroundColor() : _getDisabledBackgroundColor(),
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isInteractive ? onPressed : null,
        child: Container(
          height: height ?? 46,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: _getBorder(),
          ),
          alignment: Alignment.center,
          child: buttonContent,
        ),
      ),
    );

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: container,
          )
        : container;
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return const Color(0xFFFF6F22);
      case AppButtonVariant.secondary:
        return const Color(0xFFF3F4F6);
      case AppButtonVariant.outline:
        return Colors.white;
      case AppButtonVariant.ghost:
      case AppButtonVariant.text:
        return Colors.transparent;
      case AppButtonVariant.danger:
        return const Color(0xFFEF4444);
      case AppButtonVariant.success:
        return const Color(0xFF10B981);
    }
  }

  Color _getDisabledBackgroundColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return const Color(0xFFFF6F22).withOpacity(0.5);
      case AppButtonVariant.secondary:
        return const Color(0xFFF3F4F6).withOpacity(0.6);
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
      case AppButtonVariant.text:
        return Colors.white.withOpacity(0.7);
      case AppButtonVariant.danger:
        return const Color(0xFFEF4444).withOpacity(0.5);
      case AppButtonVariant.success:
        return const Color(0xFF10B981).withOpacity(0.5);
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.danger:
      case AppButtonVariant.success:
        return Colors.white;
      case AppButtonVariant.secondary:
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
      case AppButtonVariant.text:
        return const Color(0xFF111827); // Solid Black
    }
  }

  Border? _getBorder() {
    switch (variant) {
      case AppButtonVariant.outline:
        return Border.all(color: const Color(0xFFD1D5DB), width: 1.2);
      case AppButtonVariant.secondary:
        return Border.all(color: const Color(0xFFE5E7EB), width: 1.0);
      default:
        return null;
    }
  }
}
