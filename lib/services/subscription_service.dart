import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kudu/core/constants.dart';
import 'package:kudu/core/services/utility_storage_service.dart';
import 'package:kudu/data/api/endpoints.dart';
import 'dart:developer' as dev;

import 'package:kudu/models/get_store_model.dart';
import 'package:kudu/models/get_subscription_model.dart';

class SubscriptionService {
  Future<Map<String, dynamic>> fetchSubscription() async {
    var response = await http.get(
      Uri.parse(ApiEndpoint.baseUrl + ApiEndpoint.subscription),
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
      List<GetSubscriptionModel> getsubscriptionModel = (data['data'] as List)
          .map((json) => GetSubscriptionModel.fromJson(json))
          .toList();

      return {
        'data': getsubscriptionModel,
      };
    } else {
      dPrint('error ${response.body}');
      throw Exception('Failed to load stores');
    }
  }
}
