import 'package:flutter/material.dart';
import 'package:kudu/app/data/api/model_success.dart';
import 'package:kudu/app/ui/shared_widgets/overlay/overlay.dart';

import '../../data/api/model_error.dart';

class RequestOperationWrapper {
  /// [executeForegroundRequest] wraps [request] in a try-catch and pass the successful response to
  /// [onSuccess], provided there was no error.
  /// Note that while [request] is being executed, a loading indicator is displayed to prevent
  /// further interaction with the UI elements
  static executeForegroundRequest(BuildContext context,
      {required Future<ApiSuccessResponse> Function() request,
      required Function(ApiError) onError,
      required Function(ApiSuccessResponse response) onSuccess}) async {
    try {
      AppUiOverlay.showLoadingIndicator(context);
      final response = await request();
      AppUiOverlay.dismissLoadingIndicator();
      onSuccess(response);
    } on ApiError catch (apiError) {
      AppUiOverlay.dismissLoadingIndicator();
      onError(apiError);
    }
  }
}
