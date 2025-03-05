import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/shared_widgets/back_button.dart';
import 'package:kudu/models/get_kyc_model.dart';
import 'package:kudu/providers/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../core/images.dart';

part 'widgets/logo_container.dart';
part 'widgets/information_container.dart';

class EditKYCScreen extends StatefulWidget {
  const EditKYCScreen({super.key});

  @override
  State<EditKYCScreen> createState() => _EditKYCScreenState();

  static final List<DataItem> bankInfo = [
    DataItem(
      value: "United Bank for Africa",
      name: "Bank name",
      actionText: null,
      onClickActionText: null, // No action available for bank name
    ),
    DataItem(
      value: "2209868974",
      name: "Account number",
      actionText: "",
      onClickActionText: () {
        // Handle edit action for account number
      },
    ),
    DataItem(
      value: "Dwaelo Victor",
      name: "Account holder name",
      actionText: "",
      onClickActionText: () {
        // Handle edit action for account holder name
      },
    ),
    DataItem(
      value: "Savings",
      name: "Account type",
      actionText: "",
      onClickActionText: () {
        // Handle change action for account type
      },
    ),
  ];

  static List<DataItem> getBasicInfo(GetKycModel? kycData) {
    final data = kycData?.data;
    return [
      DataItem(
        value: data?.businessName ?? "Not set",
        name: "Store Name",
        actionText: "",
        onClickActionText: () {
          // Handle edit action for company/business name
        },
      ),
      DataItem(
        value: data?.businessRegistrationNumber ?? "Not set",
        name: "CAC Registration Number",
        actionText: "",
        onClickActionText: () {
          // Handle copy action for registration number
        },
      ),
      DataItem(
        value: data?.idVerification != null
            ? data?.idVerification?.number ?? "Not set"
            : "Not set",
        name: "NIN ID",
        actionText: null,
        onClickActionText: null,
      ),
      DataItem(
        value: data?.businessAddress ?? "Not set",
        name: "Business Location",
        actionText: "",
        onClickActionText: () {
          // Handle change action for business location
        },
      ),
      DataItem(
        value: "10%", // Default value as not provided in API response
        name: "VAT Rates",
        actionText: "",
        onClickActionText: () {
          // Handle add action for tax rates
        },
      ),
    ];
  }

  static List<DataItem> getContactInfo(GetKycModel? kycData) {
    final data = kycData?.data;
    return [
      DataItem(
        value: data?.contactPhoneNumber ?? "Not set",
        name: "Office contact phone",
        actionText: "",
        onClickActionText: () {
          // Handle edit action for office contact phone
        },
      ),
      DataItem(
        value: data?.contactEmail ?? "Not set",
        name: "Office contact email",
        actionText: "",
        onClickActionText: () {
          // Handle edit action for office contact email
        },
      ),
      DataItem(
        value: "Lagos", // Default value as not provided in API response
        name: "State",
        actionText: "",
        onClickActionText: () {
          // Handle edit action for state
        },
      ),
    ];
  }

  static List<DataItem> getRegionalInfo(GetKycModel? kycData) {
    final data = kycData?.data;
    String formattedDate = "Not set";

    if (data?.createdAt != null) {
      try {
        final DateTime createdDate = DateTime.parse(data!.createdAt.toString());
        formattedDate = DateFormat('dd/MM/yyyy').format(createdDate);
      } catch (e) {
        formattedDate = "Invalid date";
      }
    }

    return [
      DataItem(
        value: "Naira",
        name: "Currency",
        actionText: "",
        onClickActionText: () {
          // Handle change action for currency
        },
      ),
      DataItem(
        value: formattedDate,
        name: "Date Format",
        actionText: "",
        onClickActionText: () {
          // Handle edit action for date format
        },
      ),
      DataItem(
        value: "English",
        name: "Language",
        actionText: "",
        onClickActionText: () {
          // Handle edit action for language
        },
      ),
    ];
  }
}

class _EditKYCScreenState extends State<EditKYCScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileViewModel>(context, listen: false).getKyc(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const AppBackButton(),
        titleSpacing: 0,
        title: const Text("Update KYC", style: TextStyle(fontSize: 16)),
      ),
      body: Consumer<ProfileViewModel>(builder: (context, model, child) {
        return SafeArea(
          minimum: const EdgeInsets.fromLTRB(22, 27, 22, 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _LogoContainer(),
                const SizedBox(height: 18),
                _InformationContainer(
                    EditKYCScreen.getBasicInfo(model.getKycModel)),
                const SizedBox(height: 38),
                const Text("Contact Information",
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 18),
                _InformationContainer(
                    EditKYCScreen.getContactInfo(model.getKycModel)),
                const SizedBox(height: 38),
                const Text("Regional Information",
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 18),
                _InformationContainer(
                    EditKYCScreen.getRegionalInfo(model.getKycModel)),
                const SizedBox(height: 38),
                const Text("Bank Information", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 18),
                _InformationContainer(EditKYCScreen.bankInfo),
              ],
            ),
          ),
        );
      }),
    );
  }
}
