part of '../screen.dart';

class _Avatar extends StatelessWidget {
  final String? url;
  const _Avatar(this.url);

  @override
  Widget build(BuildContext context) {
    return url == null
        ? CircleAvatar(
            radius: 50,
            foregroundImage: Image.asset(
              AppUiImage.userAvatar,
              height: 104,
              width: 104,
            ).image,
          )
        : CachedNetworkImage(
            height: 104,
            width: 104,
            imageUrl: url!,
            imageBuilder: (_, imageProvider) {
              return CircleAvatar(radius: 50, foregroundImage: imageProvider);
            },
            placeholder: (_, __) => Image.asset(
              AppUiImage.userAvatar,
              height: 104,
              width: 104,
            ),
            errorWidget: (_, __, ___) => Image.asset(
              AppUiImage.brokenImageIcon,
              height: 104,
              width: 104,
            ),
          );
  }
}
