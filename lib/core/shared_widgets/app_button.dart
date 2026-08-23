import 'package:flutter/material.dart';
import 'package:kudu/core/colors.dart';

enum AppButtonVariant { primary, secondary, outline, text, danger, success }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: _getLoadingColor()),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: icon!,
          ),
        if (!isLoading)
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _getTextColor(),
            ),
          ),
      ],
    );

    final style = ElevatedButton.styleFrom(
      backgroundColor: _getBackgroundColor(),
      foregroundColor: _getTextColor(),
      disabledBackgroundColor: _getBackgroundColor().withOpacity(0.5),
      disabledForegroundColor: _getTextColor().withOpacity(0.5),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: _getBorderSide(),
      ),
    );

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (isLoading || onPressed == null) ? null : onPressed,
              style: style,
              child: buttonContent,
            ),
          )
        : ElevatedButton(
            onPressed: (isLoading || onPressed == null) ? null : onPressed,
            style: style,
            child: buttonContent,
          );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppUiColor.primary;
      case AppButtonVariant.secondary:
        return AppUiColor.buttonFillGrey200;
      case AppButtonVariant.danger:
        return Colors.red.shade500;
      case AppButtonVariant.success:
        return Colors.green.shade500;
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return Colors.transparent;
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
      case AppButtonVariant.text:
        return AppUiColor.iconBlack;
    }
  }

  Color _getLoadingColor() {
    return _getTextColor();
  }

  BorderSide _getBorderSide() {
    if (variant == AppButtonVariant.outline) {
      return const BorderSide(color: AppUiColor.borderline, width: 1.5);
    }
    return BorderSide.none;
  }
}
