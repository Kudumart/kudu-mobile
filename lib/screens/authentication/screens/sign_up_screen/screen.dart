import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
// import 'package:kudu/data/api/client.dart';
import 'package:kudu/data/api/endpoints.dart';
import 'package:kudu/data/storage/shared_preferences.dart';
import 'package:kudu/models/enums_and_extensions.dart';
import 'package:kudu/core/shared_widgets/overlay/overlay.dart';
import 'package:kudu/core/utils/input_validators.dart';
import 'package:kudu/app/routes/routes.dart';
import 'package:kudu/providers/auth_viewmodel.dart';
import 'package:kudu/screens/authentication/shared_widgets/alternate_auth_option.dart';
import 'package:kudu/screens/authentication/shared_widgets/custom_filled_text_form_field.dart';
import 'package:kudu/screens/authentication/shared_widgets/terms_and_conditions_statement.dart';
import 'package:kudu/core/utils/request_operation_wrapper.dart';
import 'package:provider/provider.dart';

import '../../../../core/colors.dart';
import '../../../../core/constants.dart';
import '../../../../core/shared_widgets/back_button.dart';
import '../../shared_widgets/form_field_title.dart';
import '../../shared_widgets/password_text_form_field.dart';

part 'widgets/intl_phone_number_field.dart';

class SignUpScreen extends StatefulWidget {
  final UserType userType;
  const SignUpScreen(this.userType, {super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  String? phoneNumber;

  // final Map<String, dynamic> _values = {};

  late UserType _userType;

  @override
  void initState() {
    super.initState();
    _userType = widget.userType;
  }

  @override
  Widget build(BuildContext context) {
    final String accountType =
        _userType == UserType.customer ? "Kudu" : "Vendor";

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const AppBackButton(),
          scrolledUnderElevation: 0,
          // actions: [
          //   GestureDetector(
          //     onTap: _showAccountTypeInfo,
          //     child: const Icon(CupertinoIcons.info_circle_fill,
          //         color: AppUiColor.iconBlack, size: 20),
          //   ),
          //   const SizedBox(width: 7),
          //   GestureDetector(
          //     onTap: _toggleUserType,
          //     child: const Padding(
          //       padding: EdgeInsets.only(top: 3.0),
          //       child: Text("Switch Account Type",
          //           style: TextStyle(fontSize: 14, color: AppUiColor.textBlue)),
          //     ),
          //   ),
          //   const SizedBox(width: 18),
          // ],
        ),
        body: SafeArea(
          minimum: EdgeInsets.fromLTRB(
              UiConstant.horizontalPadding,
              20,
              UiConstant.horizontalPadding,
              MediaQuery.of(context).viewInsets.bottom + 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          text: "Create a ",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                          children: [
                        TextSpan(
                          text: accountType,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: AppUiColor.primary),
                        ),
                        const TextSpan(
                            text: " Account",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ))
                      ])),
                  const SizedBox(height: 10),
                  const Text(
                    "One last step before continuing to app",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 26),

                  // email
                  const FormFieldTitle("Email"),
                  CustomTextFormField(
                    textEditingController: _emailController,
                    hint: "Enter email",
                    validator: InputValidator.validateEmail,
                  ),
                  const SizedBox(height: 23),

                  // password
                  const FormFieldTitle("Password"),
                  PasswordTextFormField(
                    // validator: InputValidator.v,
                    textEditingController: _passwordController,
                  ),
                  const SizedBox(height: 23),

                  // first name
                  const FormFieldTitle("First Name"),
                  CustomTextFormField(
                    validator: InputValidator.validateValidInput,
                    hint: "Enter first name",
                    textEditingController: _firstNameController,
                  ),
                  const SizedBox(height: 23),

                  const FormFieldTitle("Last Name"),
                  CustomTextFormField(
                    validator: InputValidator.validateValidInput,
                    hint: "Enter last name",
                    textEditingController: _lastNameController,
                  ),
                  const SizedBox(height: 23),

                  // phone
                  const FormFieldTitle("Phone"),
                  _IntlPhoneNumberField(onChanged: (number) {
                    print(number!.completeNumber);
                    return phoneNumber = _formatNumber(number);
                  }),
                  const SizedBox(height: 25),

                  // terms and condition
                  const TermsAndConditionsStatement(),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        Provider.of<AuthViewmodel>(context, listen: false)
                            .registerWithEmail(
                          context: context,
                          email: _emailController.text,
                          password: _passwordController.text,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          phoneNumber: phoneNumber!,
                          userType: _userType,
                        );
                      }
                    },
                    child: Text("Create my $accountType Account"),
                  ),
                  const SizedBox(height: 32),
                  // login
                  const Center(child: AlternateAuthOption.login()),
                  const SizedBox(height: 12),
                  Center(
                    child: GestureDetector(
                      onTap: () => const ReAskVerificationCodeScreenRoute()
                          .push(context),
                      child: const Text(
                        "Verify your Email",
                        style: TextStyle(
                            color: AppUiColor.iconBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decorationColor: Colors.grey,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showAccountTypeInfo() {
    AppUiOverlay().showInfoDialog(context, "account-type-info",
        title: "Kudu Account Type",
        info:
            "On Kudu Mart, you can register a Vendor account, which allows you to reach millions of buyers across the country on the platform. "
            "Alternatively, you can register a normal account, which would allow you to get access to a wide range of products and vendors");
  }

  _toggleUserType() {
    setState(() {
      if (_userType == UserType.customer) {
        _userType = UserType.vendor;
      } else {
        _userType = UserType.customer;
      }
    });
  }

  _saveValues() async {
    // _formKey.currentState!.save();
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }

    // RequestOperationWrapper.executeForegroundRequest(context,
    //     request: () => ApiClient.sendPostRequest(
    //         _userType == UserType.vendor
    //             ? ApiEndpoint.signUpAsVendor
    //             : ApiEndpoint.signUpAsCustomer,
    //         _values,
    //         authenticate: false),
    //     onError: (apiError) => AppUiOverlay().showErrorDialog(
    //         context, "sign-up",
    //         info: apiError.message, title: apiError.title),
    //     onSuccess: (response) {
    //       AppStorage.saveUserEmail(_values["email"]);
    //       AppUiOverlay().showSuccessDialog(context, "sign-up",
    //           info: response.message,
    //           onPressedOkayButton: () =>
    //               const VerifyOTPScreenRoute(useForgotPasswordFlow: false)
    //                   .push(context));
    //     });
  }

  String? _formatNumber(PhoneNumber? phoneNumber) {
    if (phoneNumber == null) {
      return null;
    }

    // remove leading zero
    if (phoneNumber.number.startsWith('0')) {
      return "${phoneNumber.countryCode}${phoneNumber.number.substring(1)}";
    }
    return phoneNumber.completeNumber;
  }
}
