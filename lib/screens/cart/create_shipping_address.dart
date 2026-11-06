import 'package:country_state_city/utils/city_utils.dart';
import 'package:country_state_city/utils/state_utils.dart';
import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudu/core/extensions.dart';
import 'package:kudu/models/home/location_model.dart';
import 'package:kudu/models/order_summary.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/core/images.dart';
import 'package:kudu/core/shared_widgets/button_as_bottom_nav_bar.dart';
import 'package:kudu/core/shared_widgets/divider.dart';
import 'package:kudu/core/utils/price_formatter.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/shared_widgets/back_button.dart';
import '../../providers/home_provider.dart';
import '../checkout/screen.dart';
import '../product_details/screen.dart';

class CreateShippingAddress extends StatefulWidget {
  const CreateShippingAddress({super.key});

  @override
  State<CreateShippingAddress> createState() => _CreateShippingAddressState();
}

class _CreateShippingAddressState extends State<CreateShippingAddress> {
  var formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();

  final List<String> availableStates = ["Ontario", "Abuja", "New York"];
  // Cities from the same dataset the vendor delivery zones use, so a customer's
  // city matches a vendor's city-level delivery zone exactly.
  List<String> availableCities = [];
  final Map<String, String> _stateCodes = {};
  String _countryIso = '';

  Future<void> _loadCities() async {
    final code = _stateCodes[stateController.text.trim()];
    if (_countryIso.isEmpty || code == null) {
      if (mounted) setState(() => availableCities = []);
      return;
    }
    final cities = await getStateCities(_countryIso, code);
    if (!mounted) return;
    setState(() {
      availableCities = cities.map((c) => c.name).toList();
      if (!availableCities.contains(cityController.text.trim())) {
        cityController.text = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Parse the store data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      countryController.text = countries[1].name;
      getAllStates();
    });
  }

  Future<void> getAllStates() async {
    String? isoCode;
    if(countryController.text.isNotEmpty){
      isoCode = countries.firstWhere((element) => element.name.trim() == countryController.text.trim()).isoCode.name;
    }
    if(isoCode != null){
      final states = await getStatesOfCountry(isoCode);
      if(states.isNotEmpty){
        availableStates.clear();
        _countryIso = isoCode;
        _stateCodes.clear();
        await Future.forEach(states, (s){
          availableStates.add(s.name);
          _stateCodes[s.name] = s.isoCode;
        });
        if(!availableStates.contains(stateController.text.trim())){
          stateController.text = availableStates[0];
        }
        if(mounted){
          setState(() {

          });
        }
        await _loadCities();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Form(
        key: formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "New Delivery Address",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            centerTitle: false,
            titleSpacing: 0,
            leading: const AppBackButton(),
          ),
          body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(UiConstant.horizontalPadding, 0, UiConstant.horizontalPadding, 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DeliveryAddressField(
                    addressController: addressController,
                    hintText: "Enter your delivery address",
                    title: "Address",
                  ),
                  10.height,
                  CustomOutlinedDropdownField(
                    key: ValueKey("state_${stateController.text}"),
                    label: "State",
                    values: availableStates,
                    value: stateController.text.isNotEmpty ? stateController.text : null,
                    onSelect: (state) {
                      stateController.text = state!;
                      _loadCities();
                      return stateController.text;
                    },
                  ),
                  10.height,
                  if (availableCities.isNotEmpty)
                    CustomOutlinedDropdownField(
                      key: ValueKey("city_${stateController.text}_${availableCities.length}"),
                      label: "City",
                      values: availableCities,
                      value: cityController.text.isNotEmpty ? cityController.text : null,
                      onSelect: (city) => cityController.text = city ?? "",
                    )
                  else
                    DeliveryAddressField(
                      addressController: cityController,
                      hintText: "Enter your city",
                      title: "City",
                    ),
                  10.height,
                  CustomOutlinedDropdownField(
                    key: ValueKey("country_${countryController.text}"),
                    label: "Country",
                    values: countries.map((e) => e.name).toList(),
                    value: countryController.text.isNotEmpty ? countryController.text : null,
                    onSelect: (country) {
                      countryController.text = country ?? "";
                      getAllStates();
                      return countryController.text = country ?? "";
                    },
                  ),
                  40.height,
                  SizedBox(
                    height: 50,
                    child: AppIconButton(
                      label: const Text(
                        'Set Address',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onPressed: () async {
                        if (cityController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select your city")));
                          return;
                        }
                        var provider = Provider.of<HomeViewModel>(context, listen: false);
                        await provider.updateShippingAddress(context: context, location: LocationModel(
                          address: addressController.text,
                          city: cityController.text,
                          state: stateController.text,
                          country: countryController.text,
                        ));
                      },
                    ),
                  ),
                  10.height,                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomOutlinedDropdownField extends StatefulWidget {
  final List<String> values;
  final Function(String?) onSelect;
  final String label;
  final String? value;
  const CustomOutlinedDropdownField({
    required this.label,
    required this.values,
    required this.onSelect,
    this.value,
    super.key,
  });

  @override
  State<CustomOutlinedDropdownField> createState() =>
      _CustomOutlinedDropdownFieldState();
}

class _CustomOutlinedDropdownFieldState extends State<CustomOutlinedDropdownField> {
  String? _selectedValue;

  @override
  initState() {
    super.initState();
    if(widget.value != null) {
      _selectedValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color(0xFFD2D2D2)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...[
        const SizedBox(height: 10),
        Text(widget.label,
          style: const TextStyle(
            color: Color(0xFF9e9e9e),
            fontWeight: FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ],
        DropdownButtonFormField<String>(
          validator: (value) {
            return (value?.trim() ?? "").isEmpty ? "Field is Required" : null;
          },
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
              isDense: true,
              constraints: const BoxConstraints(minHeight: 53, maxHeight: 75),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              filled: true,
              fillColor: AppUiColor.ghostWhite,
              hintText: "Tap to Select",
              hintStyle: const TextStyle(fontSize: 14, color: AppUiColor.iconBlack),
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: AppUiColor.borderline),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              floatingLabelStyle:
              const TextStyle(color: Colors.grey, fontSize: 12)),
          value: _selectedValue,
          icon: const Icon(
            CupertinoIcons.chevron_down,
            size: 12,
            color: AppUiColor.iconBlack,
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedValue = newValue;
              widget.onSelect(newValue);
            });
          },
          items: widget.values.map<DropdownMenuItem<String>>((String state) {
            return DropdownMenuItem<String>(
              value: state,
              child: Text(
                state,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
