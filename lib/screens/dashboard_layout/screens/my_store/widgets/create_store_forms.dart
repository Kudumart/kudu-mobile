part of '../screen.dart';

class CreateStoreForms extends StatefulWidget {
  final GetStoreModel? store;
  const CreateStoreForms({
    super.key,
    this.store,
  });

  @override
  State<CreateStoreForms> createState() => _CreateStoreFormsState();
}

class _CreateStoreFormsState extends State<CreateStoreForms> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _businessHoursMFController = TextEditingController();
  final TextEditingController _businessHoursSATController = TextEditingController();
  final TextEditingController _businessHoursSUNController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();

  final List<TextEditingController> _cityControllers = [];
  final List<TextEditingController> _priceControllers = [];
  final List<TextEditingController> _arrivalTimeControllers = [];
  String? _selectedCurrency;
  String? _selectedName;
  final List<String> availableStates = ["Ontario", "Abuja", "New York"];
  final List<Map<String, dynamic>> _deliveryOptions = [];

  int _currentStep = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.store != null) {
        final Map<String, dynamic> locationMap = widget.store?.location?.toJson() ??
            json.decode("{\"address\":\"\",\"city\":\"\",\"state\":\"\",\"country\":\"\"}");

        final Map<String, dynamic> businessHoursMap = widget.store?.businessHours?.toJson() ??
            json.decode("{\"monday_friday\":\"\",\"saturday\":\"\",\"sunday\":\"\"}");

        final List<DeliveryOptionsModel> deliveryOptionsList = widget.store?.deliveryOptions ?? [];

        _selectedName = '${widget.store?.currency?.name} (${widget.store?.currency?.symbol})';
        _selectedCurrency = widget.store?.currency?.id;

        _storeNameController.text = widget.store?.name ?? '';
        _addressController.text = locationMap['address'] ?? '';
        _cityController.text = locationMap['city'] ?? '';
        _stateController.text = locationMap['state'] ?? '';
        _countryController.text = locationMap['country'] ?? '';

        _businessHoursMFController.text = businessHoursMap['monday_friday'] ?? '';
        _businessHoursSATController.text = businessHoursMap['saturday'] ?? '';
        _businessHoursSUNController.text = businessHoursMap['sunday'] ?? '';

        _tipController.text = widget.store?.tipsOnFinding ?? '';

        if (deliveryOptionsList.isNotEmpty) {
          for (var option in deliveryOptionsList) {
            final cityController = TextEditingController(text: option.city);
            final priceController = TextEditingController(text: option.price.toString());
            final arrivalTimeController = TextEditingController(text: option.arrivalDay);

            setState(() {
              _deliveryOptions.add(option.toJson());
              _cityControllers.add(cityController);
              _priceControllers.add(priceController);
              _arrivalTimeControllers.add(arrivalTimeController);
            });
          }
        }
        getAllStates();
      } else {
        _countryController.text = countries[1].name;
        // Default schedule preset
        _applySchedulePreset("standard");
        // Default 1 delivery option
        _addDeliveryOption();
        getAllStates();
      }
      var storeViewModel = Provider.of<StoreViewModel>(context, listen: false);
      storeViewModel.fetchCurrency(context);
    });

    _storeNameController.addListener(() {
      if (mounted) setState(() {});
    });
    _cityController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _applySchedulePreset(String preset) {
    setState(() {
      if (preset == "standard") {
        _businessHoursMFController.text = "9:00 AM - 6:00 PM";
        _businessHoursSATController.text = "10:00 AM - 4:00 PM";
        _businessHoursSUNController.text = "Closed";
      } else if (preset == "always") {
        _businessHoursMFController.text = "Open 24 Hours";
        _businessHoursSATController.text = "Open 24 Hours";
        _businessHoursSUNController.text = "Open 24 Hours";
      } else if (preset == "weekdays") {
        _businessHoursMFController.text = "8:00 AM - 5:00 PM";
        _businessHoursSATController.text = "Closed";
        _businessHoursSUNController.text = "Closed";
      }
    });
  }

  Future<void> getAllStates() async {
    String? isoCode;
    if (_countryController.text.isNotEmpty) {
      isoCode = countries
          .firstWhere((element) => element.name.trim() == _countryController.text.trim())
          .isoCode
          .name;
    }
    if (isoCode != null) {
      final states = await getStatesOfCountry(isoCode);
      if (states.isNotEmpty) {
        availableStates.clear();
        await Future.forEach(states, (s) {
          availableStates.add(s.name);
        });
        if (!availableStates.contains(_stateController.text.trim())) {
          _stateController.text = availableStates[0];
        }
        if (mounted) setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _businessHoursMFController.dispose();
    _businessHoursSATController.dispose();
    _businessHoursSUNController.dispose();
    _tipController.dispose();
    for (var controller in _cityControllers) {
      controller.dispose();
    }
    for (var controller in _priceControllers) {
      controller.dispose();
    }
    for (var controller in _arrivalTimeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addDeliveryOption() {
    setState(() {
      _deliveryOptions.add({});
      _cityControllers.add(TextEditingController());
      _priceControllers.add(TextEditingController());
      _arrivalTimeControllers.add(TextEditingController(text: "2-3 business days"));
    });
  }

  void _removeDeliveryOption(int index) {
    setState(() {
      _deliveryOptions.removeAt(index);
      _cityControllers[index].dispose();
      _priceControllers[index].dispose();
      _arrivalTimeControllers[index].dispose();
      _cityControllers.removeAt(index);
      _priceControllers.removeAt(index);
      _arrivalTimeControllers.removeAt(index);
    });
  }

  bool _validateStep(int step) {
    if (step == 0) {
      if (_storeNameController.text.trim().isEmpty) {
        AppUiOverlay().showErrorSnackbarMessage(context, message: "Please enter your store name");
        return false;
      }
      if (_selectedCurrency == null || _selectedCurrency!.isEmpty) {
        AppUiOverlay().showErrorSnackbarMessage(context, message: "Please select an operating currency");
        return false;
      }
      if (_tipController.text.trim().isEmpty) {
        AppUiOverlay().showErrorSnackbarMessage(context, message: "Please enter landmark & finding tips");
        return false;
      }
      return true;
    } else if (step == 1) {
      if (_countryController.text.trim().isEmpty) {
        AppUiOverlay().showErrorSnackbarMessage(context, message: "Please select your country");
        return false;
      }
      if (_cityController.text.trim().isEmpty) {
        AppUiOverlay().showErrorSnackbarMessage(context, message: "Please enter your city");
        return false;
      }
      if (_addressController.text.trim().isEmpty) {
        AppUiOverlay().showErrorSnackbarMessage(context, message: "Please enter your physical street address");
        return false;
      }
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(builder: (context, model, child) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppUiColor.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.storefront_rounded, color: AppUiColor.primary, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.store != null ? "Edit Store Profile" : "Create a New Store",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFECFDF5),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFA7F3D0)),
                                  ),
                                  child: const Text(
                                    "Vendor",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF065F46)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              "Launch your storefront on Kudumart to start receiving orders & offers.",
                              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Step Progress Indicator
                _buildStepperIndicator(),
                const SizedBox(height: 16),

                // Live Storefront Card (Matching Website)
                _buildLiveStorefrontPreview(),
                const SizedBox(height: 16),

                // Active Step Content
                if (_currentStep == 0) ...[
                  _buildStep1StoreProfile(model),
                ] else if (_currentStep == 1) ...[
                  _buildStep2Location(),
                ] else ...[
                  _buildStep3HoursAndDelivery(),
                ],

                const SizedBox(height: 16),

                // Merchant Checklist & Tips Guide (Matching Website)
                _buildMerchantChecklist(),

                const SizedBox(height: 24),

                // Wizard Navigation Buttons
                Row(
                  children: [
                    if (_currentStep > 0) ...[
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          text: "Back",
                          variant: AppButtonVariant.secondary,
                          icon: const Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF1F2937)),
                          onPressed: () {
                            setState(() => _currentStep--);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      flex: 2,
                      child: AppButton(
                        text: _currentStep < 2
                            ? (_currentStep == 0 ? "Next: Location Details ➔" : "Next: Hours & Delivery ➔")
                            : (widget.store != null ? "✓ Update Store" : "✓ Create My Store"),
                        variant: AppButtonVariant.primary,
                        isLoading: _isSubmitting,
                        onPressed: () {
                          if (_currentStep < 2) {
                            if (_validateStep(_currentStep)) {
                              setState(() => _currentStep++);
                            }
                          } else {
                            if (widget.store != null) {
                              _updateStore();
                            } else {
                              _createStore();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel & Go Back", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildStepperIndicator() {
    final steps = [
      {"title": "1. Profile", "subtitle": "Basics & Currency"},
      {"title": "2. Location", "subtitle": "Address & City"},
      {"title": "3. Logistics", "subtitle": "Hours & Delivery"},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = _currentStep == index;
          final isCompleted = _currentStep > index;

          return Expanded(
            child: InkWell(
              onTap: () {
                if (index < _currentStep || _validateStep(_currentStep)) {
                  setState(() => _currentStep = index);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : (isActive ? AppUiColor.primary : const Color(0xFFF3F4F6)),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                          : Text(
                              "${index + 1}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isActive ? Colors.white : const Color(0xFF6B7280),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[index]["title"]!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive ? AppUiColor.primary : (isCompleted ? const Color(0xFF111827) : const Color(0xFF9CA3AF)),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLiveStorefrontPreview() {
    final name = _storeNameController.text.trim();
    final initial = name.isNotEmpty ? name.substring(0, 1).toUpperCase() : "S";
    final location = _cityController.text.trim().isNotEmpty
        ? _cityController.text.trim()
        : (_stateController.text.trim().isNotEmpty ? _stateController.text.trim() : "Location Pending");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F2937), Color(0xFF111827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "STOREFRONT LIVE PREVIEW",
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF065F46),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF34D399)),
                    SizedBox(width: 4),
                    Text(
                      "Instant Listing",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppUiColor.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : "Your Store Brand Name",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 13, color: AppUiColor.primary),
                        const SizedBox(width: 3),
                        Text(
                          location,
                          style: const TextStyle(fontSize: 12, color: Color(0xFFD1D5DB)),
                        ),
                        if (_selectedName != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            "• $_selectedName",
                            style: const TextStyle(fontSize: 11.5, color: Color(0xFF9CA3AF)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantChecklist() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 18, color: AppUiColor.primary),
              SizedBox(width: 8),
              Text(
                "Vendor Onboarding Tips",
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildChecklistItem("Clear brand name helps build buyer recognition and trust."),
          const SizedBox(height: 6),
          _buildChecklistItem("Accurate landmark directions prevent dispatch delays and missed deliveries."),
          const SizedBox(height: 6),
          _buildChecklistItem("Transparent city shipping fees increase order completion rate by 40%."),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline_rounded, size: 15, color: Color(0xFF10B981)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563), height: 1.3),
          ),
        ),
      ],
    );
  }

  // STEP 1: Store Basics
  Widget _buildStep1StoreProfile(StoreViewModel model) {
    return _buildSectionCard(
      title: "Store Profile & Identity",
      subtitle: "Provide the fundamental brand name and trading currency of your shop",
      icon: Icons.badge_outlined,
      children: [
        _CustomOutlinedTextField(
          label: "Store Name *",
          validator: InputValidator.validateValidInput,
          hint: "e.g. Crown Gadgets & Tech Hub",
          controller: _storeNameController,
        ),
        const SizedBox(height: 4),
        const Text(
          "This name will be displayed on all your product listings and vendor storefront.",
          style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 16),
        CustomCurrencyDropdownField(
          label: "Operating Currency *",
          values: model.currencies ?? [],
          hint: Text(_selectedName ?? 'Select store currency (e.g. NGN ₦, USD \$, GBP £)'),
          onSelect: (selectedCurrency) {
            if (selectedCurrency != null) {
              setState(() {
                _selectedCurrency = selectedCurrency.id;
                _selectedName = '${selectedCurrency.name} (${selectedCurrency.symbol})';
              });
            }
          },
        ),
        const SizedBox(height: 4),
        const Text(
          "All your listed product prices and customer payouts will be processed in this currency.",
          style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 16),
        _CustomOutlinedTextField(
          label: "Landmark & Directions *",
          validator: InputValidator.validateValidInput,
          hint: "e.g. Suite 12, 2nd Floor, Opposite Zenith Bank Plaza",
          maxLines: 3,
          controller: _tipController,
        ),
        const SizedBox(height: 4),
        const Text(
          "Helpful landmark instructions so buyers or courier dispatch riders can easily locate your store.",
          style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  // STEP 2: Location
  Widget _buildStep2Location() {
    return _buildSectionCard(
      title: "Physical Location & Address",
      subtitle: "Where your store is registered and operates from",
      icon: Icons.location_on_outlined,
      children: [
        ValueListenableBuilder(
          valueListenable: _countryController,
          builder: (_, __, ___) {
            return CustomOutlinedDropdownField(
              key: ValueKey(_countryController.text),
              label: "Country *",
              values: countries.map((e) => e.name).toList(),
              value: _countryController.text.isNotEmpty ? _countryController.text : null,
              onSelect: (country) {
                _countryController.text = country ?? "";
                getAllStates();
                return _countryController.text = country ?? "";
              },
            );
          },
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: _stateController,
          builder: (_, __, ___) {
            return CustomOutlinedDropdownField(
              key: ValueKey(_stateController.text),
              label: "State / Province *",
              values: availableStates,
              value: _stateController.text.isNotEmpty ? _stateController.text : null,
              onSelect: (state) {
                return _stateController.text = state!;
              },
            );
          },
        ),
        const SizedBox(height: 16),
        _CustomOutlinedTextField(
          label: "City *",
          validator: InputValidator.validateValidInput,
          hint: "e.g. Ikeja, Lekki, or Manchester",
          controller: _cityController,
        ),
        const SizedBox(height: 16),
        _CustomOutlinedTextField(
          label: "Street Address *",
          validator: InputValidator.validateValidInput,
          hint: "e.g. 45 Commercial Avenue, Suite 4B",
          controller: _addressController,
        ),
      ],
    );
  }

  // STEP 3: Business Hours & Delivery
  Widget _buildStep3HoursAndDelivery() {
    return Column(
      children: [
        _buildSectionCard(
          title: "Operating Schedule",
          subtitle: "Set when your store is open for pickups and inquiries",
          icon: Icons.access_time_rounded,
          children: [
            const Text(
              "Quick Schedule Presets (Tap to apply):",
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPresetChip("Standard (9AM-6PM)", () => _applySchedulePreset("standard")),
                _buildPresetChip("Open 24/7", () => _applySchedulePreset("always")),
                _buildPresetChip("Weekdays Only", () => _applySchedulePreset("weekdays")),
              ],
            ),
            const SizedBox(height: 16),
            _CustomOutlinedTextField(
              label: "Monday - Friday",
              validator: InputValidator.validateValidInput,
              hint: "e.g. 9:00 AM - 6:00 PM",
              controller: _businessHoursMFController,
            ),
            const SizedBox(height: 14),
            _CustomOutlinedTextField(
              label: "Saturday",
              validator: InputValidator.validateValidInput,
              hint: "e.g. 10:00 AM - 4:00 PM or Closed",
              controller: _businessHoursSATController,
            ),
            const SizedBox(height: 14),
            _CustomOutlinedTextField(
              label: "Sunday",
              validator: InputValidator.validateValidInput,
              hint: "e.g. Closed or 1:00 PM - 5:00 PM",
              controller: _businessHoursSUNController,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: "Delivery Options & Shipping Rates",
          subtitle: "Configure delivery pricing and estimated timeline for customer orders",
          icon: Icons.local_shipping_outlined,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _deliveryOptions.length,
              itemBuilder: (context, index) {
                return _buildDeliveryOptionCard(index);
              },
            ),
            const SizedBox(height: 8),
            AppButton(
              onPressed: _addDeliveryOption,
              text: "+ Add City Delivery Option",
              variant: AppButtonVariant.outline,
              icon: const Icon(Icons.add_rounded, size: 18, color: Color(0xFF374151)),
              isFullWidth: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFFEDD5)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFFC2410C)),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppUiColor.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDeliveryOptionCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppUiColor.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppUiColor.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Delivery Zone ${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF374151)),
                  ),
                ],
              ),
              if (_deliveryOptions.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                  onPressed: () => _removeDeliveryOption(index),
                  tooltip: "Remove Option",
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _CustomOutlinedTextField(
            label: "Delivery City / State *",
            validator: InputValidator.validateValidInput,
            hint: "e.g. Lagos, Abuja, London",
            controller: _cityControllers[index],
          ),
          const SizedBox(height: 12),
          _CustomOutlinedTextField(
            label: "Delivery Fee (Numeric) *",
            validator: InputValidator.validateValidInput,
            hint: "e.g. 2500",
            keyboardType: TextInputType.number,
            controller: _priceControllers[index],
          ),
          const SizedBox(height: 12),
          _CustomOutlinedTextField(
            label: "Estimated Arrival Time *",
            validator: InputValidator.validateValidInput,
            hint: "e.g. 2-3 business days",
            controller: _arrivalTimeControllers[index],
          ),
        ],
      ),
    );
  }

  _createStore() async {
    if (!_validateStep(0) || !_validateStep(1)) return;

    setState(() => _isSubmitting = true);
    try {
      for (int i = 0; i < _deliveryOptions.length; i++) {
        _deliveryOptions[i] = {
          "city": _cityControllers[i].text,
          "price": int.tryParse(_priceControllers[i].text) ?? 0,
          "arrival_day": _arrivalTimeControllers[i].text,
        };
      }

      var response = await Provider.of<StoreViewModel>(context, listen: false).createStore(
        context: context,
        storeName: _storeNameController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        country: _countryController.text.trim(),
        businessHoursMF: _businessHoursMFController.text.trim(),
        businessHoursSAT: _businessHoursSATController.text.trim(),
        businessHoursSUN: _businessHoursSUNController.text.trim(),
        currencyId: _selectedCurrency!,
        deliveryOption: _deliveryOptions,
        tipsOnFinding: _tipController.text.trim(),
      );
      if (response && mounted) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Store created successfully!");
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        AppUiOverlay().showErrorSnackbarMessage(context, message: "Error creating store. Please try again.");
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _updateStore() async {
    if (!_validateStep(0) || !_validateStep(1)) return;

    setState(() => _isSubmitting = true);
    try {
      for (int i = 0; i < _deliveryOptions.length; i++) {
        _deliveryOptions[i] = {
          "city": _cityControllers[i].text,
          "price": int.tryParse(_priceControllers[i].text) ?? 0,
          "arrival_day": _arrivalTimeControllers[i].text,
        };
      }

      await Provider.of<StoreViewModel>(context, listen: false).updateStore(
        context: context,
        storeId: widget.store!.id!,
        storeName: _storeNameController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        country: _countryController.text.trim(),
        businessHoursMF: _businessHoursMFController.text.trim(),
        businessHoursSAT: _businessHoursSATController.text.trim(),
        businessHoursSUN: _businessHoursSUNController.text.trim(),
        currencyId: _selectedCurrency!,
        deliveryOption: _deliveryOptions,
        tipsOnFinding: _tipController.text.trim(),
        logo: widget.store!.logo ?? "",
      );
      if (mounted) {
        AppUiOverlay().showSuccessSnackbarMessage(context, message: "Store updated successfully!");
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        AppUiOverlay().showErrorSnackbarMessage(context, message: "Error updating store. Please try again.");
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
