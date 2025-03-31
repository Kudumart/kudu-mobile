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
        padding: const EdgeInsets.fromLTRB(18, 60, 18, 10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Your Store",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 38),
                _CustomOutlinedTextField(
                  label: "Store Name",
                  validator: InputValidator.validateValidInput,
                  hint: "Enter your store name",
                  controller: _storeNameController,
                ),
                const SizedBox(height: 20),

                // Location Section
                const Text("Location",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _CustomOutlinedTextField(
                  label: "Address",
                  validator: InputValidator.validateValidInput,
                  hint: "Enter your address",
                  controller: _addressController,
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                _CustomOutlinedTextField(
                  label: "City",
                  validator: InputValidator.validateValidInput,
                  hint: "Enter your city",
                  controller: _cityController,
                ),

                // Business Hours Section
                const SizedBox(height: 30),
                const Text("Business Hours",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                _CustomOutlinedTextField(
                  label: "Monday - Friday",
                  validator: InputValidator.validateValidInput,
                  hint: "e.g., 9am - 6pm",
                  controller: _businessHoursMFController,
                ),
                const SizedBox(height: 20),
                _CustomOutlinedTextField(
                  label: "Saturday",
                  validator: InputValidator.validateValidInput,
                  hint: "e.g., 10am - 4pm",
                  controller: _businessHoursSATController,
                ),
                const SizedBox(height: 20),
                _CustomOutlinedTextField(
                  label: "Sunday",
                  validator: InputValidator.validateValidInput,
                  hint: "e.g., closed",
                  controller: _businessHoursSUNController,
                ),
                const SizedBox(height: 30),
                const Text("Store Currency",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                CustomCurrencyDropdownField(
                  label: "Currency",
                  values: model.currencies ?? [],
                  hint: Text(_selectedName ?? 'Tap to select currency'),
                  // initialValue: convertToCurrencyData(widget.store?.currency),
                  onSelect: (selectedCurrency) {
                    if (selectedCurrency != null) {
                      setState(() {
                        _selectedCurrency = selectedCurrency.id;
                      });
                    }
                  },
                ),
                // Delivery Options Section
                const SizedBox(height: 30),
                const Text("Delivery Options",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _deliveryOptions.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _deliveryOptions.length) {
                      return TextButton(
                        onPressed: _addDeliveryOption,
                        child: const Text("+ Add Delivery Option"),
                      );
                    }
                    return _buildDeliveryOptionCard(index);
                  },
                ),

                // Store Finding Tips
                const SizedBox(height: 20),
                _CustomOutlinedTextField(
                  label: "Tips on Finding Store",
                  validator: InputValidator.validateValidInput,
                  hint: "Enter tips to help customers find your store",
                  maxLines: 3,
                  controller: _tipController,
                ),

                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: widget.store != null ? _updateStore : _createStore,
                    child: Text(widget.store != null ? "Update Store" : "Create Store"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDeliveryOptionCard(int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _CustomOutlinedTextField(
              label: "City",
              validator: InputValidator.validateValidInput,
              hint: "Enter delivery city",
              controller: _cityControllers[index],
            ),
            const SizedBox(height: 10),
            _CustomOutlinedTextField(
              label: "Price",
              validator: InputValidator.validateValidInput,
              hint: "Enter delivery price",
              controller: _priceControllers[index],
            ),
            const SizedBox(height: 10),
            _CustomOutlinedTextField(
              label: "Arrival Time",
              validator: InputValidator.validateValidInput,
              hint: "e.g., 5 working days",
              controller: _arrivalTimeControllers[index],
            ),
            TextButton(
              onPressed: () => _removeDeliveryOption(index),
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
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
