part of '../screen.dart';

class _FormFields extends StatefulWidget {
  final UserProfile userProfile; 
  const _FormFields(this.userProfile);

  @override
  State<_FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<_FormFields> {

  late UserProfile _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfile = widget.userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  _CustomTextFormField(hint: _userProfile.firstName),
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
                  _CustomTextFormField(hint: _userProfile.lastName),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 23),
        const _FieldTitle(name: "Email Address"),
        const SizedBox(height: 5),
        _CustomTextFormField(hint: _userProfile.email),
        const SizedBox(height: 23),
        const _FieldTitle(name: "Phone Number"),
        const SizedBox(height: 5),
        _IntlPhoneNumberField(
          initialCompletePhoneNumber: _userProfile.phoneNumber,
          onSaved: (input) {}),
        const SizedBox(height: 23),
        const _FieldTitle(name: "Date of Birth"),
        const SizedBox(height: 5),
        _DoBView(_userProfile.dateOfBirth)
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
