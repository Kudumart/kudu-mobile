class ApiSuccessResponse {
  final String message;
  final Object? body;

  ApiSuccessResponse({required this.message, this.body});
}



typedef BodyReader = Object Function(Map<String, dynamic>);