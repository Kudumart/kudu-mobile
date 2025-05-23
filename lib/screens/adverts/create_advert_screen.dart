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

import '../../core/shared_widgets/overlay/overlay.dart';
import '../../core/utils/input_validators.dart';
import '../../models/advert/advert_model.dart';
import '../../models/enums_and_extensions.dart';
import '../../models/get_categories_model.dart';
import '../../models/get_product_model.dart';
import '../../models/home/categories_model.dart';
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
import '../add_product/widgets/custom_category_dropdown.dart';
import '../product_search/screen.dart';

class CreateAdvertScreen extends StatefulWidget {
  const CreateAdvertScreen({super.key,this.dataToEdit});
  final AdvertData? dataToEdit;

  @override
  State<CreateAdvertScreen> createState() => _CreateAdvertScreenState();
}

class _CreateAdvertScreenState extends State<CreateAdvertScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CategoryData? selectedCategory;
  var titleController = TextEditingController();
  var linkController = TextEditingController();
  var descriptionController = TextEditingController();
  bool showOnHomePage = true;

  List<CategoryData>? categories;
  String? selectedImage;
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCategories();
      if(widget.dataToEdit != null){
        titleController.text = widget.dataToEdit?.title ?? "";
        linkController.text = widget.dataToEdit?.link ?? "";
        descriptionController.text = widget.dataToEdit?.description ?? "";
        showOnHomePage = widget.dataToEdit?.showOnHomepage == true;
        _uploadedUrls = [widget.dataToEdit?.mediaUrl ?? ""];
      }
    });
  }

  void getCategories(){
    var provider = Provider.of<HomeViewModel>(context, listen: false);
    provider.fetchAdvertCategories(context: context).then((value) {
      if (value != null) {
        categories = value.data;
        if(widget.dataToEdit != null){
          selectedCategory = categories?.firstWhere((element) => element.id == widget.dataToEdit?.categoryId);
        }
        if(mounted){
          setState(() {

          });
        }
      }
    });
  }

  List<String> _uploadedUrls = [];
  Future<void> createAdvert() async {
    if (_formKey.currentState!.validate()) {
      if (selectedImage != null || true) {
        if(_uploadedUrls.isEmpty){
          await uploadImages(context: context, images: [selectedImage ?? ""]);
        }
        if(_uploadedUrls.isEmpty){
          AppUiOverlay().showErrorSnackbarMessage(
            context,
            message: "Failed to upload image",
          );
        }else{
          var provider = Provider.of<HomeViewModel>(context, listen: false);
          bool response = false;
          if(widget.dataToEdit == null){
            response = await provider.createAdvert(
              context: context,
              title: titleController.text,
              description: descriptionController.text,
              categoryId: selectedCategory?.id ?? (categories?.isNotEmpty == true ? (categories![0].id ?? "") : ""),
              link: linkController.text,
              mediaUrl: _uploadedUrls[0],
              showOnHomepage: showOnHomePage,
            );
          }else{
            response = await provider.updateAdvert(
              context: context,
              title: titleController.text,
              description: descriptionController.text,
              categoryId: selectedCategory?.id ?? (categories?.isNotEmpty == true ? (categories![0].id ?? "") : ""),
              link: linkController.text,
              mediaUrl: _uploadedUrls[0],
              showOnHomepage: showOnHomePage,
            );
          }
          if(response){
            Navigator.pop(context);
          }
        }
      }else{
        AppUiOverlay().showErrorSnackbarMessage(
          context,
          message: "Please select an image to upload",
        );
      }
    }
  }

  bool _isUploading = false;
  Future<List<String>> uploadImages({
    required BuildContext context,
    required List<String> images,
  }) async {
    if (images.isEmpty) return [];

    try {
      _isUploading = true;
      AppUiOverlay.showLoadingIndicator(context);

      final List<String>? uploadedUrls = await Provider.of<HomeViewModel>(context, listen: false).uploadImages(images: images);
      _uploadedUrls = uploadedUrls ?? [];

      return uploadedUrls ?? [];
    } catch (e) {
      return [];
    } finally {
      _isUploading = false;
      AppUiOverlay.dismissLoadingIndicator();
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
              "New Advert",
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
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    CustomOutlinedTextField(
                      label: "Advert Title",
                      validator: InputValidator.validateValidInput,
                      hint: "Enter advert title",
                      controller: titleController,
                    ),
                    const SizedBox(height: 5),
                    ImagePickers(
                      imageLimit: 1,
                      onImagesSelected: (List<String> images) {
                        _uploadedUrls.clear();
                        setState(() {
                          if(images.isNotEmpty){
                            selectedImage = images[0];
                          }else{
                            selectedImage = null;
                          }
                        });
                      },
                      productToEdit: widget.dataToEdit != null ? GetProductModel(imageUrl: widget.dataToEdit?.mediaUrl) : null,
                    ),
                    const SizedBox(height: 15),
                    CustomCatetoriesDropdownField(
                      key: ValueKey("Category_$selectedCategory"),
                      label: "Category",
                      values: (categories ?? []).map((e) => e.getCategoriesModel).toList(),
                      value: selectedCategory?.id ?? (categories?.isNotEmpty == true ? categories![0].id : null),
                      hint: const Text('Tap to select category'),
                      onSelect: (selected) {
                        if (selected != null) {
                          setState(() {
                            selectedCategory = categories?.firstWhere((element) => element.id == selected.id);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomCatetoriesDropdownField(
                      key: ValueKey("Category_$showOnHomePage"),
                      label: "Show on Homepage",
                      values: [
                        GetCategoriesModel(
                          id: "true",
                          name: "Yes",
                        ),
                        GetCategoriesModel(
                          id: "false",
                          name: "No",
                        ),
                      ],
                      value: showOnHomePage ? "true" : "false",
                      hint: const Text('Tap to answer'),
                      onSelect: (selected) {
                        if (selected != null) {
                          setState(() {
                            showOnHomePage = selected.id == "true";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomOutlinedTextField(
                      label: "Advert Link",
                      validator: InputValidator.validateUrl,
                      hint: "Enter advert link",
                      controller: linkController,
                    ),
                    const SizedBox(height: 15),
                    CustomOutlinedTextField(
                      label: "Description",
                      maxLines: 10,
                      validator: InputValidator.validateValidInput,
                      hint: "Enter advert description",
                      controller: descriptionController,
                    ),

                    const SizedBox(height: 35),
                    ElevatedButton(
                      onPressed: (){
                        createAdvert();
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.resolveWith<
                            RoundedRectangleBorder>(
                              (_) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                      child: Text(widget.dataToEdit != null ? "Edit Advert" : "Create Advert"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
