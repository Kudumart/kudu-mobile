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

class _DeliveryAddressField extends StatelessWidget {
  const _DeliveryAddressField();

  @override
  Widget build(BuildContext context) {
    return TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          constraints: const BoxConstraints(minHeight: 47, maxHeight: 48),
          hintText: "123 Awolowo Way, Ikeja, Lagos, Nigeria",
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
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ));
  }
}
