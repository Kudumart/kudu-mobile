part of '../screen.dart';

class _Banners extends StatelessWidget {
  const _Banners();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            AppUiImage.banner,
            height: 178,
            width: MediaQuery.sizeOf(context).width,
          )),
    );
  }
}
