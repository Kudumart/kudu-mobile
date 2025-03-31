import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/core/sample_data.dart';
import 'package:kudu/core/shared_widgets/product_card_view_1/product_card_view_1.dart';
import 'package:provider/provider.dart';

import '../../core/shared_widgets/app_image.dart';
import '../../core/utils/input_validators.dart';
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
import '../add_product/screen.dart';
import '../product_search/screen.dart';

class JobsDetailsScreen extends StatefulWidget {
  const JobsDetailsScreen({super.key, required this.job});
  final JobDetailsModel job;

  @override
  State<JobsDetailsScreen> createState() => _JobsDetailsScreenState();
}

class _JobsDetailsScreenState extends State<JobsDetailsScreen> {
  var formKey = GlobalKey<FormState>();
  final Debouncer _debouncer = Debouncer(milliseconds: 100);
  late JobDetailsModel job;
  bool loading = false;

  var emailController = TextEditingController();
  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var cvController = TextEditingController();
  File? cvFile;

  @override
  initState() {
    super.initState();
    job = widget.job;
  }

  void pickFile() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      cvController.text = file.path.split("/").last;
      setState(() {
        cvFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (c,result){

      },
      child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Job Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              centerTitle: false,
              titleSpacing: 0,
              leading: AppBackButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  Provider.of<HomeViewModel>(context, listen: false).searchValue = "";
                },
              ),
            ),
            body: SafeArea(
              minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 0, UiConstant.horizontalPadding, 10),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppImage(
                        imgUrl: job.logo.toString(),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        job.title ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
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
                      const Divider(),
                      5.height,
                      HtmlWidget(
                        job.description ?? "",
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      5.height,
                      const Divider(),
                      15.height,

                      const Text(
                        "Apply Now",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Fill the form to submit your application",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      10.height,
                      CustomOutlinedTextField(
                        label: "Full Name",
                        hint: "Enter your full name",
                        validator: InputValidator.validateValidInput,
                        controller: fullNameController,
                      ),
                      10.height,
                      CustomOutlinedTextField(
                        label: "Email",
                        hint: "Enter your email",
                        validator: InputValidator.validateEmail,
                        controller: emailController,
                      ),
                      10.height,
                      CustomOutlinedTextField(
                        label: "Phone Number",
                        hint: "Enter your phone number",
                        validator: InputValidator.validateValidInput,
                        controller: phoneController,
                      ),
                      10.height,
                      CustomOutlinedTextField(
                        label: "Attach CV/Resume",
                        hint: "Tap to pick file",
                        validator: (v){
                          if(cvFile == null){
                            return "Please attach your CV/Resume";
                          }
                          return null;
                        },
                        controller: cvController,
                        readOnly: true,
                        onTap: (){
                          pickFile();
                        },
                      ),
                      20.height,
                      ElevatedButton(
                        onPressed: (){
                          if(formKey.currentState!.validate()){
                            var homeProvider = Provider.of<HomeViewModel>(context, listen: false);
                            homeProvider.applyToJob(
                              context: context,
                              jobId: job.id ?? "",
                              emailAddress: emailController.text,
                              name: fullNameController.text,
                              phoneNumber: phoneController.text,
                              resume: cvFile!,
                            );
                          }
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith<
                              RoundedRectangleBorder>(
                                (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
