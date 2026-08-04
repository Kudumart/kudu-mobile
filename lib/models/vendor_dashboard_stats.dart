class VendorDashboardStats {
  VendorDashboardStats({
    this.totalSales,
    this.totalOrders,
    this.totalProducts,
    this.productStatusBreakdown,
    this.monthlySales,
  });

  VendorDashboardStats.fromJson(dynamic json) {
    totalSales = num.tryParse(json['totalSales']?.toString() ?? "") ?? 0;
    totalOrders = num.tryParse(json['totalOrders']?.toString() ?? "") ?? 0;
    totalProducts = num.tryParse(json['totalProducts']?.toString() ?? "") ?? 0;
    productStatusBreakdown = json['productStatusBreakdown'] != null
        ? ProductStatusBreakdown.fromJson(json['productStatusBreakdown'])
        : null;
    monthlySales = json['monthlySales'] != null
        ? (json['monthlySales'] as List).map((v) => MonthlySales.fromJson(v)).toList()
        : [];
  }

  num? totalSales;
  num? totalOrders;
  num? totalProducts;
  ProductStatusBreakdown? productStatusBreakdown;
  List<MonthlySales>? monthlySales;
}

class ProductStatusBreakdown {
  ProductStatusBreakdown({this.active, this.draft, this.inactive});

  ProductStatusBreakdown.fromJson(dynamic json) {
    active = num.tryParse(json['active']?.toString() ?? "") ?? 0;
    draft = num.tryParse(json['draft']?.toString() ?? "") ?? 0;
    inactive = num.tryParse(json['inactive']?.toString() ?? "") ?? 0;
  }

  num? active;
  num? draft;
  num? inactive;

  num get total => (active ?? 0) + (draft ?? 0) + (inactive ?? 0);
}

class MonthlySales {
  MonthlySales({this.month, this.total});

  MonthlySales.fromJson(dynamic json) {
    month = json['month'];
    total = num.tryParse(json['total']?.toString() ?? "") ?? 0;
  }

  String? month;
  num? total;
}
