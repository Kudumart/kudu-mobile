part of '../screen.dart';

class BannerData{
  String? assetUrl;
  AdvertData? data;
  BannerData({this.assetUrl, this.data});
}

class _Banners extends StatefulWidget {
  const _Banners();

  @override
  State<_Banners> createState() => _BannersState();
}

class _BannersState extends State<_Banners> {
  List<AdvertData> adverts = [];
  List<BannerData> dataToDisplay = [
    BannerData(
      assetUrl: AppUiImage.banner,
    ),
    BannerData(
      assetUrl: AppUiImage.banner2,
    ),
    BannerData(
      assetUrl: AppUiImage.banner3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAdverts();
    });
  }

  Future<void> loadAdverts() async {
    final model = Provider.of<HomeViewModel>(context,listen: false);
    var response = await model.fetchAdverts(context: context);
    adverts = response?.data ?? [];

    dataToDisplay.clear();
    dataToDisplay.add(BannerData(
      assetUrl: AppUiImage.banner,
    ));
    dataToDisplay.add(BannerData(
      assetUrl: AppUiImage.banner2,
    ));
    dataToDisplay.add(BannerData(
      assetUrl: AppUiImage.banner3,
    ));
    for (var advert in adverts) {
      if(advert.showOnHomepage == true && advert.status == "approved"){
        dataToDisplay.add(BannerData(
          data: advert,
        ));
      }
    }
    if(mounted){
      setState(() {});
    }
  }

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
          scrollDirection: Axis.horizontal,
        ),
        items: dataToDisplay.map((banner) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () async {
                if(banner.data?.productId != null){
                  ProductDetailsScreenRoute(banner.data?.productId ?? "").push(context);
                }else if(banner.data?.link != null){
                  var uri = Uri.parse(banner.data?.link ?? "");
                  if (await canLaunchUrl(uri)) {
                    launchUrl(uri);
                  }
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: AppImage(
                imgUrl: banner.assetUrl ?? banner.data?.mediaUrl ?? "",
                height: 178,
                fit: BoxFit.cover,
                width: MediaQuery.sizeOf(context).width,
                borderColor: Colors.transparent,
                borderWidth: 0,
              ),
            ),
          );
          // return ClipRRect(
          //   borderRadius: BorderRadius.circular(16),
          //   child: Image.asset(
          //     banner,
          //     height: 178,
          //     fit: BoxFit.cover,
          //     width: MediaQuery.sizeOf(context).width,
          //   ),
          // );
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
