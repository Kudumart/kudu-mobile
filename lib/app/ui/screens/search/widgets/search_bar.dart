part of '../screen.dart';

class _SearchBarWithFilter extends StatelessWidget
    implements PreferredSizeWidget {
  const _SearchBarWithFilter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: UiConstant.horizontalPadding),
      child: Row(
        children: [
          const Expanded(child: _SearchBar()),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _openSearchFilterBottomSheet(context),
            child: Container(
              height: 47,
              width: 45,
              padding: const EdgeInsets.all(12.5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppUiColor.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: SvgPicture.asset(
                AppUiIcon.filter,
                height: 24,
                width: 24,
                fit: BoxFit.contain,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 48);

  _openSearchFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // To ensure content is visible with keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6, // Initial height (60% of screen)
            maxChildSize: 0.9, // Maximum height (90% of screen)
            minChildSize: 0.3, // Minimum height (30% of screen)
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: _FilterContent(),
              );
            },
          ),
        );
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        constraints: const BoxConstraints(minHeight: 46, maxHeight: 47),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        hintText: 'Search products, brands, etc...',
        hintStyle: const TextStyle(
            color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            AppUiIcon.search,
            height: 21,
            width: 21,
            fit: BoxFit.contain,
            colorFilter:
                const ColorFilter.mode(AppUiColor.iconBlack, BlendMode.srcIn),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(0, 16.0, 16, 16),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: AppUiColor.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: AppUiColor.borderline),
        ),
      ),
    );
  }
}

class _FilterContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      "Fashion",
      "Electronics",
      "Properties",
      "Devices"
    ];
    final List<String> locations = [
      "Nigeria",
      "United States",
      "United Kingdom",
      "Canada",
      "Oworonshoki"
    ];
    final List<String> conditions = ["Brand New", "Used", "Refurbished", "Any"];
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 60, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DropdownFieldTitle("Categories"),
          const SizedBox(height: 8),
          _DropdownField(
              hint: "Select a category", values: categories, onSelect: (_) {}),
          const SizedBox(height: 27),
          const _DropdownFieldTitle("Location"),
          const SizedBox(height: 8),
          _DropdownField(
              hint: "Select a location", values: locations, onSelect: (_) {}),
          const SizedBox(height: 27),
          const _DropdownFieldTitle("Condition"),
          const SizedBox(height: 8),
          _DropdownField(
              hint: "Select a condition", values: conditions, onSelect: (_) {}),
          const SizedBox(height: 27),
          const _DropdownFieldTitle("Price"),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: _PriceField(hint: "Min", onSaved: (_) {}),
              ),
              const SizedBox(width: 8),
              Flexible(
                flex: 1,
                child: _PriceField(hint: "Max", onSaved: (_) {}),
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.resolveWith<OutlinedBorder>((_) =>
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)))),
            onPressed: () {
              // Add your action for the 'Apply Filter' button
            },
            child: const Text('Apply Filter'),
          ),
        ],
      ),
    );
  }
}

class _DropdownFieldTitle extends StatelessWidget {
  final String name;
  const _DropdownFieldTitle(this.name);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
    );
  }
}

class _DropdownField extends StatefulWidget {
  final List<String> values;
  final Function(String?) onSelect;
  final String hint;
  const _DropdownField(
      {required this.hint, required this.values, required this.onSelect});

  @override
  State<_DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<_DropdownField> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: (value) {
        return value == null ? "Field is Required" : null;
      },
      isDense: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      hint: Text(widget.hint,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppUiColor.iconBlack)),
      decoration: InputDecoration(
        constraints: const BoxConstraints(maxHeight: 48),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppUiColor.primary, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppUiColor.borderline),
        ),
      ),
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
    );
  }
}

class _PriceField extends StatelessWidget {
  final String hint;
  final Function(String?) onSaved;
  const _PriceField({required this.hint, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autovalidateMode: AutovalidateMode.onUnfocus,
        onSaved: onSaved,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          constraints: const BoxConstraints(maxHeight: 48),
          hintText: hint,
          hintStyle: const TextStyle(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppUiColor.borderline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppUiColor.primary, width: 0.6),
          ),
        ));
  }
}
