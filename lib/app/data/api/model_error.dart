class ApiError {
  final String title;
  final String message;
  final int? statusCode;

  ApiError({required this.title, required this.message, this.statusCode});

  ApiError.unverifiedEmail(): statusCode = 403, title = "Unverified Email", message = "You are yet to verify your email. Kindly proceed to complete your email verification process to be able to login";

  ApiError.clientException(e, {this.statusCode})
      : title = "Client Exception",
        message =
            "We are currentlty unable to handle your request. Please try again later. $e";

  ApiError.formatException(Object error, {this.statusCode})
      : title = "Format Exception",
        message =
            "Invalid configuration. $error. This error has been captured and will be resolved soon";
  ApiError.unknownException(Object error, {this.statusCode})
      : title = "Exception",
        message =
            "There was an error serving your request. Please retry the operatio ${error.toString()}";

  ApiError.noInternetConnectionDetected( {this.statusCode})
      : title = "No Connection",
        message =
            "Your phone does not have an stable internet connectivity. Kindly connect to a stable network and try again";

  ApiError.server(Object error, {this.statusCode})
      : title = "Server Error",
        message =
            "Server encountered an error and is unable to serve this request. Please try again later";

  ApiError.onRequest(String cause, int this.statusCode)
      : title = _titleFromStatusCode(statusCode),
        message = cause;

  static String _titleFromStatusCode(int statusCode) {
    return "Request Error";
  }

  @override
  String toString() {
    return "$title: $message";
  }
}
