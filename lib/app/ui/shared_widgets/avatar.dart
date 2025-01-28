import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../images.dart';

class UserCircleAvatar extends StatelessWidget {
  final String? url;
  final double circleRadius;
  final Size imageSize;
  const UserCircleAvatar(this.url,
      {required this.circleRadius, required this.imageSize, super.key});

  @override
  Widget build(BuildContext context) {
    return url == null
        ? SizedBox(
      height: imageSize.height,
      width: imageSize.width,
          child: CircleAvatar(
              radius: circleRadius,
              foregroundImage: Image.asset(
                AppUiImage.userAvatar,
                height: imageSize.height,
                width: imageSize.width,
              ).image,
            ),
        )
        : CachedNetworkImage(
            height: imageSize.height,
            width: imageSize.width,
            imageUrl: url!,
            imageBuilder: (_, imageProvider) {
              return CircleAvatar(radius: circleRadius, foregroundImage: imageProvider);
            },
            placeholder: (_, __) => CircleAvatar(
              radius: circleRadius,
              foregroundImage: Image.asset(
                AppUiImage.userAvatar,
                height: imageSize.height,
                width: imageSize.width,
              ).image,
            ),
            errorWidget: (_, __, ___) => CircleAvatar(
              radius: circleRadius,
              foregroundImage: Image.asset(
                AppUiImage.brokenImageIcon,
                height: imageSize.height,
                width: imageSize.width,
              ).image,
            ),
          );
  }
}
