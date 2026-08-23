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
  final TextEditingController _businessHoursMFController =
      TextEditingController();
  final TextEditingController _businessHoursSATController =
      TextEditingController();
  final TextEditingController _businessHoursSUNController =
      TextEditingController();
  final TextEditingController _tipController = TextEditingController();

  final List<TextEditingController> _cityControllers = [];
  final List<TextEditingController> _priceControllers = [];
  final List<TextEditingController> _arrivalTimeControllers = [];
  String? _selectedCurrency;
  String? _selectedName;
  final List<String> availableStates = ["Ontario", "Abuja", "New York"];

  @override
  void initState() {
    super.initState();

    // Parse the store data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.store != null) {
        // Parse location JSON
        final Map<String, dynamic> locationMap = widget.store?.location?.toJson() ?? json.decode("{\"address\":\"\",\"city\":\"\",\"state\":\"\",\"country\":\"\"}");

        // Parse business hours JSON
        final Map<String, dynamic> businessHoursMap = widget.store?.businessHours?.toJson() ?? json.decode("{\"monday_friday\":\"\",\"saturday\":\"\",\"sunday\":\"\"}");

        // Parse delivery options JSON
        final List<DeliveryOptionsModel> deliveryOptionsList = widget.store?.deliveryOptions ?? [];

        // Set currency
        _selectedName =
        '${widget.store?.currency?.name} ${widget.store?.currency?.symbol}';

        _selectedCurrency = widget.store?.currency?.id;

        // Set basic store information
        _storeNameController.text = widget.store?.name ?? '';
        _addressController.text = locationMap['address'] ?? '';
        _cityController.text = locationMap['city'] ?? '';
        _stateController.text = locationMap['state'] ?? '';
        _countryController.text = locationMap['country'] ?? '';

        // Set business hours
        _businessHoursMFController.text = businessHoursMap['monday_friday'] ?? '';
        _businessHoursSATController.text = businessHoursMap['saturday'] ?? '';
        _businessHoursSUNController.text = businessHoursMap['sunday'] ?? '';

        // Set tips on finding
        _tipController.text = widget.store?.tipsOnFinding ?? '';

        // Set delivery options
        if (deliveryOptionsList.isNotEmpty) {
          for (var option in deliveryOptionsList) {
            final cityController = TextEditingController(text: option.city);
            final priceController =
            TextEditingController(text: option.price.toString());
            final arrivalTimeController =
            TextEditingController(text: option.arrivalDay);

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
        getAllStates();
      }
      var storeViewModel = Provider.of<StoreViewModel>(context, listen: false);
      storeViewModel.fetchCurrency(context);
    });
  }

  Future<void> getAllStates() async {
    String? isoCode;
    if(_countryController.text.isNotEmpty){
      isoCode = countries.firstWhere((element) => element.name.trim() == _countryController.text.trim()).isoCode.name;
    }
    if(isoCode != null){
      final states = await getStatesOfCountry(isoCode);
      if(states.isNotEmpty){
        availableStates.clear();
        await Future.forEach(states, (s){
          availableStates.add(s.name);
        });
        if(!availableStates.contains(_stateController.text.trim())){
          _stateController.text = availableStates[0];
        }
        if(mounted){
          setState(() {

          });
        }
      }
    }
  }

  @override
  void dispose() {
    // Dispose of the existing controllers...
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

  // Modify your _addDeliveryOption method
  void _addDeliveryOption() {
    setState(() {
      _deliveryOptions.add({});
      _cityControllers.add(TextEditingController());
      _priceControllers.add(TextEditingController());
      _arrivalTimeControllers.add(TextEditingController());
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

  final List<Map<String, dynamic>> _deliveryOptions = [];

  CurrencyData? convertToCurrencyData(Currency? currency) {
    if (currency == null) return null;
    return CurrencyData(
      id: currency.id ?? '',
      name: currency.name ?? '',
      symbol: currency.symbol ?? '',
      createdAt: currency.createdAt ?? DateTime.now(),
      updatedAt: currency.updatedAt ?? DateTime.now(),
      // Add other required fields from your CurrencyData model
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(builder: (context, model, child) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Create Your Store",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Provide the details below to list a new store",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // Card 1: Store Information
                _buildSectionCard(
                  title: "Store Information",
                  children: [
                    _CustomOutlinedTextField(
                      label: "Store Name",
                      validator: InputValidator.validateValidInput,
                      hint: "Enter your store name",
                      controller: _storeNameController,
                    ),
                    const SizedBox(height: 16),
                    CustomCurrencyDropdownField(
                      label: "Store Currency",
                      values: model.currencies ?? [],
                      hint: Text(_selectedName ?? 'Tap to select currency'),
                      onSelect: (selectedCurrency) {
                        if (selectedCurrency != null) {
                          setState(() {
                            _selectedCurrency = selectedCurrency.id;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _CustomOutlinedTextField(
                      label: "Tips on Finding Store",
                      validator: InputValidator.validateValidInput,
                      hint: "e.g., Opposite the main bank building",
                      maxLines: 3,
                      controller: _tipController,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Card 2: Location
                _buildSectionCard(
                  title: "Location Details",
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _countryController,
                      builder: (_,__,___) {
                        return CustomOutlinedDropdownField(
                          key: ValueKey(_countryController.text),
                          label: "Country",
                          values: countries.map((e) => e.name).toList(),
                          value: _countryController.text.isNotEmpty ? _countryController.text : null,
                          onSelect: (country) {
                            _countryController.text = country ?? "";
                            getAllStates();
                            return _countryController.text = country ?? "";
                          },
                        );
                      }
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                        valueListenable: _stateController,
                        builder: (_,__,___) {
                        return CustomOutlinedDropdownField(
                          key: ValueKey(_stateController.text),
                          label: "State",
                          values: availableStates,
                          value: _stateController.text.isNotEmpty ? _stateController.text : null,
                          onSelect: (state) {
                            return _stateController.text = state!;
                          },
                        );
                      }
                    ),
                    const SizedBox(height: 16),
                    _CustomOutlinedTextField(
                      label: "City",
                      validator: InputValidator.validateValidInput,
                      hint: "Enter your city",
                      controller: _cityController,
                    ),
                    const SizedBox(height: 16),
                    _CustomOutlinedTextField(
                      label: "Address",
                      validator: InputValidator.validateValidInput,
                      hint: "Enter your full address",
                      controller: _addressController,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Card 3: Business Hours
                _buildSectionCard(
                  title: "Business Hours",
                  children: [
                    _CustomOutlinedTextField(
                      label: "Monday - Friday",
                      validator: InputValidator.validateValidInput,
                      hint: "e.g., 9am - 6pm",
                      controller: _businessHoursMFController,
                    ),
                    const SizedBox(height: 16),
                    _CustomOutlinedTextField(
                      label: "Saturday",
                      validator: InputValidator.validateValidInput,
                      hint: "e.g., 10am - 4pm",
                      controller: _businessHoursSATController,
                    ),
                    const SizedBox(height: 16),
                    _CustomOutlinedTextField(
                      label: "Sunday",
                      validator: InputValidator.validateValidInput,
                      hint: "e.g., Closed",
                      controller: _businessHoursSUNController,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Card 4: Delivery Options
                _buildSectionCard(
                  title: "Delivery Options",
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
                      text: "+ Add Delivery Option",
                      variant: AppButtonVariant.outline,
                      isFullWidth: true,
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Action Buttons
                AppButton(
                  onPressed: widget.store != null ? _updateStore : _createStore,
                  text: widget.store != null ? "Update Store" : "Create Store",
                  isFullWidth: true,
                ),
                const SizedBox(height: 12),
                AppButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: "Cancel",
                  variant: AppButtonVariant.text,
                  isFullWidth: true,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDeliveryOptionCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Option ${index + 1}",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _removeDeliveryOption(index),
                tooltip: "Remove Option",
              ),
            ],
          ),
          const SizedBox(height: 8),
          _CustomOutlinedTextField(
            label: "City",
            validator: InputValidator.validateValidInput,
            hint: "Enter delivery city",
            controller: _cityControllers[index],
          ),
          const SizedBox(height: 12),
          _CustomOutlinedTextField(
            label: "Price",
            validator: InputValidator.validateValidInput,
            hint: "Enter delivery price",
            controller: _priceControllers[index],
          ),
          const SizedBox(height: 12),
          _CustomOutlinedTextField(
            label: "Arrival Time",
            validator: InputValidator.validateValidInput,
            hint: "e.g., 2-3 days",
            controller: _arrivalTimeControllers[index],
          ),
        ],
      ),
    );
  }

  _createStore() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
        storeName: _storeNameController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        country: _countryController.text,
        businessHoursMF: _businessHoursMFController.text,
        businessHoursSAT: _businessHoursSATController.text,
        businessHoursSUN: _businessHoursSUNController.text,
        currencyId: _selectedCurrency!,
        deliveryOption: _deliveryOptions,
        tipsOnFinding: _tipController.text,
      );
      if(response){
        Navigator.of(context).pop();
      }
    } catch (e, x) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error creating store. Please try again.")),
      );
    }
  }

  void _updateStore() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      for (int i = 0; i < _deliveryOptions.length; i++) {
        _deliveryOptions[i] = {
          "city": _cityControllers[i].text,
          "price": int.tryParse(_priceControllers[i].text) ?? 0,
          "arrival_day": _arrivalTimeControllers[i].text,
        };
      }

      Provider.of<StoreViewModel>(context, listen: false).updateStore(
        context: context,
        storeId: widget.store!.id!,
        storeName: _storeNameController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        country: _countryController.text,
        businessHoursMF: _businessHoursMFController.text,
        businessHoursSAT: _businessHoursSATController.text,
        businessHoursSUN: _businessHoursSUNController.text,
        currencyId: _selectedCurrency!,
        deliveryOption: _deliveryOptions,
        tipsOnFinding: _tipController.text,
        logo: widget.store!.logo!,
      );
    } catch (e, x) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error updating store. Please try again."),
        ),
      );
    }
  }
}
