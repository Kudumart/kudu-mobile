import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import 'package:kudu/screens/jobs/job_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

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

class JobsSearchScreen extends StatefulWidget {
  const JobsSearchScreen({super.key});

  @override
  State<JobsSearchScreen> createState() => _JobsSearchScreenState();
}

class _JobsSearchScreenState extends State<JobsSearchScreen> {
  final Debouncer _debouncer = Debouncer(milliseconds: 100);
  var searchController = TextEditingController();
  List<JobDetailsModel>? jobs;
  bool loading = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.text = Provider.of<HomeViewModel>(context, listen: false).searchValue;
      getJobs();
    });
  }

  Future<void> getJobs({String? searchTerm}) async {
    if(mounted){
      setState(() {
        loading = true;
      });
    }

    var provider = Provider.of<HomeViewModel>(context, listen: false);
    provider.searchValue = searchTerm ?? provider.searchValue;
    jobs = await provider.fetchAllJobs(context: context);
    if(mounted){
      setState(() {
        loading = false;
      });
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
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Jobs",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              centerTitle: false,
              bottom: SearchBarWithFilter(controller: searchController,onChanged: (s){
                if(mounted){
                  setState(() {

                  });
                }
              },hint: "Search Available Jobs",),
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
                    if((jobs ?? []).isEmpty && !loading){
                      return const Center(child: Text("No Jobs Available"));
                    }

                    return ListView.builder(
                      itemCount: jobs?.length ?? 0,
                      itemBuilder: (context, index){
                        var job = jobs![index];
                        var document = parse(job.description ?? "");
                        var description = parse(document.body!.text).documentElement?.text ?? "";

                        if(searchController.text.isNotEmpty){
                          if(!(job.title ?? "").toLowerCase().contains(searchController.text.toLowerCase())){
                            return const SizedBox();
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: AppUiColor.primary),
                                2.width,
                                Text(
                                  job.location ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                20.width,
                                const Icon(Icons.access_time_filled, size: 16, color: Colors.blue),
                                2.width,
                                Text(
                                  job.jobType ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            5.height,
                            const Text(
                              "Company Description",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            10.height,
                            InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobsDetailsScreen(job: job)));
                              },
                              child: const SizedBox(
                                height: 40,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "View Job Details",
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
          )),
    );
  }
}
