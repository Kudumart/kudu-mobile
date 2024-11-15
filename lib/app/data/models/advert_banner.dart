import 'package:equatable/equatable.dart';

class AdvertBanner extends Equatable {
  final String id;
  final String url;

  const AdvertBanner({required this.url, this.id = "temporary-banner"});
  
  @override
  List<Object?> get props => [id, url];
}
