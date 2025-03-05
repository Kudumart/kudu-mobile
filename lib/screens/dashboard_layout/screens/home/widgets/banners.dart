part of '../screen.dart';

class _Banners extends StatelessWidget {
  const _Banners();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
      child: CarouselSlider(
        options: CarouselOptions(
            height: 178.0,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal),
        items: [
          AppUiImage.banner,
          AppUiImage.banner2,
          AppUiImage.banner3,
        ].map((banner) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              banner,
              height: 178,
              fit: BoxFit.cover,
              width: MediaQuery.sizeOf(context).width,
            ),
          );
        }).toList(),
      ),
    );
    /* return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            AppUiImage.banner,
            height: 178,
            width: MediaQuery.sizeOf(context).width,
          )),
    ); */
  }
}
