enum ProductCondition { used, brandNew, refurbished }

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
