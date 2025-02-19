import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';
import 'package:kudu/models/enums_and_extensions.dart';
import 'package:kudu/core/utils/input_validators.dart';
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

  // String? _selectedCurrency;

  String? _selectedCategoryId;
  String? _selectedName;

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

      setState(() {
        _selectedCategoryId = widget.productToEdit!.categoryId;
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
            categoryId: _selectedCategoryId!,
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
          var response = await Provider.of<StoreViewModel>(context, listen: false).addProductToStore(
            context: context,
            storeId: widget.storeId,
            categoryId: _selectedCategoryId!,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Consumer<StoreViewModel>(builder: (context, model, child) {
        return Scaffold(
            backgroundColor: AppUiColor.grey50,
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
            body: SafeArea(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionBackground(
                            children: [
                              const SizedBox(height: 20),
                              CustomCatetoriesDropdownField(
                                label: "Category",
                                values: model.getcategoriesModel,
                                hint: Text(_selectedName ?? 'Tap to select category'),
                                // initialValue: convertToCurrencyData(widget.store?.currency),
                                onSelect: (selectedCategory) {
                                  if (selectedCategory != null) {
                                    setState(() {
                                      _selectedCategoryId = selectedCategory.id;
                                    });
                                  }
                                },
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
                              const SizedBox(height: 12),
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
                              _CustomOutlinedTextField(
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
                              _CustomOutlinedTextField(
                                label: "Specification",
                                maxLines: 5,
                                validator: InputValidator.validateValidInput,
                                hint: "Enter product specifications",
                                controller: _specificationController,
                              ),
                              const SizedBox(height: 15),
                              _CustomOutlinedTextField(
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
                              _CustomOutlinedTextField(
                                label: "Price *",
                                validator: InputValidator.validatePrice,
                                hint: "Enter product price",
                                controller: _priceController,
                              ),
                              const SizedBox(height: 15),
                              _CustomOutlinedTextField(
                                label: "Discount Price",
                                validator: InputValidator.validatePrice,
                                hint: "Enter discount price (optional)",
                                controller: _discountPriceController,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _SectionBackground(
                            children: [
                              _CustomOutlinedTextField(
                                label: "Warranty",
                                hint: "Enter warranty information",
                                controller: _warrantyController,
                                validator: InputValidator.validateValidInput,
                              ),
                              const SizedBox(height: 15),
                              _CustomOutlinedTextField(
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
                              _CustomOutlinedTextField(
                                label: "SEO Title",
                                hint: "Enter SEO title",
                                controller: _seoTitleController,
                                validator: InputValidator.validateValidInput,
                              ),
                              const SizedBox(height: 15),
                              _CustomOutlinedTextField(
                                label: "Meta Description",
                                maxLines: 3,
                                hint: "Enter meta description",
                                controller: _metaDescriptionController,
                                validator: InputValidator.validateValidInput,
                              ),
                              const SizedBox(height: 15),
                              _CustomOutlinedTextField(
                                label: "Keywords",
                                hint: "Enter keywords (comma-separated)",
                                validator: InputValidator.validateValidInput,
                                controller: _keywordsController,
                              ),
                            ],
                          ),
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
                        ]),
                  ),
                )));
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
