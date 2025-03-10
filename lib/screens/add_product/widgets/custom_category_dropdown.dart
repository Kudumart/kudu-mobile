import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudu/core/colors.dart';
import 'package:kudu/models/get_categories_model.dart';

class CustomCatetoriesDropdownField extends StatefulWidget {
  final List<GetCategoriesModel> values;
  final Widget? hint;
  final Function(GetCategoriesModel?) onSelect;
  final String label;
  final String? value;

  const CustomCatetoriesDropdownField({
    super.key,
    required this.label,
    required this.values,
    required this.onSelect,
    this.hint,
    this.value,
  });

  @override
  State<CustomCatetoriesDropdownField> createState() =>
      _CustomCatetoriesDropdownFieldState();
}

class _CustomCatetoriesDropdownFieldState
    extends State<CustomCatetoriesDropdownField> {
  GetCategoriesModel? _selectedValue;

  @override
  void initState() {
    super.initState();
    if(widget.value != null) {
      try{
        _selectedValue = widget.values.firstWhere((element) => element.id == widget.value);
      }catch(_){
        _selectedValue = widget.values.firstOrNull;
      }
    }
    // _selectedValue = widget.initialValue;
  }

  // @override
  // void didUpdateWidget(CustomCurrencyDropdownField oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.initialValue != oldWidget.initialValue) {
  //     setState(() {
  //       _selectedValue = widget.initialValue;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Color(0xFFD2D2D2)),
    );

    return DropdownButtonFormField<GetCategoriesModel>(
      value: _selectedValue,
      hint: widget.hint,
      validator: (value) {
        return value == null ? "Field is Required" : null;
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
          filled: false,
          labelText: widget.label,
          hintText: "Tap to Select",
          hintStyle: const TextStyle(fontSize: 14, color: AppUiColor.iconBlack),
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          focusedBorder: border,
          enabledBorder: border,
          errorBorder: border,
          focusedErrorBorder: border,
          floatingLabelStyle:
              const TextStyle(color: Colors.grey, fontSize: 12)),
      icon: const Icon(
        CupertinoIcons.chevron_down,
        size: 12,
        color: AppUiColor.iconBlack,
      ),
      onChanged: (GetCategoriesModel? newValue) {
        setState(() {
          _selectedValue = newValue;
          widget.onSelect(newValue);
        });
      },
      items: widget.values.map<DropdownMenuItem<GetCategoriesModel>>((GetCategoriesModel categories) {
        return DropdownMenuItem<GetCategoriesModel>(
          value: categories,
          child: Text(
            '${categories.name}',
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}
