import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../images.dart';
import '../loading_indicator.dart';

part 'background.dart';
part 'success_dialog.dart';
part 'error_dialog.dart';

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
              dismissSuccessDialog(uniqueKey);
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

  dismissSuccessDialog(String uniqueKey) {
    final entry = _entries[uniqueKey];
    if (entry != null) {
      entry.remove();
      _entries.remove(uniqueKey);
    }
  }

  showErrorDialog(
    BuildContext context,
    String uniqueKey, {
    String? title,
    required String info,
    String? okayButtonText,
    Function? onPressedOkayButton,
  }) {
    if (_entries.containsKey(uniqueKey)) {
      throw "Duplicate error dialog key: $uniqueKey";
    }
    OverlayEntry? error;
    error = OverlayEntry(builder: (context) {
      return _OverlayBackground(
          absorbPointer: false,
          close: () => dismissErrorDialog(uniqueKey),
          child: _OverlayDialogShape(
              child: _CustomErrorDialog(
            info: info,
            title: title,
          )));
    });

    _entries[uniqueKey] = error;
    Overlay.of(context).insert(error);
  }

  dismissErrorDialog(String uniqueKey) {
    final entry = _entries[uniqueKey];
    if (entry != null) {
      entry.remove();
      _entries.remove(uniqueKey);
    }
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
}
