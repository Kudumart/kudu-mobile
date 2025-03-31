part of '../screen.dart';

class _DeliveryAddressHeader extends StatelessWidget {
  const _DeliveryAddressHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Delivery Address",
            style: TextStyle(
                color: Color(0xFF9e9e9e),
                fontWeight: FontWeight.w400,
                fontSize: 13)),
        Text("Change Address >",
            style: TextStyle(
                color: AppUiColor.textBlue,
                fontSize: 13,
                fontWeight: FontWeight.w400)),
      ],
    );
  }
}

class DeliveryAddressField extends StatelessWidget {
  const DeliveryAddressField({
    super.key,
    this.addressController,
    this.hintText,
    this.title,
  });
  final TextEditingController? addressController;
  final String? hintText;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)...[
          const SizedBox(height: 10),
          Text(title!,
            style: const TextStyle(
                color: Color(0xFF9e9e9e),
                fontWeight: FontWeight.w400,
                fontSize: 13,
            ),
          ),
        ],
        TextFormField(
            controller: addressController,
            keyboardType: TextInputType.text,
            validator: (value) {
              return (value?.trim() ?? "").isEmpty ? "Field is Required" : null;
            },
            decoration: InputDecoration(
              constraints: const BoxConstraints(minHeight: 47, maxHeight: 48),
              hintText: hintText ?? "Enter your delivery address",
              hintStyle: const TextStyle(
                  fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
              filled: true,
              fillColor: AppUiColor.ghostWhite,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: AppUiColor.borderline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            )),
      ],
    );
  }
}
