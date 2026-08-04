import 'dart:convert';

ServicesListModel servicesListModelFromJson(String str) => ServicesListModel.fromJson(json.decode(str));

class ServicesListModel {
  ServicesListModel({this.data, this.pagination});

  ServicesListModel.fromJson(dynamic json) {
    data = json['data'] != null
        ? (json['data'] as List).map((v) => ServiceData.fromJson(v)).toList()
        : [];
    pagination = json['pagination'] != null ? ServicePagination.fromJson(json['pagination']) : null;
  }

  List<ServiceData>? data;
  ServicePagination? pagination;
}

class ServicePagination {
  ServicePagination({this.totalItems, this.totalPages, this.currentPage});

  ServicePagination.fromJson(dynamic json) {
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
  }

  int? totalItems;
  int? totalPages;
  int? currentPage;
}

class ServiceData {
  ServiceData({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.additionalImages,
    this.locationCity,
    this.locationState,
    this.locationCountry,
    this.workExperienceYears,
    this.isNegotiable,
    this.price,
    this.discountPrice,
    this.status,
    this.provider,
    this.category,
    this.subCategory,
  });

  ServiceData.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['image_url'];
    additionalImages = json['additional_images'] != null
        ? (json['additional_images'] as List).map((i) => i.toString()).toList()
        : [];
    locationCity = json['location_city'];
    locationState = json['location_state'];
    locationCountry = json['location_country'];
    workExperienceYears = json['work_experience_years'];
    isNegotiable = json['is_negotiable'];
    price = json['price']?.toString();
    discountPrice = json['discount_price']?.toString();
    status = json['status'];
    provider = json['provider'] != null ? ServiceProvider.fromJson(json['provider']) : null;
    category = json['category'] != null ? ServiceCategory.fromJson(json['category']) : null;
    subCategory = json['subCategory'] != null ? ServiceCategory.fromJson(json['subCategory']) : null;
  }

  String? id;
  String? title;
  String? description;
  String? imageUrl;
  List<String>? additionalImages;
  String? locationCity;
  String? locationState;
  String? locationCountry;
  num? workExperienceYears;
  bool? isNegotiable;
  String? price;
  String? discountPrice;
  String? status;
  ServiceProvider? provider;
  ServiceCategory? category;
  ServiceCategory? subCategory;

  bool get hasDiscount => (num.tryParse(discountPrice ?? "") ?? 0) > 0 && (num.tryParse(discountPrice ?? "") ?? 0) < (num.tryParse(price ?? "") ?? 0);

  String get location {
    var parts = [locationCity, locationState, locationCountry].where((e) => (e ?? "").trim().isNotEmpty).toList();
    return parts.isEmpty ? "Not Available" : parts.join(", ");
  }
}

class ServiceProvider {
  ServiceProvider({this.id, this.firstName, this.lastName, this.photo, this.isVerified});

  ServiceProvider.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    photo = json['photo'];
    isVerified = json['isVerified'] == true;
  }

  String? id;
  String? firstName;
  String? lastName;
  String? photo;
  bool? isVerified;

  String get name => "${firstName ?? ""} ${lastName ?? ""}".trim();
}

class ServiceCategory {
  ServiceCategory({this.id, this.name, this.image});

  ServiceCategory.fromJson(dynamic json) {
    id = json['id']?.toString();
    name = json['name'];
    image = json['image'];
  }

  String? id;
  String? name;
  String? image;
}
