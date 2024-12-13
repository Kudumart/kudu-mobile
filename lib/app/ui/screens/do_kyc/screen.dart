import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudu/app/ui/utils/input_validators.dart';

import '../../colors.dart';
import '../../constants.dart';
import '../../shared_widgets/back_button.dart';

part 'widgets/outlined_dropdown.dart';
part 'widgets/outlined_textfield.dart';

class DoKYCScreen extends StatefulWidget {
  const DoKYCScreen({super.key});

  @override
  State<DoKYCScreen> createState() => _DoKYCScreenState();
}

class _DoKYCScreenState extends State<DoKYCScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _values = {};

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
                          onSaved: (value) => _values["businessName"] = value),
                      const SizedBox(height: 12),
                      _CustomOutlinedTextField(
                          label: "Registration Number",
                          validator: InputValidator.validateValidInput,
                          hint: "Business registration number (optional)",
                          onSaved: (value) =>
                              _values["businessRegistrationNumber"] = value),
                      const SizedBox(height: 12),
                      _CustomOutlinedTextField(
                          label: "Tax ID",
                          validator: InputValidator.validateValidInput,
                          hint: "Tax ID (optional)",
                          onSaved: (value) =>
                              _values["taxIdentificationNumber"] = value),
                      const SizedBox(height: 12),
                      _CustomOutlinedTextField(
                          label: "Office Address",
                          validator: InputValidator.validateValidInput,
                          hint: "Enter office address (optional)",
                          onSaved: (value) => _values["officeAddress"] = value),
                      const SizedBox(height: 12),
                      _CustomOutlinedTextField(
                          label: "Business Phone Number",
                          validator: InputValidator.validateValidInput,
                          hint: "Enter phone number",
                          onSaved: (value) =>
                              _values["businessRegistrationNumber"] = value),
                      const SizedBox(height: 12),
                      _CustomOutlinedDropdownField(
                          label: "Product Specialized",
                          values: const [
                            "Cosmetics",
                            "Furniture",
                            "Property",
                            "Vehicles",
                            "Services"
                          ],
                          onSelect: (value) =>
                              _values["productCategory"] = value),
                      const SizedBox(height: 25),
                      const _SectionTitle("Account Details"),
                      const SizedBox(height: 20),
                      _CustomOutlinedTextField(
                          label: "Bank Name",
                          validator: InputValidator.validateValidInput,
                          hint: "Enter bank name",
                          onSaved: (value) => _values["bankName"] = value),
                      const SizedBox(height: 12),
                      _CustomOutlinedTextField(
                          label: "Account Number",
                          validator: InputValidator.validateValidInput,
                          hint: "Enter account number",
                          onSaved: (value) => _values["accountNumber"] = value),
                      const SizedBox(height: 12),
                      _CustomOutlinedTextField(
                          label: "Account Name",
                          validator: InputValidator.validateValidInput,
                          hint: "Account holder number",
                          onSaved: (value) => _values["accountName"] = value),
                      const SizedBox(height: 12),
                      _CustomOutlinedDropdownField(
                          label: "Account Type",
                          values: const [
                            "Current",
                            "Savings",
                          ],
                          onSelect: (value) => _values["accountType"] = value),
                      const SizedBox(height: 50),
                      ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.resolveWith<Size>(
                                (_) => const Size(double.infinity, 49)),
                            shape:
                                WidgetStateProperty.resolveWith<OutlinedBorder>(
                                    (_) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(35))),
                          ),
                          onPressed: () {},
                          child: const Text("Submit KYC"))
                    ],
                  )),
            ),
          )),
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
          color: AppUiColor.iconBlack),
    );
  }
}
