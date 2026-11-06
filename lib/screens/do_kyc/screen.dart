import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kudu/core/utils/input_validators.dart';
import 'package:kudu/models/get_kyc_model.dart';
import 'package:kudu/providers/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/shared_widgets/back_button.dart';

part 'widgets/outlined_dropdown.dart';
part 'widgets/outlined_textfield.dart';

class DoKYCScreen extends StatefulWidget {
  const DoKYCScreen({super.key});

  @override
  State<DoKYCScreen> createState() => _DoKYCScreenState();
}

class _DoKYCScreenState extends State<DoKYCScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _businessDescriptionController = TextEditingController();
  final _businessLinkController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _businessRegistrationNumberController = TextEditingController();
  final _businessEmailController = TextEditingController();
  final _businessPhoneNumberController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();

  String _idName = 'NIN';
  bool _loading = true;

  static const _idTypes = [
    'NIN',
    'International Passport',
    "Voter's Card",
    'Drivers Licence',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadKyc());
  }

  Future<void> _loadKyc() async {
    final model = context.read<ProfileViewModel>();
    await model.getKyc(context: context);
    if (!mounted) return;
    final data = model.getKycModel.data;
    if (data != null) {
      _businessNameController.text = data.businessName ?? '';
      _businessDescriptionController.text = data.businessDescription ?? '';
      _businessLinkController.text = data.businessLink ?? '';
      _businessAddressController.text = data.businessAddress ?? '';
      _businessRegistrationNumberController.text =
          data.businessRegistrationNumber ?? '';
      _businessEmailController.text = data.contactEmail ?? '';
      _businessPhoneNumberController.text =
          _nationalNumber(data.contactPhoneNumber);
      _idNumberController.text = data.idVerification?.number ?? '';
      _expiryDateController.text = data.idVerification?.expiryDate ?? '';
      final savedType = data.idVerification?.name;
      if (_idTypes.contains(savedType)) _idName = savedType!;
    }
    setState(() => _loading = false);
  }

  String _nationalNumber(String? value) {
    var digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('234')) digits = digits.substring(3);
    if (digits.startsWith('0')) digits = digits.substring(1);
    return digits;
  }

  String _reviewStatus(Data? data) {
    if (data == null || data.id == null) return 'not_submitted';
    if (data.isVerified == true) return 'approved';
    if (data.reviewStatus == 'changes_requested' ||
        data.reviewStatus == 'rejected') {
      return 'changes_requested';
    }
    return data.reviewStatus ?? 'pending';
  }

  bool _canEdit(Data? data, String field, {bool businessField = false}) {
    final status = _reviewStatus(data);
    if (status == 'not_submitted') return true;
    if (status == 'changes_requested') {
      return data?.fieldReviews[field]?.status == 'rejected';
    }
    if (status == 'approved') return businessField;
    return false;
  }

  Widget _reason(Data? data, String field) {
    final review = data?.fieldReviews[field];
    if (review?.status != 'rejected' || (review?.reason ?? '').isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 4),
      child: Text(
        review!.reason!,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  Future<void> _pickExpiryDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 20)),
    );
    if (selected != null) {
      _expiryDateController.text = DateFormat('yyyy-MM-dd').format(selected);
    }
  }

  Future<void> _submitForm(Data? data) async {
    if (!_formKey.currentState!.validate()) return;
    final success = await context.read<ProfileViewModel>().submitKyc(
          context: context,
          businessName: _businessNameController.text.trim(),
          contactEmail: _businessEmailController.text.trim(),
          contactPhoneNumber:
              '+234${_nationalNumber(_businessPhoneNumberController.text)}',
          businessDescription: _businessDescriptionController.text.trim(),
          businessLink: _businessLinkController.text.trim(),
          businessAddress: _businessAddressController.text.trim(),
          businessRegistrationNumber:
              _businessRegistrationNumberController.text.trim(),
          ninNumber: _idNumberController.text.trim(),
          idName: _idName,
          expiryDate: _expiryDateController.text.trim(),
        );
    if (!mounted || !success) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.fromLTRB(24, 16, 10, 0),
        title: Row(
          children: [
            const Expanded(child: Text('KYC submitted for review')),
            IconButton(
              tooltip: 'Close',
              onPressed: () => Navigator.pop(dialogContext),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        content: const Text(
          'Thank you for submitting your details. Our team will review them and notify you when a decision has been made.',
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Got it'),
            ),
          ),
        ],
      ),
    );
    if (mounted) await _loadKyc();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessDescriptionController.dispose();
    _businessLinkController.dispose();
    _businessAddressController.dispose();
    _businessRegistrationNumberController.dispose();
    _businessEmailController.dispose();
    _businessPhoneNumberController.dispose();
    _idNumberController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppUiColor.ghostWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: const AppBackButton(),
        titleSpacing: 0,
        title: const Text('KYC',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        forceMaterialTransparency: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<ProfileViewModel>(builder: (context, model, _) {
              final data = model.getKycModel.data;
              final status = _reviewStatus(data);
              return SafeArea(
                minimum: EdgeInsets.fromLTRB(
                  UiConstant.horizontalPadding,
                  24,
                  UiConstant.horizontalPadding,
                  MediaQuery.viewInsetsOf(context).bottom + 16,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (status == 'pending')
                          const _StatusBanner(
                            color: Color(0xFFFFF7E6),
                            textColor: Color(0xFF8A5A00),
                            icon: Icons.schedule,
                            title: 'KYC under review',
                            message:
                                'We will notify you when the review is complete.',
                          ),
                        if (status == 'changes_requested')
                          const _StatusBanner(
                            color: Color(0xFFFFEBEE),
                            textColor: Color(0xFFB42318),
                            icon: Icons.error_outline,
                            title: 'Changes requested',
                            message:
                                'Update the highlighted details and resubmit them for review.',
                          ),
                        if (status == 'approved')
                          const _StatusBanner(
                            color: Color(0xFFEAF8F0),
                            textColor: Color(0xFF157347),
                            icon: Icons.verified,
                            title: 'KYC verified',
                            message:
                                'Your identity is verified. Business and contact details can still be updated.',
                          ),
                        const _SectionTitle('Business Information'),
                        const SizedBox(height: 20),
                        _field(
                            data,
                            'businessName',
                            _CustomOutlinedTextField(
                              label: 'Business Name',
                              validator: InputValidator.validateValidInput,
                              hint: 'Business or brand name',
                              controller: _businessNameController,
                              enabled: _canEdit(data, 'businessName',
                                  businessField: true),
                            )),
                        _field(
                            data,
                            'contactEmail',
                            _CustomOutlinedTextField(
                              label: 'Contact Email',
                              validator: InputValidator.validateEmail,
                              hint: 'Enter business email',
                              controller: _businessEmailController,
                              keyboardType: TextInputType.emailAddress,
                              enabled: _canEdit(data, 'contactEmail',
                                  businessField: true),
                            )),
                        _field(
                            data,
                            'contactPhoneNumber',
                            _CustomOutlinedTextField(
                              label: 'Contact Phone Number',
                              validator: (value) =>
                                  RegExp(r'^\d{10}$').hasMatch(value ?? '')
                                      ? null
                                      : 'Enter the 10 digits after +234',
                              hint: '8012345678',
                              prefixText: '+234 ',
                              controller: _businessPhoneNumberController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10)
                              ],
                              enabled: _canEdit(data, 'contactPhoneNumber',
                                  businessField: true),
                            )),
                        _field(
                            data,
                            'businessDescription',
                            _CustomOutlinedTextField(
                              label: 'Business Description',
                              validator: InputValidator.validateValidInput,
                              hint: 'Describe your business',
                              maxLines: 3,
                              controller: _businessDescriptionController,
                              enabled: _canEdit(data, 'businessDescription',
                                  businessField: true),
                            )),
                        _field(
                            data,
                            'businessLink',
                            _CustomOutlinedTextField(
                              label: 'Business Website (Optional)',
                              validator: (value) => (value ?? '').trim().isEmpty
                                  ? null
                                  : InputValidator.validateUrl(value),
                              hint: 'Enter business website',
                              controller: _businessLinkController,
                              enabled: _canEdit(data, 'businessLink',
                                  businessField: true),
                            )),
                        _field(
                            data,
                            'businessAddress',
                            _CustomOutlinedTextField(
                              label: 'Business Address',
                              validator: InputValidator.validateValidInput,
                              hint: 'Enter business address',
                              controller: _businessAddressController,
                              enabled: _canEdit(data, 'businessAddress',
                                  businessField: true),
                            )),
                        _field(
                            data,
                            'businessRegistrationNumber',
                            _CustomOutlinedTextField(
                              label: 'Registration Number (Optional)',
                              validator: (_) => null,
                              hint: 'Business registration number',
                              controller: _businessRegistrationNumberController,
                              enabled:
                                  _canEdit(data, 'businessRegistrationNumber'),
                            )),
                        const SizedBox(height: 12),
                        const _SectionTitle('ID Verification'),
                        const SizedBox(height: 20),
                        _field(
                            data,
                            'idVerification.name',
                            _CustomOutlinedDropdownField(
                              label: 'Card Name',
                              values: _idTypes,
                              initialValue: _idName,
                              enabled: _canEdit(data, 'idVerification.name'),
                              onSelect: (value) => _idName = value ?? _idName,
                            )),
                        _field(
                            data,
                            'idVerification.number',
                            _CustomOutlinedTextField(
                              label: 'Card Number',
                              validator: InputValidator.validateValidInput,
                              hint: 'Enter ID number',
                              controller: _idNumberController,
                              enabled: _canEdit(data, 'idVerification.number'),
                            )),
                        _field(
                            data,
                            'idVerification.expiryDate',
                            _CustomOutlinedTextField(
                              label: 'Card Expiration Date',
                              validator: InputValidator.validateValidInput,
                              hint: 'YYYY-MM-DD',
                              controller: _expiryDateController,
                              readOnly: true,
                              onTap: _canEdit(data, 'idVerification.expiryDate')
                                  ? _pickExpiryDate
                                  : null,
                              enabled:
                                  _canEdit(data, 'idVerification.expiryDate'),
                            )),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: status == 'pending'
                                ? null
                                : () => _submitForm(data),
                            child: Text(status == 'pending'
                                ? 'Awaiting review'
                                : status == 'changes_requested'
                                    ? 'Resubmit corrections'
                                    : status == 'not_submitted'
                                        ? 'Submit KYC'
                                        : 'Update KYC'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
    );
  }

  Widget _field(Data? data, String name, Widget child) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [child, _reason(data, name)],
        ),
      );
}

class _StatusBanner extends StatelessWidget {
  final Color color;
  final Color textColor;
  final IconData icon;
  final String title;
  final String message;

  const _StatusBanner({
    required this.color,
    required this.textColor,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 22),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: '$title. ',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    TextSpan(text: message),
                  ]),
                  style: TextStyle(color: textColor, height: 1.35)),
            ),
          ],
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  final String value;
  const _SectionTitle(this.value);

  @override
  Widget build(BuildContext context) => Text(
        value,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppUiColor.iconBlack,
        ),
      );
}
