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
      final matchingCity = availableCities.firstWhere(
        (c) => c.trim().toLowerCase() == cityController.text.trim().toLowerCase(),
        orElse: () => '',
      );
      if (matchingCity.isNotEmpty) {
        cityController.text = matchingCity;
      } else if (!availableCities.contains(cityController.text.trim())) {
        cityController.text = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<HomeViewModel>(context, listen: false);
      final loc = provider.userData?.location;

      if (loc != null) {
        addressController.text = loc.address ?? "";

        // Country: match user's country or default to Nigeria
        if (loc.country != null && loc.country!.trim().isNotEmpty) {
          final matchedCountry = countries.firstWhere(
            (c) => c.name.trim().toLowerCase() == loc.country!.trim().toLowerCase(),
            orElse: () => countries.firstWhere(
              (c) => c.name.trim().toLowerCase() == 'nigeria',
              orElse: () => countries[0],
            ),
          );
          countryController.text = matchedCountry.name;
        } else {
          final nigeria = countries.firstWhere(
            (c) => c.name.trim().toLowerCase() == 'nigeria',
            orElse: () => countries[0],
          );
          countryController.text = nigeria.name;
        }

        if (loc.state != null && loc.state!.trim().isNotEmpty) {
          stateController.text = loc.state!.trim();
        }
        if (loc.city != null && loc.city!.trim().isNotEmpty) {
          cityController.text = loc.city!.trim();
        }
      } else {
        final nigeria = countries.firstWhere(
          (c) => c.name.trim().toLowerCase() == 'nigeria',
          orElse: () => countries[0],
        );
        countryController.text = nigeria.name;
      }

      await getAllStates();
    });
  }

  Future<void> getAllStates() async {
    String? isoCode;
    if (countryController.text.isNotEmpty) {
      try {
        isoCode = countries
            .firstWhere((element) =>
                element.name.trim().toLowerCase() ==
                countryController.text.trim().toLowerCase())
            .isoCode
            .name;
      } catch (_) {}
    }
    if (isoCode != null) {
      final states = await getStatesOfCountry(isoCode);
      if (states.isNotEmpty) {
        availableStates.clear();
        _countryIso = isoCode;
        _stateCodes.clear();
        for (final s in states) {
          availableStates.add(s.name);
          _stateCodes[s.name] = s.isoCode;
        }
        final matchingState = availableStates.firstWhere(
          (s) => s.trim().toLowerCase() == stateController.text.trim().toLowerCase(),
          orElse: () => '',
        );
        if (matchingState.isNotEmpty) {
          stateController.text = matchingState;
        } else if (availableStates.isNotEmpty) {
          stateController.text = availableStates[0];
        }
        if (mounted) {
          setState(() {});
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
                    hintText: "Enter your street address (e.g. 12 Adeola Odeku St)",
                    title: "Street Address",
                  ),
                  10.height,
                  CustomOutlinedDropdownField(
                    key: ValueKey("state_${stateController.text}_${availableStates.length}"),
                    label: "State",
                    values: availableStates,
                    value: stateController.text.isNotEmpty && availableStates.contains(stateController.text) ? stateController.text : null,
                    onSelect: (state) {
                      stateController.text = state!;
                      cityController.clear();
                      _loadCities();
                      return stateController.text;
                    },
                  ),
                  10.height,
                  if (availableCities.isNotEmpty)
                    CustomOutlinedDropdownField(
                      key: ValueKey("city_${stateController.text}_${cityController.text}_${availableCities.length}"),
                      label: "City",
                      values: availableCities,
                      value: cityController.text.isNotEmpty && availableCities.contains(cityController.text) ? cityController.text : null,
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
                      stateController.clear();
                      cityController.clear();
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
                        if (addressController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please enter your street address")));
                          return;
                        }
                        if (stateController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select your state")));
                          return;
                        }
                        if (cityController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select your city")));
                          return;
                        }
                        if (countryController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please select your country")));
                          return;
                        }
                        var provider = Provider.of<HomeViewModel>(context, listen: false);
                        final success = await provider.updateShippingAddress(
                          context: context,
                          location: LocationModel(
                            address: addressController.text.trim(),
                            city: cityController.text.trim(),
                            state: stateController.text.trim(),
                            country: countryController.text.trim(),
                          ),
                        );
                        if (success && mounted) {
                          Navigator.of(context).pop(true);
                        }
                      },
                    ),
                  ),
                  10.height,
                ],
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
    if (widget.value != null && widget.values.contains(widget.value)) {
      _selectedValue = widget.value;
    }
  }

  @override
  void didUpdateWidget(covariant CustomOutlinedDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value || widget.values != oldWidget.values) {
      setState(() {
        if (widget.value != null && widget.values.contains(widget.value)) {
          _selectedValue = widget.value;
        } else if (_selectedValue != null && widget.values.contains(_selectedValue)) {
          // retain current selection
        } else {
          _selectedValue = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final validValue = (widget.values.contains(_selectedValue)) ? _selectedValue : null;
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
          value: validValue,
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
