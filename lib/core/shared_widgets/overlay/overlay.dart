import 'dart:async';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/core/colors.dart';

import '../../images.dart';
import '../loading_indicator.dart';
import '../app_button.dart';

part 'background.dart';
part 'success_dialog.dart';
part 'error_dialog.dart';
part 'action_dialog.dart';
part 'info_dialog.dart';

class AppUiOverlay {
  static OverlayEntry? _loadingIndicatorEntry;
  static final Map<String, OverlayEntry> _entries = {};

  showSuccessDialog(
    BuildContext context,
    String uniqueKey, {
    String? title,
    required String info,
    String? okayButtonText,
    Function? onPressedOkayButton,
  }) {
    if (_entries.containsKey(uniqueKey)) {
      throw "Duplicate success dialog key: $uniqueKey";
    }
    OverlayEntry? success;
    success = OverlayEntry(builder: (context) {
      return _OverlayBackground(
          absorbPointer: false,
          child: _OverlayDialogShape(
              child: _CustomSuccessDialog(
            info: info,
            okayButtonText: okayButtonText,
            onPressedOkayButton: () {
              _dismissDialog(uniqueKey);
              if (onPressedOkayButton != null) {
                onPressedOkayButton();
              }
            },
            title: title,
          )));
    });

    _entries[uniqueKey] = success;
    Overlay.of(context).insert(success);
  }

  showInfoDialog(
    BuildContext context,
    String uniqueKey, {
    required String title,
    required String info,
  }) {
    if (_entries.containsKey(uniqueKey)) {
      throw "Duplicate success dialog key: $uniqueKey";
    }
    OverlayEntry? success;
    success = OverlayEntry(builder: (context) {
      return _OverlayBackground(
          absorbPointer: false,
          close: () => _dismissDialog(uniqueKey),
          child: _OverlayDialogShape(
              child: _CustomInfoDialog(
            info: info,
            title: title,
          )));
    });

    _entries[uniqueKey] = success;
    Overlay.of(context).insert(success);
  }

  showActionDialog(
    BuildContext context,
    String uniqueKey, {
    required String title,
    required String info,
    String? okayButtonText,
    Function? onPressedOkayButton,
  }) {
    if (_entries.containsKey(uniqueKey)) {
      throw "Duplicate action dialog key: $uniqueKey";
    }
    OverlayEntry? success;
    success = OverlayEntry(builder: (context) {
      return _OverlayBackground(
          absorbPointer: false,
          child: _OverlayDialogShape(
              child: _CustomActionDialog(
            onPressedCancelButton: () => _dismissDialog(uniqueKey),
            info: info,
            okayButtonText: okayButtonText,
            onPressedOkayButton: () {
              _dismissDialog(uniqueKey);
              if (onPressedOkayButton != null) {
                onPressedOkayButton();
              }
            },
            title: title,
          )));
    });

    _entries[uniqueKey] = success;
    Overlay.of(context).insert(success);
  }

  _dismissDialog(String uniqueKey) {
    final entry = _entries[uniqueKey];
    if (entry != null) {
      entry.remove();
      _entries.remove(uniqueKey);
    }
  }

  Future<void> showErrorDialog(
    BuildContext context,
    String uniqueKey, {
    String? title,
    required String info,
    String? okayButtonText,
    Function()? onPressedOkayButton,
  }) async {
    var completer = Completer();
    if (_entries.containsKey(uniqueKey)) {
      throw "Duplicate error dialog key: $uniqueKey";
    }
    OverlayEntry? error;
    error = OverlayEntry(builder: (context) {
      return _OverlayBackground(
          absorbPointer: false,
          close: (){
            _dismissDialog(uniqueKey);
            completer.complete();
          },
          child: _OverlayDialogShape(
              child: _CustomErrorDialog(
            info: info,
            title: title,
            okayButtonText: okayButtonText,
            onPressedOkayButton: () {
              _dismissDialog(uniqueKey);
              if (onPressedOkayButton != null) {
                onPressedOkayButton()!;
              }
              completer.complete();
            },
          )));
    });

    _entries[uniqueKey] = error;
    Overlay.of(context).insert(error);
    return completer.future;
  }

  static showLoadingIndicator(context) {
    if (_loadingIndicatorEntry != null) {
      return;
    }
    _loadingIndicatorEntry = OverlayEntry(builder: (context) {
      return const _OverlayBackground(
        absorbPointer: true,
        child: SizedBox(
          height: 90,
          width: 90,
          child: AppLoadingIndicator(),
        ),
      );
    });
    Overlay.of(context).insert(_loadingIndicatorEntry!);
  }

  static dismissLoadingIndicator() {
    if (_loadingIndicatorEntry == null) {
      return;
    }

    _loadingIndicatorEntry!.remove();
    _loadingIndicatorEntry = null;
  }

  showSuccessSnackbarMessage(BuildContext context, {required String message}) {
    DelightToastBar(
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: const Duration(milliseconds: 3500),
      builder: (context) => Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.09),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFF10B981), width: 4.5),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Success",
                          style: TextStyle(
                            color: Color(0xFF111827),
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message,
                          style: const TextStyle(
                            color: Color(0xFF4B5563),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.5,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).show(context);
  }

  showErrorSnackbarMessage(BuildContext context, {required String message}) {
    DelightToastBar(
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: const Duration(milliseconds: 4000),
      builder: (context) => Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFEE2E2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.09),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFFEF4444), width: 4.5),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.priority_high_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Error",
                          style: TextStyle(
                            color: Color(0xFF111827),
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message,
                          style: const TextStyle(
                            color: Color(0xFF4B5563),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.5,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).show(context);
  }

  showInfoSnackbarMessage(BuildContext context, {required String message}) {
    DelightToastBar(
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: const Duration(milliseconds: 3500),
      builder: (context) => Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFEF3C7), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.09),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppUiColor.primary, width: 4.5),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppUiColor.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Notice",
                          style: TextStyle(
                            color: Color(0xFF111827),
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message,
                          style: const TextStyle(
                            color: Color(0xFF4B5563),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.5,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).show(context);
  }
}
