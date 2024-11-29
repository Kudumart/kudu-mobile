import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/app/ui/colors.dart';
import 'package:kudu/app/ui/images.dart';
import 'package:kudu/app/ui/routes/routes.dart';
import 'package:kudu/app/ui/shared_widgets/back_button.dart';

part 'widgets/logo_container.dart';
part 'widgets/information_container.dart';

class ManageStoreScreen extends StatelessWidget {
  const ManageStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppUiColor.primary,
          isExtended: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          onPressed: () => const StoreProductsScreenRoute().push(context),
          icon: SvgPicture.asset(
            AppUiIcon.cartFilled,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          label: const Text(
            "Manage Products",
            style: TextStyle(color: Colors.white),
          )),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const AppBackButton(),
        titleSpacing: 0,
        title: const Text("My Store", style: TextStyle(fontSize: 16)),
      ),
      body: SafeArea(
          minimum: const EdgeInsets.fromLTRB(22, 27, 22, 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _LogoContainer(),
                const SizedBox(height: 18),
                _InformationContainer(basic),
                const SizedBox(height: 38),
                const Text("Contact Information",
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 18),
                _InformationContainer(contactInfo),
                const SizedBox(height: 38),
                const Text("Regional Information",
                    style: TextStyle(fontSize: 16)),
                const SizedBox(height: 18),
                _InformationContainer(regionalInfo),
                const SizedBox(height: 38),
                const Text("Bank Information", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 18),
                _InformationContainer(bankInfo),
              ],
            ),
          )),
    );
  }

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
      actionText: "Edit",
      onClickActionText: () {
        // Handle edit action for account number
      },
    ),
    DataItem(
      value: "Dwaelo Victor",
      name: "Account holder name",
      actionText: "Edit",
      onClickActionText: () {
        // Handle edit action for account holder name
      },
    ),
    DataItem(
      value: "Savings",
      name: "Account type",
      actionText: "Change",
      onClickActionText: () {
        // Handle change action for account type
      },
    ),
  ];

  static final List<DataItem> basic = [
    DataItem(
      value: "Kick Game",
      name: "Store Name",
      actionText: "Edit",
      onClickActionText: () {
        // Handle edit action for company/business name
      },
    ),
    DataItem(
      value: "893084738920",
      name: "CAC Registration Number",
      actionText: "Copy",
      onClickActionText: () {
        // Handle copy action for registration number
      },
    ),
    DataItem(
      value: "983-45-6271",
      name: "Tax ID",
      actionText: null,
      onClickActionText: null, // No action available for Tax ID
    ),
    DataItem(
      value: "Nigeria",
      name: "Business Location",
      actionText: "Change",
      onClickActionText: () {
        // Handle change action for business location
      },
    ),
    DataItem(
      value: "10%",
      name: "VAT Rates",
      actionText: "Add",
      onClickActionText: () {
        // Handle add action for tax rates
      },
    ),
  ];

  static final List<DataItem> contactInfo = [
    DataItem(
      value: "+1 023 456 7890",
      name: "Office contact phone",
      actionText: "Edit",
      onClickActionText: () {
        // Handle edit action for office contact phone
      },
    ),
    DataItem(
      value: "designer@greenmousetech.com",
      name: "Office contact email",
      actionText: "Edit",
      onClickActionText: () {
        // Handle edit action for office contact email
      },
    ),
    DataItem(
      value: "Lagos",
      name: "State",
      actionText: "Edit",
      onClickActionText: () {
        // Handle edit action for state
      },
    ),
  ];

  static final List<DataItem> regionalInfo = [
    DataItem(
      value: "Naira",
      name: "Currency",
      actionText: "Change",
      onClickActionText: () {
        // Handle change action for currency
      },
    ),
    DataItem(
      value: "dd/MM/yyyy",
      name: "Date Format",
      actionText: "Edit",
      onClickActionText: () {
        // Handle edit action for date format
      },
    ),
    DataItem(
      value: "English",
      name: "Language",
      actionText: "Edit",
      onClickActionText: () {
        // Handle edit action for language
      },
    ),
  ];
}
