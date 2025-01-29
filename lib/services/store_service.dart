import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/data/api/endpoints.dart';
import 'package:kudu/models/get_categories_model.dart';
import 'package:kudu/models/get_product_model.dart';
import 'dart:developer' as dev;

import 'package:kudu/models/get_store_model.dart';

class StoreService {
  Future<Map<String, dynamic>> fetchStores() async {
    var response = await http.get(
      Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.store),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${StorageService().getString('token')}'
      },
    ).timeout(
      const Duration(seconds: 60),
    );

    dPrint('statusCode::: ${response.statusCode}');
    dev.log('response::: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<GetStoreModel> getStoreModel = (data['data'] as List)
          .map((json) => GetStoreModel.fromJson(json))
          .toList();

      return {
        'data': getStoreModel,
      };
    } else {
      dPrint('error ${response.body}');
      throw Exception('Failed to load stores');
    }
  }

  Future<Map<String, dynamic>> fetchCategories() async {
    var response = await http.get(
      Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.categories),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${StorageService().getString('token')}'
      },
    ).timeout(
      const Duration(seconds: 60),
    );

    dPrint('statusCode::: ${response.statusCode}');
    dev.log('response::: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<GetCategoriesModel> getCategoryModel = (data['data'] as List)
          .map((json) => GetCategoriesModel.fromJson(json))
          .toList();

      return {
        'data': getCategoryModel,
      };
    } else {
      dPrint('error ${response.body}');
      throw Exception('Failed to load stores');
    }
  }

  Future<Map<String, dynamic>> fetchVendorsProducts() async {
    var response = await http.get(
      Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.fetchVendorProduct),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${StorageService().getString('token')}'
      },
    ).timeout(
      const Duration(seconds: 60),
    );

    dPrint('statusCode::: ${response.statusCode}');
    dev.log('response::: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<GetProductModel> getProduct = (data['data'] as List)
          .map((json) => GetProductModel.fromJson(json))
          .toList();

      return {
        'data': getProduct,
      };
    } else {
      dPrint('error ${response.body}');
      throw Exception('Failed to load products');
    }
  }
}
