import 'package:equatable/equatable.dart';

class NotificationData extends Equatable {
  final String content;
  final String id;
  final DateTime created;
  final String title;
  final bool isRead;

  const NotificationData({
    required this.content,
    required this.id,
    required this.created,
    required this.title,
    required this.isRead,
  });

  @override
  List<Object?> get props => [content, id, created, title, isRead];
}
