class ApiError {
  final String title;
  final String message;

  ApiError({required this.title, required this.message});

  ApiError.clientException(e)
      : title = "Client Exception",
        message =
            "We are currentlty unable to handle your request. Please try again later. $e";

  ApiError.formatException(Object error)
      : title = "Format Exception",
        message =
            "Invalid configuration. $error. This error has been captured and will be resolved soon";
  ApiError.unknownException(Object error)
      : title = "Exception",
        message =
            "There was an error serving your request. Please retry the operatio ${error.toString()}";

  ApiError.noInternetConnectionDetected()
      : title = "No Connection",
        message =
            "Your phone does not have an stable internet connectivity. Kindly connect to a stable network and try again";

  ApiError.server(Object error)
      : title = "Server Error",
        message =
            "Server encountered an error and is unable to serve this request. Please try again later";

  ApiError.onRequest(String cause, int statusCode)
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
