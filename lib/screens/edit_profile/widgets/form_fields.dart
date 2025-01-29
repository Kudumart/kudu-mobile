part of '../screen.dart';

class _FormFields extends StatefulWidget {
  final UserData userProfile;
  const _FormFields(this.userProfile);

  @override
  State<_FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<_FormFields> {
  late UserData _userProfile;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String _selectedCountry = '';
  String _selectedState = '';
  String _selectedCity = '';
  String? _selectedDate;
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    _userProfile = widget.userProfile;

    if (_userProfile != null) {
      _firstNameController.text = _userProfile.firstName!;
      _lastNameController.text = _userProfile.lastName!;
      _emailController.text = _userProfile.email!;
      _phoneNumberController.text = _userProfile.phoneNumber!;
      _selectedDate = _userProfile.dateOfBirth;
      _selectedGender = _userProfile.gender ?? 'Male';
    }
    if (_userProfile.location != null) {
      try {
        Map<String, dynamic> locationMap = jsonDecode(_userProfile.location!);
        _selectedCountry = locationMap['country'] ?? '';
        _selectedState = locationMap['state'] ?? '';
        _selectedCity = locationMap['city'] ?? '';
      } catch (e) {
        print('Error parsing location: $e');
      }
      print(_selectedCountry);
    }
  }

