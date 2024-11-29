part of '../screen.dart';

class _FormFields extends StatelessWidget {
  const _FormFields();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldTitle(name: "First Name"),
                  SizedBox(height: 5),
                  _CustomTextFormField(hint: "Victor"),
                ],
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldTitle(name: "Last Name"),
                  SizedBox(height: 5),
                  _CustomTextFormField(hint: "Dwaelo"),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 23),
        const _FieldTitle(name: "Email Address"),
        const SizedBox(height: 5),
        const _CustomTextFormField(hint: "designer@greenmousetech.com"),
        const SizedBox(height: 23),
        const _FieldTitle(name: "Phone Number"),
        const SizedBox(height: 5),
        _IntlPhoneNumberField(onSaved: (input) {}),
        const SizedBox(height: 23),
        const _FieldTitle(name: "Date of Birth"),
        const SizedBox(height: 5),
        _CustomTextFormField(
          hint: "Date of birth",
          onTap: () {},
          enabled: false,
          suffixIcon: const Icon(
            CupertinoIcons.calendar,
            color: Colors.black,
            size: 18,
          ),
        )
      ],
    );
  }
}

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
