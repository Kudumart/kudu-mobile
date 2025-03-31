part of '../screen.dart';

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
    return DropdownButtonFormField<String>(
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



