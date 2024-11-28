class Store {
  final String name;
  final bool verified;
  final String address;
  final String country;
  final String state;
  Store({required this.name, required this.address, required this.country, required this.state, required this.verified});

  Store.fromJson(Map<String, dynamic> json):
    name = json["name"] ?? "My Store",
    verified = (json["verified"]) ?? false,
    address = json["address"] ?? "7 Aso villa",
    state = json["state"] ?? "Lagos",
    country = json["country"] ?? "Nigeria";
}