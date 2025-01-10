import 'package:equatable/equatable.dart';

class ApiSuccessResponse extends Equatable {
  final String message;
  final Object? body;

  const ApiSuccessResponse({required this.message, this.body});

  @override
  List<Object?> get props => [message, body];

  @override
  bool? get stringify => true;
}

typedef BodyReader = Object Function(Map<String, dynamic>);
