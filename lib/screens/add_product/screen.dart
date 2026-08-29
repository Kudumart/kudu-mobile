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
import 'widgets/ai_product_creator_modal.dart';
import 'package:provider/provider.dart';
import 'package:kudu/core/shared_widgets/app_button.dart';

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

  final TextEditingController _quantityController = TextEditingController();

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
      _metaDescriptionController.text = widget.productToEdit!.metaDescription ?? '';
      _keywordsController.text = widget.productToEdit!.keywords ?? '';
      _quantityController.text = widget.productToEdit?.quantity?.toString() ?? '';

      _maxBidController.text = widget.productToEdit?.maxBidsPerUser?.toString() ?? '';
      _bidIncrementController.text = widget.productToEdit?.bidIncrement?.toString() ?? '';
      _interestFeeController.text = widget.productToEdit?.participantsInterestFee?.toString() ?? '';
      _startDateController.text = widget.productToEdit?.startDate != null ? formatDate((DateTime.tryParse(widget.productToEdit!.startDate!) ?? DateTime.now()), [dd, "/", mm, "/", yyyy]) : '';
      _endDateController.text = widget.productToEdit?.endDate != null ? formatDate((DateTime.tryParse(widget.productToEdit!.endDate!) ?? DateTime.now()), [dd, "/", mm, "/", yyyy]) : '';
      _startDate = widget.productToEdit?.startDate != null ? (DateTime.tryParse(widget.productToEdit!.startDate!) ?? DateTime.now()) : null;
      _endDate = widget.productToEdit?.endDate != null ? (DateTime.tryParse(widget.productToEdit!.endDate!) ?? DateTime.now()) : null;

      isAuctionProduct = widget.productToEdit?.auctionStatus != null;

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
          _condition = widget.productToEdit?.condition ?? 'brand_new';
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
    }else{
      _condition = ProductCondition.brandNew.apiName;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          Provider.of<StoreViewModel>(context, listen: false).getCategories(context: context);
          loadInitialData();
        } catch (_) {}
      }
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
      if (_uploadedUrls.isEmpty && _imageUrls.isNotEmpty) {
        await uploadImages(context: context, images: _imageUrls);
      }
      final targetCatId = _selectedSubCategoryId ?? _selectedCategoryId ?? "";
      final mainImage = _uploadedUrls.isNotEmpty ? _uploadedUrls.first : (_imageUrls.isNotEmpty ? _imageUrls.first : "");

      if (mainImage.isNotEmpty) {
        if (widget.isEditing) {
          bool response = false;
          if (isAuctionProduct) {
            response = await Provider.of<StoreViewModel>(context, listen: false).updateActionProduct(
              context: context,
              productId: widget.productToEdit!.id!,
              storeId: widget.storeId,
              categoryId: targetCatId,
              productName: _productNameController.text,
              condition: _condition ?? ProductCondition.values.first.apiName,
              description: _descriptionController.text,
              specification: _specificationController.text,
              price: _priceController.text,
              imageUrl: mainImage,
              additionalImages: _uploadedUrls.isNotEmpty ? _uploadedUrls : [mainImage],
              maxBidsPerUser: _maxBidController.text,
              bidIncrement: _bidIncrementController.text,
              participantsInterestFee: _interestFeeController.text,
              auctionEndDate: (_endDate ?? DateTime.now()).toIso8601String(),
              auctionStartDate: (_startDate ?? DateTime.now()).toIso8601String(),
            );
          } else {
            response = await Provider.of<StoreViewModel>(context, listen: false).updateProduct(
              context: context,
              productId: widget.productToEdit!.id!,
              categoryId: targetCatId,
              productName: _productNameController.text,
              condition: _condition ?? ProductCondition.values.first.apiName,
              description: _descriptionController.text,
              specification: _specificationController.text,
              price: _priceController.text,
              discountPrice: _discountPriceController.text,
              imageUrl: mainImage,
              additionalImages: _uploadedUrls.isNotEmpty ? _uploadedUrls : [mainImage],
              warranty: _warrantyController.text,
              returnPolicy: _returnPolicyController.text,
              seoTitle: _seoTitleController.text,
              metaDescription: _metaDescriptionController.text,
              keywords: _keywordsController.text,
              quantity: _quantityController.text,
            );
          }
          if (response && mounted) {
            Provider.of<StoreViewModel>(context, listen: false).getVendorsProducts(context: context);
            Navigator.pop(context);
          }
        } else {
          bool response = false;
          if (isAuctionProduct) {
            response = await Provider.of<StoreViewModel>(context, listen: false).addAuctionProductToStore(
              context: context,
              storeId: widget.storeId,
              categoryId: targetCatId,
              productName: _productNameController.text,
              condition: _condition ?? ProductCondition.values.first.apiName,
              description: _descriptionController.text,
              specification: _specificationController.text,
              price: _priceController.text,
              imageUrl: mainImage,
              additionalImages: _uploadedUrls.isNotEmpty ? _uploadedUrls : [mainImage],
              maxBidsPerUser: _maxBidController.text,
              bidIncrement: _bidIncrementController.text,
              participantsInterestFee: _interestFeeController.text,
              auctionEndDate: (_endDate ?? DateTime.now()).toIso8601String(),
              auctionStartDate: (_startDate ?? DateTime.now()).toIso8601String(),
            );
          } else {
            response = await Provider.of<StoreViewModel>(context, listen: false).addProductToStore(
              context: context,
              storeId: widget.storeId,
              categoryId: targetCatId,
              productName: _productNameController.text,
              condition: _condition ?? ProductCondition.values.first.apiName,
              description: _descriptionController.text,
              specification: _specificationController.text,
              price: _priceController.text,
              discountPrice: _discountPriceController.text,
              imageUrl: mainImage,
              additionalImages: _uploadedUrls.isNotEmpty ? _uploadedUrls : [mainImage],
              warranty: _warrantyController.text,
              returnPolicy: _returnPolicyController.text,
              seoTitle: _seoTitleController.text,
              metaDescription: _metaDescriptionController.text,
              keywords: _keywordsController.text,
              quantity: _quantityController.text,
            );
          }
          if (response && mounted) {
            Provider.of<StoreViewModel>(context, listen: false).getVendorsProducts(context: context);
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

  Future<void> _openAiProductCreator() async {
    final aiData = await AiProductCreatorModal.show(context);
    if (aiData != null && mounted) {
      setState(() {
        if (aiData['isAuction'] == true) {
          isAuctionProduct = true;
        } else {
          isAuctionProduct = false;
        }

        if (aiData['name'] != null && aiData['name'].toString().isNotEmpty) {
          _productNameController.text = aiData['name'].toString();
        }
        if (aiData['description'] != null && aiData['description'].toString().isNotEmpty) {
          _descriptionController.text = aiData['description'].toString();
        }
        if (aiData['suggestedPrice'] != null && aiData['suggestedPrice'].toString().isNotEmpty) {
          _priceController.text = aiData['suggestedPrice'].toString();
        }
        if (aiData['specifications'] != null && aiData['specifications'].toString().isNotEmpty) {
          _specificationController.text = aiData['specifications'].toString();
        }
        if (aiData['imagePath'] != null && aiData['imagePath'].toString().isNotEmpty) {
          _imageUrls = [aiData['imagePath'].toString()];
          _uploadedUrls = [];
        }
      });
      AppUiOverlay().showSuccessSnackbarMessage(
        context,
        message: "AI listing details auto-filled into form!",
      );
    }
  }

  Widget _buildAiBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDBA74).withAlpha(120)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppUiColor.primary.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppUiColor.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "✨ Create Product with AI",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Upload a photo to auto-fill title, description & price",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openAiProductCreator,
              icon: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
              label: const Text(
                "Auto-Fill Product with AI",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppUiColor.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
              widget.isEditing ? (isAuctionProduct ? "Edit Auction Product" :"Edit Product") : "Add Product",
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
                          if (!widget.isEditing) _buildAiBanner(),
                          _SectionBackground(
                            children: [
                              if(!widget.isEditing)...[
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
                                    },
                                ),
                              ],

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
                                  var availableCats = (homeProvider.categoriesModel?.data ?? []);
                                  var matchingCats = availableCats.where((element) => element.id == _selectedCategoryId);
                                  if (matchingCats.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  var categoryToUse = matchingCats.first;
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
                              ImagePickers(
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
                              Builder(
                                builder: (context) {
                                  return CustomCatetoriesDropdownField(
                                    key: ValueKey("Condition_$_condition"),
                                    label: "Condition",
                                    values: ProductCondition.values.map((cond) => GetCategoriesModel(
                                      id: cond.apiName,
                                      name: cond.printableName(),
                                    ),).toList(),
                                    value: ProductCondition.values.firstWhere((element) => element.apiName == _condition?.toLowerCase(), orElse: () => ProductCondition.brandNew).apiName,
                                    hint: const Text('Tap to select product type'),
                                    onSelect: (selected) {
                                      if (selected != null) {
                                        setState(() {
                                          _condition = selected.id;
                                        });
                                      }
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 15),
                              CustomOutlinedTextField(
                                label: "Specification",
                                maxLines: 5,
                                validator: InputValidator.validateValidInput,
                                hint: "Enter product specifications",
                                helperText: "List physical dimensions, weight, technical specs etc.",
                                controller: _specificationController,
                              ),
                              const SizedBox(height: 15),
                              CustomOutlinedTextField(
                                label: "Description",
                                maxLines: 10,
                                validator: InputValidator.validateValidInput,
                                hint: "Enter product description",
                                helperText: "Provide a detailed overview of the product features and benefits.",
                                controller: _descriptionController,
                              ),
                              if(!isAuctionProduct)...[
                                const SizedBox(height: 15),
                                CustomOutlinedTextField(
                                  label: "Quantity Available",
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a quantity";
                                    }
                                    if (int.tryParse(value) == null) {
                                      return "Please enter a valid number";
                                    }
                                    if(int.tryParse(value)! <= 0){
                                      return "Please enter a quantity greater than 0";
                                    }
                                    return null;
                                  },
                                  hint: "Enter product quantity",
                                  controller: _quantityController,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 18),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text("Pricing", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 10),
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
                                  helperText: "Leave empty if there's no discount on this product.",
                                  controller: _discountPriceController,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ],
                          ),
                          if(!isAuctionProduct)...[
                            const SizedBox(height: 18),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text("Policies", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 10),
                            _SectionBackground(
                              children: [
                                CustomOutlinedTextField(
                                  label: "Warranty",
                                  hint: "Enter warranty information",
                                  helperText: "e.g., 1 Year Manufacturer Warranty, or 'None'.",
                                  controller: _warrantyController,
                                  validator: InputValidator.validateValidInput,
                                ),
                                const SizedBox(height: 15),
                                CustomOutlinedTextField(
                                  label: "Return Policy",
                                  hint: "Enter return policy",
                                  helperText: "e.g., 7 Days Return window.",
                                  controller: _returnPolicyController,
                                  validator: InputValidator.validateValidInput,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text("Search Optimization (SEO)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 10),
                            _SectionBackground(
                              children: [
                                CustomOutlinedTextField(
                                  label: "SEO Title",
                                  hint: "Enter SEO title",
                                  helperText: "A short, descriptive title for search engines.",
                                  controller: _seoTitleController,
                                  validator: InputValidator.validateValidInput,
                                ),
                                const SizedBox(height: 15),
                                CustomOutlinedTextField(
                                  label: "Meta Description",
                                  maxLines: 3,
                                  hint: "Enter meta description",
                                  helperText: "A summary used by search engines (max 160 chars).",
                                  controller: _metaDescriptionController,
                                  validator: InputValidator.validateValidInput,
                                ),
                                const SizedBox(height: 15),
                                CustomOutlinedTextField(
                                  label: "Keywords",
                                  hint: "Enter keywords (comma-separated)",
                                  helperText: "e.g. laptop, gaming, 16gb ram",
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
                            AppButton(
                              onPressed: _submitProduct,
                              text: widget.isEditing
                                  ? "Update Product"
                                  : "Add Product",
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