  void _handleDateSelection(String date) {
    setState(() {
      _selectedDate = date;
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Not selected";

    try {
      final DateTime parsedDate = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldTitle(name: "First Name"),
                    const SizedBox(height: 5),
                    _CustomTextFormField(
                      hint: 'John',
                      controller: _firstNameController,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldTitle(name: "Last Name"),
                    const SizedBox(height: 5),
                    _CustomTextFormField(
                      hint: 'Doe',
                      controller: _lastNameController,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          const _FieldTitle(name: "Date of Birth"),
          const SizedBox(height: 5),
          // _DoBView(_userProfile.dateOfBirth),
          _DoBView(
            _selectedDate,
            onDateSelected: _handleDateSelection,
          ),
          const SizedBox(height: 23),

          // Custom styled location picker
          _StyledLocationPicker(
            selectedCountry: _selectedCountry,
            selectedState: _selectedState,
            selectedCity: _selectedCity,
            onCountryChanged: (value) =>
                setState(() => _selectedCountry = value),
            onStateChanged: (value) => setState(() => _selectedState = value),
            onCityChanged: (value) => setState(() => _selectedCity = value),
          ),
          const SizedBox(height: 23),
          const _FieldTitle(name: "Gender"),
          const SizedBox(height: 5),
          _GenderSelector(
            selectedGender: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),

          const SizedBox(height: 23),

          ElevatedButton(
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.resolveWith<Size>(
                  (_) => const Size(double.infinity, 49)),
              shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) =>
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35))),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Provider.of<ProfileViewModel>(context, listen: false)
                    .updateProfile(
                  context: context,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  dateOfBirth: _formatDate(_selectedDate),
                  gender: _selectedGender,
                  country: _selectedCountry,
                  state: _selectedState,
                  city: _selectedCity,
                );
                // print('Form Data:');
                // print('First Name: ${_firstNameController.text}');
                // print('Last Name: ${_lastNameController.text}');
                // print('Date of Birth: ${_formatDate(_selectedDate)}');
                // print('Country: $_selectedCountry');
                // print('State: $_selectedState');
                // print('City: $_selectedCity');
                // print('Email: ${_emailController.text}');
                // print('Phone: ${_phoneNumberController.text}');
              }
            },
            child: const Text(
              "Update",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 23),
          const Divider(),
          const SizedBox(height: 23),
          const _FieldTitle(name: "Email Address"),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: _CustomTextFormField(
                  hint: 'email',
                  enabled: false,
                  controller: _emailController,
                ),
              ),
              IconButton(
                onPressed: () {
                  const NewEmailScreenRoute().push(context);
                },
                icon: const Icon(
                  Icons.edit,
                ),
              )
            ],
          ),
          const SizedBox(height: 23),
          const _FieldTitle(name: "Phone Number"),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: IntlPhoneNumberField(
                  enabled: false,
                  initialCompletePhoneNumber: _userProfile.phoneNumber,
                  onSaved: (input) {},
                ),
              ),
              IconButton(
                onPressed: () {
                  const NewPhoneNumberRoute().push(context);
                },
                icon: const Icon(
                  Icons.edit,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
// fetch() {
//   // if(!isLoading){
//   fullNameController.text = AppUtils().capitalize(
//       '${Provider.of<ProfileProvider>(context, listen: false).firstName} ${Provider.of<ProfileProvider>(context, listen: false).lastName}');
//   phoneNumberController.text =
//       Provider.of<ProfileProvider>(context, listen: false).phoneNumber ?? '';
//   userNameController.text = AppUtils().capitalize(
//       '${Provider.of<ProfileProvider>(context, listen: false).userName}');
//   emailController.text =
//       Provider.of<ProfileProvider>(context, listen: false).email ?? '';
//   // }
// }

class _FieldTitle extends StatelessWidget {
  final String name;
  const _FieldTitle({required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }
}

class _StyledLocationPicker extends StatelessWidget {
  final String selectedCountry;
  final String selectedState;
  final String selectedCity;
  final Function(String) onCountryChanged;
  final Function(String) onStateChanged;
  final Function(String) onCityChanged;

  const _StyledLocationPicker({
    required this.selectedCountry,
    required this.selectedState,
    required this.selectedCity,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
  });

  void _showStatePickerDialog(BuildContext context) {
    if (selectedCountry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a country first')),
      );
      return;
    }

    final states = statesByCountry[selectedCountry] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _LocationPickerDialog(
          title: 'Select State',
          items: states,
          selectedItem: selectedState,
          onSelected: (state) {
            onStateChanged(state);
            onCityChanged(''); // Reset city when state changes
            Navigator.pop(context);
          },
          searchHint: 'Search state',
        );
      },
    );
  }

  void _showCityPickerDialog(BuildContext context) {
    if (selectedState.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a state first')),
      );
      return;
    }

    final cities = citiesByState[selectedState]?['cities'] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _LocationPickerDialog(
          title: 'Select City',
          items: cities,
          selectedItem: selectedCity,
          onSelected: (city) {
            onCityChanged(city);
            Navigator.pop(context);
          },
          searchHint: 'Search city',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldTitle(name: "Location"),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: AppUiColor.buttonFillGrey200,
            borderRadius: BorderRadius.circular(9.0),
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            children: [
              _LocationField(
                title: "Country",
                value: selectedCountry,
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    countryListTheme: CountryListThemeData(
                      borderRadius: BorderRadius.circular(9.0),
                      inputDecoration: InputDecoration(
                        hintText: 'Search country',
                        filled: true,
                        fillColor: AppUiColor.buttonFillGrey200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFE5E5E5)),
                        ),
                      ),
                    ),
                    onSelect: (country) {
                      onCountryChanged(country.name);
                      onStateChanged(''); // Reset state when country changes
                      onCityChanged(''); // Reset city when country changes
                    },
                  );
                },
              ),
              const Divider(height: 1),
              _LocationField(
                title: "State",
                value: selectedState,
                onTap: () => _showStatePickerDialog(context),
              ),
              const Divider(height: 1),
              _LocationField(
                title: "City",
                value: selectedCity,
                onTap: () => _showCityPickerDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LocationPickerDialog extends StatefulWidget {
  final String title;
  final List<String> items;
  final String selectedItem;
  final Function(String) onSelected;
  final String searchHint;

  const _LocationPickerDialog({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    required this.searchHint,
  });

  @override
  State<_LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<_LocationPickerDialog> {
  late TextEditingController _searchController;
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9.0),
                ),
              ),
              onChanged: _filterItems,
            ),
            const SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return ListTile(
                    title: Text(item),
                    selected: item == widget.selectedItem,
                    onTap: () => widget.onSelected(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _LocationField extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _LocationField({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value.isEmpty ? 'Select $title' : value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: value.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to make TextField styling consistent
extension TextFieldStyling on TextField {
  TextField styled() {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        constraints: const BoxConstraints(minHeight: 47, maxHeight: 67),
        filled: true,
        fillColor: AppUiColor.buttonFillGrey200,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.0),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final Function(String) onChanged;

  const _GenderSelector({
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppUiColor.buttonFillGrey200,
        borderRadius: BorderRadius.circular(9.0),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: RadioListTile<String>(
              title: const Text(
                'Male',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: 'Male',
              groupValue: selectedGender,
              onChanged: (value) => onChanged(value!),
              activeColor: AppUiColor.primary,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          Expanded(
            child: RadioListTile<String>(
              title: const Text(
                'Female',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: 'Female',
              groupValue: selectedGender,
              onChanged: (value) => onChanged(value!),
              activeColor: AppUiColor.primary,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          Expanded(
            child: RadioListTile<String>(
              title: const Text(
                'Other',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: 'Other',
              groupValue: selectedGender,
              onChanged: (value) => onChanged(value!),
              activeColor: AppUiColor.primary,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}


// class _FormFields extends StatefulWidget {
//   final UserData userProfile;
//   const _FormFields(this.userProfile);

//   @override
//   State<_FormFields> createState() => _FormFieldsState();
// }

// class _FormFieldsState extends State<_FormFields> {
//   late UserData _userProfile;

//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   String _selectedCountry = '';
//   String _selectedState = '';
//   String _selectedCity = '';
//   String? _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     _userProfile = widget.userProfile;

//     if (_userProfile != null) {
//       _firstNameController.text = _userProfile.firstName!;
//       _lastNameController.text = _userProfile.lastName!;
//       _emailController.text = _userProfile.email!;
//       _phoneNumberController.text = _userProfile.phoneNumber!;
//       _selectedDate = _userProfile.dateOfBirth;
//     }
//     //  if (_userProfile.country != null) {
//     //   _selectedCountry = _userProfile.country!;
//     //   _selectedState = _userProfile.state ?? '';
//     //   _selectedCity = _userProfile.city ?? '';
//     // }
//   }

//   void _handleDateSelection(String date) {
//     setState(() {
//       _selectedDate = date;
//     });
//   }

//   String _formatDate(String? dateStr) {
//     if (dateStr == null || dateStr.isEmpty) return "Not selected";

//     try {
//       final DateTime parsedDate = DateTime.parse(dateStr);
//       return DateFormat('dd-MM-yyyy').format(parsedDate);
//     } catch (e) {
//       return dateStr;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Flexible(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const _FieldTitle(name: "First Name"),
//                     const SizedBox(height: 5),
//                     _CustomTextFormField(
//                       hint: 'John',
//                       controller: _firstNameController,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Flexible(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const _FieldTitle(name: "Last Name"),
//                     const SizedBox(height: 5),
//                     _CustomTextFormField(
//                       hint: 'Doe',
//                       controller: _lastNameController,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 23),
//           const _FieldTitle(name: "Date of Birth"),
//           const SizedBox(height: 5),
//           // _DoBView(_userProfile.dateOfBirth),
//           _DoBView(
//             _selectedDate,
//             onDateSelected: _handleDateSelection,
//           ),
//           const SizedBox(height: 23),

//           // Custom styled location picker
//           _StyledLocationPicker(
//             selectedCountry: _selectedCountry,
//             selectedState: _selectedState,
//             selectedCity: _selectedCity,
//             onCountryChanged: (value) =>
//                 setState(() => _selectedCountry = value),
//             onStateChanged: (value) => setState(() => _selectedState = value),
//             onCityChanged: (value) => setState(() => _selectedCity = value),
//           ),

//           const SizedBox(height: 23),

//           ElevatedButton(
//             style: ButtonStyle(
//               minimumSize: WidgetStateProperty.resolveWith<Size>(
//                   (_) => const Size(double.infinity, 49)),
//               shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) =>
//                   RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(35))),
//             ),
//             onPressed: () {
//               if (_formKey.currentState!.validate()) {
//                 Provider.of<ProfileViewModel>(context, listen: false)
//                     .updateProfile(
//                   context: context,
//                   firstName: _firstNameController.text,
//                   lastName: _lastNameController.text,
//                   dateOfBirth: _formatDate(_selectedDate),
//                   gender: _selectedCountry,
//                   country: _selectedCountry,
//                   state: _selectedState,
//                   city: _selectedCity,
//                 );
//                 print('Form Data:');
//                 print('First Name: ${_firstNameController.text}');
//                 print('Last Name: ${_lastNameController.text}');
//                 print('Date of Birth: ${_formatDate(_selectedDate)}');
//                 print('Country: $_selectedCountry');
//                 print('State: $_selectedState');
//                 print('City: $_selectedCity');
//                 print('Email: ${_emailController.text}');
//                 print('Phone: ${_phoneNumberController.text}');
//               }
//             },
//             child: const Text(
//               "Update",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//           const SizedBox(height: 23),
//           Divider(),
//           const SizedBox(height: 23),
//           const _FieldTitle(name: "Email Address"),
//           const SizedBox(height: 5),
//           _CustomTextFormField(
//             hint: 'email',
//             controller: _emailController,
//           ),
//           const SizedBox(height: 23),
//           const _FieldTitle(name: "Phone Number"),
//           const SizedBox(height: 5),
//           _IntlPhoneNumberField(
//             initialCompletePhoneNumber: _userProfile.phoneNumber,
//             onSaved: (input) {},
//           ),
//         ],
//       ),
//     );
//   }
// }
// // fetch() {
// //   // if(!isLoading){
// //   fullNameController.text = AppUtils().capitalize(
// //       '${Provider.of<ProfileProvider>(context, listen: false).firstName} ${Provider.of<ProfileProvider>(context, listen: false).lastName}');
// //   phoneNumberController.text =
// //       Provider.of<ProfileProvider>(context, listen: false).phoneNumber ?? '';
// //   userNameController.text = AppUtils().capitalize(
// //       '${Provider.of<ProfileProvider>(context, listen: false).userName}');
// //   emailController.text =
// //       Provider.of<ProfileProvider>(context, listen: false).email ?? '';
// //   // }
// // }

// class _FieldTitle extends StatelessWidget {
//   final String name;
//   const _FieldTitle({required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       name,
//       style: const TextStyle(
//           fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
//     );
//   }
// }

// class _StyledLocationPicker extends StatelessWidget {
//   final String selectedCountry;
//   final String selectedState;
//   final String selectedCity;
//   final Function(String) onCountryChanged;
//   final Function(String) onStateChanged;
//   final Function(String) onCityChanged;

//   const _StyledLocationPicker({
//     required this.selectedCountry,
//     required this.selectedState,
//     required this.selectedCity,
//     required this.onCountryChanged,
//     required this.onStateChanged,
//     required this.onCityChanged,
//   });

//   Widget _buildDropdownContainer(Widget child) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppUiColor.buttonFillGrey200,
//         borderRadius: BorderRadius.circular(9.0),
//         border: Border.all(color: const Color(0xFFE5E5E5)),
//       ),
//       child: child,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const _FieldTitle(name: "Location"),
//         const SizedBox(height: 5),
//         _buildDropdownContainer(
//           SelectState(
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//             dropdownColor: AppUiColor.buttonFillGrey200,
//             onCountryChanged: onCountryChanged,
//             onStateChanged: onStateChanged,
//             onCityChanged: onCityChanged,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Extension to make TextField styling consistent
// extension TextFieldStyling on TextField {
//   TextField styled() {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         constraints: const BoxConstraints(minHeight: 47, maxHeight: 67),
//         filled: true,
//         fillColor: AppUiColor.buttonFillGrey200,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(9.0),
//           borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(9.0),
//           borderSide: const BorderSide(color: Colors.blue),
//         ),
//       ),
//     );
//   }
// }
