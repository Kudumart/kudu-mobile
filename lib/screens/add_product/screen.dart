import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';
import 'package:kudu/models/enums_and_extensions.dart';
import 'package:kudu/core/utils/input_validators.dart';
import 'package:kudu/models/get_categories_model.dart';
import 'package:kudu/models/get_product_model.dart';
import 'package:kudu/models/get_store_model.dart';
import 'package:kudu/providers/store_viewmodel.dart';
import 'package:kudu/screens/add_product/widgets/custom_category_dropdown.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/shared_widgets/app_image.dart';
import '../../core/shared_widgets/back_button.dart';
import 'package:http/http.dart' as http;

import '../../providers/home_provider.dart';

part 'widgets/custom_outlined_dropdown_field.dart';
part 'widgets/custom_outlined_textfield.dart';
part 'widgets/image_pickers.dart';
part 'widgets/bulk_price_button.dart';
part 'widgets/filled_text_form_field.dart';
part 'widgets/subscription_option.dart';

class AddProductScreen extends StatefulWidget {
  final String storeId;
  final GetProductModel? productToEdit;
  final bool isEditing;

  const AddProductScreen({
    super.key,
    required this.storeId,
    this.productToEdit,
    this.isEditing = false,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool isAuctionProduct = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();
  final TextEditingController _specificationController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();
  final TextEditingController _returnPolicyController = TextEditingController();
  final TextEditingController _seoTitleController = TextEditingController();
  final TextEditingController _metaDescriptionController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();

  final TextEditingController _maxBidController = TextEditingController();
  final TextEditingController _bidIncrementController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _interestFeeController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  // String? _selectedCurrency;

  String? _selectedCategoryId;
  String? _selectedSubCategoryId;
  String? _selectedName;
  String? _selectedSubCategoryName;

  String? _condition;

  List<String> _imageUrls = [];
  // final List<String> _additionalImageUrls = [];

  bool _isUploading = false;

  List<String> _uploadedUrls = [];
  List<String> get uploadedUrls => _uploadedUrls;
  bool get isUploading => _isUploading;

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
  void initState() {
    super.initState();

    if (widget.isEditing && widget.productToEdit != null) {
      _productNameController.text = widget.productToEdit!.name ?? '';
      _descriptionController.text = widget.productToEdit!.description ?? '';
      _priceController.text = widget.productToEdit!.price ?? '';
      _discountPriceController.text = widget.productToEdit!.discountPrice ?? '';
      _specificationController.text = widget.productToEdit!.specification ?? '';
      _warrantyController.text = widget.productToEdit!.warranty ?? '';
      _returnPolicyController.text = widget.productToEdit!.returnPolicy ?? '';
      _seoTitleController.text = widget.productToEdit!.seoTitle ?? '';
      _metaDescriptionController.text =
          widget.productToEdit!.metaDescription ?? '';
      _keywordsController.text = widget.productToEdit!.keywords ?? '';

      var homeProvider = Provider.of<HomeViewModel>(context, listen: false);
      _selectedSubCategoryId = widget.productToEdit!.categoryId;
      var availableCategories = homeProvider.categoriesModel?.data ?? [];
      for(int i=0; i<availableCategories.length; i++){
        var category = availableCategories[i];
        if(category.subCategories != null){
          for(int j=0; j<category.subCategories!.length; j++){
            var subCategory = category.subCategories![j];
            if(subCategory.id == _selectedSubCategoryId){
              _selectedCategoryId = category.id;
              _selectedName = category.name;
              _selectedSubCategoryName = subCategory.name;
              _selectedSubCategoryId = subCategory.id;
              break;
            }
          }
        }
      }
      setState(() {
        setState(() {
          _condition = _mapConditionToDisplay(widget.productToEdit!.condition);
        });

        if (widget.productToEdit!.imageUrl != null) {
          // _uploadedUrls = [widget.productToEdit!.imageUrl!];
        }
        final List<dynamic> additionalImages = widget.productToEdit?.additionalImages ?? [];
        for (String imageUrl in additionalImages) {
          if (!_uploadedUrls.contains(imageUrl)) {
            _uploadedUrls.add(imageUrl);
          }
        }
        // if (widget.productToEdit!.additionalImages != null) {
        //   _uploadedUrls.add(widget.productToEdit!.additionalImages!);
        // }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoreViewModel>(context, listen: false)
          .getCategories(context: context);
      loadInitialData();
    });
  }

  String _mapConditionToDisplay(String? condition) {
    switch (condition) {
      case 'brand_new':
        return 'Brand New';
      case 'fairly_used':
        return 'Fairly Used';
      case 'refurbished':
        return 'Refurbished';
      case 'fairly_foreign':
        return 'Fairly Foreign';
      default:
        return '';
    }
  }

  String _mapDisplayToCondition(String display) {
    switch (display) {
      case 'Brand New':
        return 'brand_new';
      case 'Fairly Used':
        return 'fairly_used';
      case 'Refurbished':
        return 'refurbished';
      case 'Fairly Foreign':
        return 'fairly_foreign';
      default:
        return '';
    }
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_uploadedUrls.isEmpty) {
        await uploadImages(context: context, images: _imageUrls);
      }
      if (_uploadedUrls.isNotEmpty || _imageUrls.isNotEmpty) {
        if (widget.isEditing) {
          var response = await Provider.of<StoreViewModel>(context, listen: false).updateProduct(
            context: context,
            productId: widget.productToEdit!.id!,
            categoryId: _selectedSubCategoryId!,
            productName: _productNameController.text,
            condition: _condition!,
            description: _descriptionController.text,
            specification: _specificationController.text,
            price: _priceController.text,
            discountPrice: _discountPriceController.text,
            imageUrl: _uploadedUrls.first,
            additionalImages: _uploadedUrls,
            warranty: _warrantyController.text,
            returnPolicy: _returnPolicyController.text,
            seoTitle: _seoTitleController.text,
            metaDescription: _metaDescriptionController.text,
            keywords: _keywordsController.text,
          );
          if(response){
            Navigator.pop(context);
            Provider.of<StoreViewModel>(context, listen: false).getVendorsProducts(context: context);
          }
        } else {
          bool response = false;
          if(isAuctionProduct){
            await Provider.of<StoreViewModel>(context, listen: false).addAuctionProductToStore(
              context: context,
              storeId: widget.storeId,
              categoryId: _selectedSubCategoryId!,
              productName: _productNameController.text,
              condition: _condition!,
              description: _descriptionController.text,
              specification: _specificationController.text,
              price: _priceController.text,
              imageUrl: _uploadedUrls.first,
              additionalImages: _uploadedUrls,
              maxBidsPerUser: _maxBidController.text,
              bidIncrement: _bidIncrementController.text,
              participantsInterestFee: _interestFeeController.text,
              auctionEndDate: (_endDate ?? DateTime.now()).toIso8601String(),
              auctionStartDate: (_startDate ?? DateTime.now()).toIso8601String(),
            );
          }else{
            await Provider.of<StoreViewModel>(context, listen: false).addProductToStore(
              context: context,
              storeId: widget.storeId,
              categoryId: _selectedSubCategoryId!,
              productName: _productNameController.text,
              condition: _condition!,
              description: _descriptionController.text,
              specification: _specificationController.text,
              price: _priceController.text,
              discountPrice: _discountPriceController.text,
              imageUrl: _uploadedUrls.first,
              additionalImages: _uploadedUrls,
              warranty: _warrantyController.text,
              returnPolicy: _returnPolicyController.text,
              seoTitle: _seoTitleController.text,
              metaDescription: _metaDescriptionController.text,
              keywords: _keywordsController.text,
            );
          }
          if(response){
            Navigator.pop(context);
          }
        }
      } else {
        AppUiOverlay().showErrorSnackbarMessage(
          context,
          message: "Please upload at least one image",
        );
      }
    }
  }

  void clearUploadedUrls() {
    setState(() {
      _uploadedUrls = [];
    });
  }

  void loadInitialData(){
    var homeProvider = Provider.of<HomeViewModel>(context, listen: false);
    homeProvider.fetchCategories(context: context,force: true).then((_){
      if(mounted){
        setState(() {

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Consumer<StoreViewModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: const AppBackButton(),
            titleSpacing: 0,
            title: Text(
              widget.isEditing ? "Edit Product" : "Add Product",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            centerTitle: false,
          ),
          body: Container(
            color: Colors.grey.withAlpha(30),
            child: SafeArea(
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionBackground(
                            children: [
                              const SizedBox(height: 20),
                              Builder(
                                builder: (context) {
                                  return CustomCatetoriesDropdownField(
                                    key: ValueKey("is_auction_$isAuctionProduct"),
                                    label: "Product Type",
                                    values: [
                                      GetCategoriesModel(
                                        id: "non-auction",
                                        name: "Non Auction",
                                      ),
                                      GetCategoriesModel(
                                        id: "auction",
                                        name: "Auction",
                                      ),
                                    ],
                                    value: isAuctionProduct ? "auction" : "non-auction",
                                    hint: const Text('Tap to select product type'),
                                    onSelect: (selected) {
                                      if (selected != null) {
                                        setState(() {
                                          isAuctionProduct = selected.id == "auction";
                                        });
                                      }
                                    },
                                  );
                                }
                              ),

                              const SizedBox(height: 20),
                              Builder(
                                builder: (context) {
                                  var allCategories = (homeProvider.categoriesModel?.data ?? []);
                                  var categoriesToUse = allCategories.where((element) => element.subCategories != null && element.subCategories!.isNotEmpty).toList();
                                  return CustomCatetoriesDropdownField(
                                    key: ValueKey(_selectedCategoryId),
                                    label: "Category",
                                    values: categoriesToUse.map((e) => e.getCategoriesModel).toList(),
                                    value: categoriesToUse.isEmpty ? null :  _selectedCategoryId,
                                    hint: const Text('Tap to select category'),
                                    onSelect: (selectedCategory) {
                                      if (selectedCategory != null) {
                                        setState(() {
                                          _selectedCategoryId = selectedCategory.id;
                                        });
                                      }
                                    },
                                  );
                                }
                              ),

                              Builder(
                                builder: (context) {
                                  if(_selectedCategoryId == null || (homeProvider.categoriesModel?.data ?? []).isEmpty){
                                    return const SizedBox.shrink();
                                  }
                                  var categoryToUse = (homeProvider.categoriesModel?.data ?? []).firstWhere((element) => element.id == _selectedCategoryId);
                                  var subCategories = categoryToUse.subCategories ?? [];

                                  if(subCategories.isEmpty){
                                    return const SizedBox.shrink();
                                  }
                                  var hasCurrentSubCategory = subCategories.any((element) => element.id == _selectedSubCategoryId);
                                  if(!hasCurrentSubCategory){
                                    _selectedSubCategoryId = null;
                                  }

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 20),
                                      CustomCatetoriesDropdownField(
                                        key: ValueKey(_selectedSubCategoryId),
                                        label: "Sub Category",
                                        values: subCategories.map((e) => e.getCategoriesModel).toList(),
                                        value: _selectedSubCategoryId,
                                        hint: const Text('Tap to select sub-category'),
                                        onSelect: (selectedCategory) {
                                          if (selectedCategory != null) {
                                            setState(() {
                                              _selectedSubCategoryId = selectedCategory.id;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }
                              ),
                              // _CustomOutlinedDropdownField(
                              //   label: "Category",
                              //   values: _categories,
                              //   onSelect: (value) {
                              //     setState(() {
                              //       _selectedCategoryId = value;
                              //     });
                              //   },
                              // ),
                              const SizedBox(height: 10),
                              _ImagePickers(
                                onImagesSelected: (List<String> images) {
                                  setState(() {
                                    _imageUrls = images;
                                  });
                                },
                                productToEdit: widget.productToEdit,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                  "Click to select at least one image of the product you want to add",
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF939393))),
                              const SizedBox(height: 15),
                              CustomOutlinedTextField(
                                label: "Name",
                                validator: InputValidator.validateValidInput,
                                hint: "Enter product name",
                                controller: _productNameController,
                              ),
                              const SizedBox(height: 15),
                              _CustomOutlinedDropdownField(
                                label: "Condition",
                                hintText: Text(_condition ?? 'Tap to select'),
                                values: ProductCondition.values
                                    .map((cond) => cond.printableName())
                                    .toList(),
                                onSelect: (value) {
                                  setState(() {
                                    _condition = _mapDisplayToCondition(value!);
                                  });
                                },
                              ),
                              const SizedBox(height: 15),
                              CustomOutlinedTextField(
                                label: "Specification",
                                maxLines: 5,
                                validator: InputValidator.validateValidInput,
                                hint: "Enter product specifications",
                                controller: _specificationController,
                              ),
                              const SizedBox(height: 15),
                              CustomOutlinedTextField(
                                label: "Description",
                                maxLines: 10,
                                validator: InputValidator.validateValidInput,
                                hint: "Enter product description",
                                controller: _descriptionController,
                              )
                            ],
                          ),
                          const SizedBox(height: 18),
                          _SectionBackground(
                            children: [
                              CustomOutlinedTextField(
                                label: "Price *",
                                validator: InputValidator.validatePrice,
                                hint: "Enter product price",
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                              ),
                              if(!isAuctionProduct)...[
                                const SizedBox(height: 15),
                                CustomOutlinedTextField(
                                  label: "Discount Price",
                                  validator: (value){
                                    if((value ?? "").isNotEmpty){
                                      return InputValidator.validatePrice(value);
                                    }
                                    return null;
                                  },
                                  hint: "Enter discount price (optional)",
                                  controller: _discountPriceController,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ],
                          ),
                          if(!isAuctionProduct)...[
                            const SizedBox(height: 18),
                            _SectionBackground(
                              children: [
                                CustomOutlinedTextField(
                                  label: "Warranty",
                                  hint: "Enter warranty information",
                                  controller: _warrantyController,
                                  validator: InputValidator.validateValidInput,
                                ),
                                const SizedBox(height: 15),
                                CustomOutlinedTextField(
                                  label: "Return Policy",
                                  hint: "Enter return policy",
                                  controller: _returnPolicyController,
                                  validator: InputValidator.validateValidInput,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            _SectionBackground(
                              children: [
                                CustomOutlinedTextField(
                                  label: "SEO Title",
                                  hint: "Enter SEO title",
                                  controller: _seoTitleController,
                                  validator: InputValidator.validateValidInput,
                                ),
                                const SizedBox(height: 15),
                                CustomOutlinedTextField(
                                  label: "Meta Description",
                                  maxLines: 3,
                                  hint: "Enter meta description",
                                  controller: _metaDescriptionController,
                                  validator: InputValidator.validateValidInput,
                                ),
                                const SizedBox(height: 15),
                                CustomOutlinedTextField(
                                  label: "Keywords",
                                  hint: "Enter keywords (comma-separated)",
                                  validator: InputValidator.validateValidInput,
                                  controller: _keywordsController,
                                ),
                              ],
                            ),
                          ],

                          if(isAuctionProduct)...[
                            const SizedBox(height: 18),
                            _SectionBackground(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomOutlinedTextField(
                                        label: "Bid Increment",
                                        hint: "Enter Bid Increment",
                                        controller: _bidIncrementController,
                                        validator: InputValidator.validateNumber,
                                      ),
                                    ),
                                    10.width,
                                    Expanded(
                                      child: CustomOutlinedTextField(
                                        label: "Max Bid Per User",
                                        hint: "Enter Max Bid",
                                        controller: _maxBidController,
                                        validator: InputValidator.validateNumber,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                CustomOutlinedTextField(
                                  label: "Participants Interest Fee",
                                  hint: "Enter Participants Interest Fee",
                                  controller: _interestFeeController,
                                  validator: InputValidator.validateNumber,
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomOutlinedTextField(
                                        label: "Start Date",
                                        hint: "Select Start Date",
                                        controller: _startDateController,
                                        validator: InputValidator.validateValidInput,
                                        readOnly: true,
                                        onTap: () async {
                                          final DateTime? picked = await showDatePicker(
                                            context: context,
                                            initialDate: _startDate ?? DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime.now().add(const Duration(days: 730)),
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: const ColorScheme.light(
                                                    primary: AppUiColor.primary,
                                                    onPrimary: Colors.white,
                                                    onSurface: Colors.black,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );

                                          if (picked != null) {
                                            final TimeOfDay? timePicked = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.fromDateTime(picked),
                                              builder: (context, child) {
                                                return Theme(
                                                  data: Theme.of(context).copyWith(
                                                    colorScheme: const ColorScheme.light(
                                                      primary: AppUiColor.primary,
                                                      onPrimary: Colors.white,
                                                      onSurface: Colors.black,
                                                    ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );
                                            setState(() {
                                              _startDate = DateTime(picked.year, picked.month, picked.day, timePicked?.hour ?? 8, timePicked?.minute ?? 0);
                                              _startDateController.text = formatDate(
                                                DateTime(picked.year, picked.month, picked.day, timePicked?.hour ?? 8, timePicked?.minute ?? 0),
                                                [dd, "/", mm, "/", yyyy, " ", HH, ":", nn],
                                              );
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    10.width,
                                    Expanded(
                                      child: CustomOutlinedTextField(
                                        label: "End Date",
                                        hint: "Select End Date",
                                        controller: _endDateController,
                                        validator: InputValidator.validateValidInput,
                                        readOnly: true,
                                        onTap: () async {
                                          final DateTime? picked = await showDatePicker(
                                            context: context,
                                            initialDate: _endDate ?? DateTime.now(),
                                            firstDate: _startDate ??  DateTime(1900),
                                            lastDate: DateTime.now().add(const Duration(days: 730)),
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: const ColorScheme.light(
                                                    primary: AppUiColor.primary,
                                                    onPrimary: Colors.white,
                                                    onSurface: Colors.black,
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );

                                          if (picked != null) {
                                            final TimeOfDay? timePicked = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.fromDateTime(picked),
                                              builder: (context, child) {
                                                return Theme(
                                                  data: Theme.of(context).copyWith(
                                                    colorScheme: const ColorScheme.light(
                                                      primary: AppUiColor.primary,
                                                      onPrimary: Colors.white,
                                                      onSurface: Colors.black,
                                                    ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );
                                            setState(() {
                                              _endDate = DateTime(picked.year, picked.month, picked.day, timePicked?.hour ?? 8, timePicked?.minute ?? 0);
                                              _endDateController.text = formatDate(
                                                DateTime(picked.year, picked.month, picked.day, timePicked?.hour ?? 8, timePicked?.minute ?? 0),
                                                [dd, "/", mm, "/", yyyy, " ", HH, ":", nn],
                                              );
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 35),
                          _SectionBackground(children: [
                            ElevatedButton(
                              onPressed: _submitProduct,
                              style: ButtonStyle(
                                shape: MaterialStateProperty.resolveWith<
                                    RoundedRectangleBorder>(
                                  (_) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ),
                              child: Text(widget.isEditing
                                  ? "Update Product"
                                  : "Add Product"),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ])
                        ],
                    ),
                  ),
                ),
            ),
          ),
        );
      }),
    );
  }

}

class _SectionBackground extends StatelessWidget {
  final List<Widget> children;
  const _SectionBackground({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          UiConstant.horizontalPadding, 9, UiConstant.horizontalPadding, 22),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
