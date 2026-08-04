import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/shared_widgets/app_image.dart';
import 'package:kudu/core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import 'package:kudu/screens/jobs/job_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../../models/advert/advert_model.dart';
import '../../models/enums_and_extensions.dart';
import '../../models/home/products_list_model.dart';
import '../../models/jobs/job_details_model.dart';
import '../../models/product.dart';
import '../../models/search_filter.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/images.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../providers/chat_view_model.dart';
import '../../providers/home_provider.dart';
import '../product_search/screen.dart';
import 'create_advert_screen.dart';

class AdvertsScreen extends StatefulWidget {
  const AdvertsScreen({super.key});

  @override
  State<AdvertsScreen> createState() => _AdvertsScreenState();
}

class _AdvertsScreenState extends State<AdvertsScreen> {
  var searchController = TextEditingController();
  List<AdvertData> adverts = [];
  bool loading = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.text = Provider.of<HomeViewModel>(context, listen: false).searchValue;
      loadAdverts(force: true);
    });
  }

  Future<void> loadAdverts({bool force = false,bool showLoader = true}) async {
    final model = Provider.of<HomeViewModel>(context,listen: false);
    var response = await model.fetchUserAdverts(context: context,force: force,showLoader: showLoader);
    adverts = response?.data ?? [];
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (c,result){
        Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: RefreshIndicator(
          onRefresh: () async {
            await loadAdverts(force: true,showLoader: false);
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Adverts",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              centerTitle: false,
              bottom: SearchBarWithFilter(controller: searchController,onChanged: (s){
                if(mounted){
                  setState(() {

                  });
                }
              },hint: "Search Available Adverts",),
              titleSpacing: 0,
              leading: AppBackButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
                },
              ),
            ),
            body: SafeArea(
                minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 24, UiConstant.horizontalPadding, 10),
                child: Builder(
                  builder: (context) {
                    if(adverts.isEmpty && !loading){
                      return const SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Center(child: Text("No Adverts Available"),),
                      );
                    }

                    return ListView.builder(
                      itemCount: adverts.length,
                      itemBuilder: (context, index){
                        var advert = adverts[index];

                        if(searchController.text.isNotEmpty){
                          if(!(advert.title ?? "").toLowerCase().contains(searchController.text.toLowerCase())){
                            return const SizedBox();
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppImage(
                                  imgUrl: advert.mediaUrl ?? "",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  radius: 10,
                                ),
                                10.width,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        advert.title ?? "",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      5.height,
                                      const Text(
                                        "Status",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        advert.status?.toLowerCase().trim() == "pending" ? "Pending (Awaiting admin approval)" : advert.status?.capitalizeFirst ?? "Unknown Status",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Text(
                                        "Description",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        advert.description ?? "No Description",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      10.height,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAdvertScreen(dataToEdit: advert)));
                                loadAdverts(force: true,showLoader: false);
                              },
                              child: const SizedBox(
                                height: 40,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "Edit Advert",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    );
                  },
                )),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateAdvertScreen()));
                loadAdverts(force: true,showLoader: false);
              },
              backgroundColor: AppUiColor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(360),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
