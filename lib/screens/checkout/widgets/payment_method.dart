part of '../screen.dart';

class _PaymentMethodSelector extends StatefulWidget {
  const _PaymentMethodSelector();

  @override
  State<_PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<_PaymentMethodSelector> {
  String selectedPayment = "bank_transfer";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 25, 8, 20),
      decoration: BoxDecoration(
          border: Border.all(color: AppUiColor.buttonFillGrey200),
          color: AppUiColor.grey50,
          borderRadius: BorderRadius.circular(11)),
      child: Column(
        children: [
          // USSD or Bank Transfer Option
          _PaymentMethodButton(
            onPressed: (_) {},
            groupSelectedValue: "Bank Card",
            name: "Pay with USSD or Bank Trnsf",
            onSelected: (_) {},
            trailing: Row(
              children: [
                SvgPicture.asset(AppUiIcon.bank,
                    height: 22, width: 22, fit: BoxFit.contain),
                const SizedBox(width: 3),
                SvgPicture.asset(AppUiIcon.numpad,
                    height: 22, width: 22, fit: BoxFit.contain)
              ],
            ),
          ),
          const SizedBox(height: 17),

          // Bank Card Option
          _PaymentMethodButton(
            onPressed: (_) {},
            groupSelectedValue: "Bank Card",
            name: "Bank Card",
            onSelected: (_) {},
            trailing: Image.asset(AppUiImage.mastercardLogo),
          ),
          const SizedBox(height: 40),

          // Add New Payment Method
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDEEFF7),
                borderRadius: BorderRadius.circular(9.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add New Payment Method",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodButton extends StatelessWidget {
  final Function(String) onPressed;
  final String groupSelectedValue;
  final Function(String?) onSelected;
  final String name;
  final Widget trailing;
  const _PaymentMethodButton({
    required this.onPressed,
    required this.groupSelectedValue,
    required this.name,
    required this.onSelected,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: name,
          groupValue: groupSelectedValue,
          onChanged: onSelected,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                    color: name == groupSelectedValue
                        ? AppUiColor.primary
                        : const Color(0xFF939393))),
            child: Row(
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w300)),
                const Expanded(child: SizedBox()),
                trailing,
              ],
            ),
          ),
        )
      ],
    );
  }
}
