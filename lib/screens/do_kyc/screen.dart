import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudu/core/utils/input_validators.dart';
import 'package:kudu/providers/profile_provider.dart';
import 'package:kudu/providers/store_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/shared_widgets/back_button.dart';

part 'widgets/outlined_dropdown.dart';
part 'widgets/outlined_textfield.dart';

class DoKYCScreen extends StatefulWidget {
  const DoKYCScreen({super.key});

  @override
  State<DoKYCScreen> createState() => _DoKYCScreenState();
}

class _DoKYCScreenState extends State<DoKYCScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessDescriptionController =
      TextEditingController();
  final TextEditingController _businessLinkController = TextEditingController();
  final TextEditingController _businessAddressController =
      TextEditingController();
  final TextEditingController _businessRegistrationNumberController =
      TextEditingController();
  final TextEditingController _businessEmailController =
      TextEditingController();
  final TextEditingController _businessPhoneNumberController =
      TextEditingController();

  final TextEditingController _ninNumberController = TextEditingController();

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      Provider.of<ProfileViewModel>(context, listen: false).submitKyc(
        context: context,
        businessName: _businessNameController.text,
        contactEmail: _businessEmailController.text,
        contactPhoneNumber: _businessPhoneNumberController.text,
        businessDescription: _businessDescriptionController.text,
        businessLink: _businessLinkController.text,
        businessAddress: _businessAddressController.text,
        businessRegistrationNumber: _businessRegistrationNumberController.text,
        ninNumber: _ninNumberController.text,
      );
    } catch (e, x) {
      print(e);
      print(x);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error updating store. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppUiColor.ghostWhite,
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          leading: const AppBackButton(),
          titleSpacing: 0,
          title: const Text("KYC",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          centerTitle: false,
          forceMaterialTransparency: true,
        ),
        body: SafeArea(
          minimum: EdgeInsets.fromLTRB(
              UiConstant.horizontalPadding,
              30,
              UiConstant.horizontalPadding,
              MediaQuery.viewInsetsOf(context).bottom + 10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle("Business Details"),
                  const SizedBox(height: 25),
                  _CustomOutlinedTextField(
                    label: "Business Name",
                    validator: InputValidator.validateValidInput,
                    hint: "Business or brand name",
                    controller: _businessNameController,
                  ),
                  const SizedBox(height: 12),
                  _CustomOutlinedTextField(
                    label: "Business Email",
                    validator: InputValidator.validateEmail,
                    hint: "Enter business email",
                    controller: _businessEmailController,
                  ),
                  const SizedBox(height: 12),
                  _CustomOutlinedTextField(
                    label: "Business Description",
                    validator: InputValidator.validateValidInput,
                    hint: "Describe your business",
                    maxLines: 3,
                    controller: _businessDescriptionController,
                  ),
                  const SizedBox(height: 12),
                  _CustomOutlinedTextField(
                    label: "Business Website",
                    validator: InputValidator.validateUrl,
                    hint: "Enter business website",
                    controller: _businessLinkController,
                  ),
                  const SizedBox(height: 12),
                  _CustomOutlinedTextField(
                    label: "Business Address",
                    validator: InputValidator.validateValidInput,
                    hint: "Enter business address",
                    controller: _businessAddressController,
                  ),
                  const SizedBox(height: 12),
                  _CustomOutlinedTextField(
                    label: "Registration Number",
                    validator: InputValidator.validateValidInput,
                    hint: "Business registration number",
                    controller: _businessRegistrationNumberController,
                  ),
                  const SizedBox(height: 12),
                  _CustomOutlinedTextField(
                    label: "Business Phone Number",
                    validator: InputValidator.validateEmailOrPhone,
                    hint: "Enter phone number",
                    controller: _businessPhoneNumberController,
                  ),
                  const SizedBox(height: 12),
                  _CustomOutlinedTextField(
                    label: "NIN Number",
                    validator: InputValidator.validateValidInput,
                    hint: "Enter NIN number",
                    controller: _ninNumberController,
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.resolveWith<Size>(
                          (_) => const Size(double.infinity, 49)),
                      shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                          (_) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35))),
                    ),
                    onPressed: _submitForm,
                    child: const Text("Submit KYC"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String value;
  const _SectionTitle(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppUiColor.iconBlack,
      ),
    );
  }
}
