import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kudu/app/models/enums_and_extensions.dart';
import 'package:kudu/app/ui/utils/input_validators.dart';

import '../../colors.dart';
import '../../constants.dart';
import '../../shared_widgets/back_button.dart';

part 'widgets/custom_outlined_dropdown_field.dart';
part 'widgets/custom_outlined_textfield.dart';
part 'widgets/image_pickers.dart';
part 'widgets/bulk_price_button.dart';
part 'widgets/filled_text_form_field.dart';
part 'widgets/subscription_option.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  static const List<String> _categories = [
    "Vehicles",
    "Phones & Tablets",
    "Electronics",
    "Health & Beauty",
    "Home & Office",
    "Properties",
    "Fashion",
    "Sport",
    "Pets",
    "Services"
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppUiColor.grey50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: const AppBackButton(),
            titleSpacing: 0,
            title: const Text("Add Product",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            centerTitle: false,
          ),
          body: SafeArea(
              minimum: const EdgeInsets.only(top: 15, bottom: 10),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionBackground(children: [
                          const SizedBox(height: 20),
                          _CustomOutlinedDropdownField(
                              label: "Category",
                              values: _categories,
                              onSelect: (_) {}),
                          const SizedBox(height: 12),
                          const _ImagePickers(),
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
                              onSaved: (_) {}),
                          const SizedBox(height: 15),
                          _CustomOutlinedTextField(
                              label: "Brand",
                              validator: InputValidator.validateValidInput,
                              hint: "Enter product brand",
                              onSaved: (_) {}),
                          const SizedBox(height: 15),
                          _CustomOutlinedDropdownField(
                              label: "Condition",
                              values: ProductCondition.values
                                  .map((cond) => cond.printableName())
                                  .toList(),
                              onSelect: (_) {}),
                          const SizedBox(height: 15),
                          _CustomOutlinedTextField(
                              label: "Description",
                              maxLines: 10,
                              validator: InputValidator.validateValidInput,
                              hint: "Enter product description",
                              onSaved: (_) {})
                        ]),
                        const SizedBox(height: 18),
                        _SectionBackground(children: [
                          _CustomOutlinedTextField(
                              label: "Price *",
                              validator: InputValidator.validatePrice,
                              hint: "Enter product price",
                              onSaved: (_) {}),
                          const SizedBox(height: 15),
                          const _BulkPriceButton()
                        ]),
                        const SizedBox(height: 18),
                        const _SubscriptionOptions(),
                        const SizedBox(height: 35),
                        _SectionBackground(children: [
                          ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: WidgetStateProperty.resolveWith<
                                        RoundedRectangleBorder>(
                                    (_) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(7))),
                              ),
                              child: const Text("Add Product")),
                          const SizedBox(
                            height: 10,
                          )
                        ])
                      ]),
                ),
              ))),
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
