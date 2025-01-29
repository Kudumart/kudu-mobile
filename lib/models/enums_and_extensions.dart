import 'dart:developer';

enum ProductCondition { fairlyused, brandNew, refurbished, fairlyforeign }

enum UserType { unknown, vendor, customer }

enum AuctionStatus { ongoing, closed, upcoming, unknown }

extension PrintableName on ProductCondition {
  String printableName() {
    switch (this) {
      case ProductCondition.brandNew:
        return "Brand New";
      case ProductCondition.refurbished:
        return "Refurbished";
      case ProductCondition.fairlyused:
        return "Fairly Used";
      case ProductCondition.fairlyforeign:
        return "Fairly Foreign";
      default:
        return "Used";
    }
  }
}

extension PrintableAuctionStatus on AuctionStatus {
  String printableName() {
    switch (this) {
      case AuctionStatus.closed:
        return "Closed";
      case AuctionStatus.upcoming:
        return "Upcoming";
      case AuctionStatus.ongoing:
        return "Live/Ongoing";
      default:
        return "Unknown Status";
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

extension MaxCharacter on String {
  String substringOfMaxLength(int maxLength) {
    if (length > maxLength) {
      return "${substring(0, maxLength)}...";
    }

    return this;
  }
}
