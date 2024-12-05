import 'dart:developer';

enum ProductCondition { used, brandNew, refurbished }

enum UserType { unknown, vendor, customer }

extension PrintableName on ProductCondition {
  String printableName() {
    switch (this) {
      case ProductCondition.brandNew:
        return "Brand New";
      case ProductCondition.refurbished:
        return "Refurbished";
      case ProductCondition.used:
        return "Used";
      default:
        return "Used";
    }
  }
}

extension SameDay on DateTime {
  bool isSameDayAs(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }
}

UserType userTypeFromString(String? value) {
  if (value == null || value.isEmpty) {
    return UserType.unknown;
  }
  switch (value.toLowerCase()) {
    case "customer":
      return UserType.customer;
    case "vendor":
      return UserType.vendor;
    default:
      log("Error: received unknown user type value -> $value");
      return UserType.unknown;
  }
}
