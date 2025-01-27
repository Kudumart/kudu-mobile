part of '../screen.dart';

class _FormFields extends StatefulWidget {
  final UserProfile userProfile; 
  const _FormFields(this.userProfile,{super.key});

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
                  _CustomTextFormField(hint: "First Name",initialValue: _userProfile.firstName,onChanged: (s){
                    if(s != null){
                      widget.userProfile.firstName = s;
                    }
                    _userProfile = _userProfile.copyWith(
                      firstName: s,
                    );
                  },),
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
                  _CustomTextFormField(hint: "Last Name",initialValue: _userProfile.lastName,onChanged: (s){
                    if(s != null){
                      widget.userProfile.lastName = s;
                    }
                    _userProfile = _userProfile.copyWith(
                      lastName: s,
                    );
                  },),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 23),
        const _FieldTitle(name: "Email Address"),
        const SizedBox(height: 5),
        _CustomTextFormField(hint: "yourname@example.com",initialValue: _userProfile.email,enabled: false,onChanged: (s){
          if(s != null){
            widget.userProfile.email = s;
          }
          _userProfile = _userProfile.copyWith(
            email: s,
          );
        },),
        const SizedBox(height: 23),
        const _FieldTitle(name: "Phone Number"),
        const SizedBox(height: 5),
        _IntlPhoneNumberField(
          initialCompletePhoneNumber: _userProfile.phoneNumber,
          onSaved: (input) {
            if(input != null){
              widget.userProfile.phoneNumber = input.completeNumber;
            }
            _userProfile = _userProfile.copyWith(
              phoneNumber: input?.completeNumber,
            );
          },
        ),
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
