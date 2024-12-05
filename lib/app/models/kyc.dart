import 'package:equatable/equatable.dart';

class Kyc extends Equatable {
  final String vendorID;
  final String businessName;
  final String contactEmail;
  final String phoneNumber;
  final String? businessDescription;
  final String? businessLink;
  final String? businessRegistrationNumber;
  final String? taxIdentificationNumber;
  final String? relevantDocumentUrl;

  const Kyc(
      {required this.vendorID,
      required this.businessName,
      required this.contactEmail,
      required this.phoneNumber,
      this.businessDescription,
      this.businessLink,
      this.businessRegistrationNumber,
      this.taxIdentificationNumber,
      this.relevantDocumentUrl});

  @override
  List<Object?> get props => [
        vendorID,
        businessName,
        contactEmail,
        phoneNumber,
        businessDescription,
        businessLink,
        businessRegistrationNumber,
        taxIdentificationNumber,
        relevantDocumentUrl
      ];
}
