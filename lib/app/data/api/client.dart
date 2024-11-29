import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:kudu/app/data/api/model_error.dart';
import 'package:kudu/app/data/api/model_success.dart';
import 'package:kudu/app/data/storage/shared_preferences.dart';

/// All ApiClient functions can throw [ApiError] if any error is encountered.
/// But if the function completes without throwing an error, then the request is successful
class ApiClient {
  static late final http.Client _client;

  static init() {
    _client = RetryClient(
      http.Client(),
    );
  }

  static const String _host = "kudumarts.victornwadinobi.com";

  /// [sendGetRequest] returns Api
  static Future<ApiSuccessResponse> sendGetRequest(String endpoint,
      {Map<String, dynamic>? queryParameters,
      BodyReader? readResponseBody,
      bool authenticate = true}) async {
    try {
      await _checkNetworkAvailability();

      final Uri url = Uri.https(_host, endpoint, queryParameters);
      final response =
          await _client.get(url, headers: _headers(addAuthData: authenticate));

      final decodedBody = _maybeThrowResponseError(response);
      return _convertBodyToApiSuccessResponse(decodedBody,
          readResponseBody: readResponseBody);
    } on FormatException catch (e) {
      throw ApiError.formatException(e);
    } on http.ClientException catch (e) {
      throw ApiError.clientException(e);
    } catch (e) {
      throw ApiError.unknownException(e);
    }
  }

  static Future<ApiSuccessResponse> sendPostRequest(
      String endpoint, Map<String, dynamic> body,
      {BodyReader? readResponseBody, bool authenticate = true}) async {
    try {
      await _checkNetworkAvailability();
      final Uri url = Uri.https(_host, endpoint);

      final encodedBody = json.encode(body);
      final response = await _client.post(url,
          headers: _headers(addAuthData: authenticate), body: encodedBody);

      final decodedBody = _maybeThrowResponseError(response);

      return _convertBodyToApiSuccessResponse(decodedBody,
          readResponseBody: readResponseBody);
    } on FormatException catch (e) {
      throw ApiError.formatException(e);
    } on http.ClientException catch (e) {
      throw ApiError.clientException(e);
    } catch (error) {
      if (error is ApiError) {
        rethrow;
      }
      throw ApiError.unknownException(error);
    }
  }

  static Future<ApiSuccessResponse> sendPutRequest(
    String endpoint,
    Map<String, dynamic> body, {
    bool authenticate = true,
    BodyReader? readResponseBody,
  }) async {
    try {
      await _checkNetworkAvailability();
      final Uri url = Uri.https(_host, endpoint);

      final encodedBody = json.encode(body);
      final response = await _client.put(url,
          body: encodedBody, headers: _headers(addAuthData: authenticate));
      _maybeThrowResponseError(response);

      return _convertBodyToApiSuccessResponse(response,
          readResponseBody: readResponseBody);
    } on FormatException catch (e) {
      throw ApiError.formatException(e);
    } on http.ClientException catch (e) {
      throw ApiError.clientException(e);
    } catch (e) {
      throw ApiError.unknownException(e);
    }
  }

  static Future<ApiSuccessResponse> sendDeleteRequest(
    String endpoint,
    Map<String, dynamic> body, {
    bool authenticate = true,
    BodyReader? readResponseBody,
  }) async {
    try {
      await _checkNetworkAvailability();
      final Uri url = Uri.https(_host, endpoint);

      final encodedBody = json.encode(body);
      final response = await _client.delete(url,
          body: encodedBody, headers: _headers(addAuthData: authenticate));
      _maybeThrowResponseError(response);

      return _convertBodyToApiSuccessResponse(response,
          readResponseBody: readResponseBody);
    } on FormatException catch (e) {
      throw ApiError.formatException(e);
    } on http.ClientException catch (e) {
      throw ApiError.clientException(e);
    } catch (e) {
      throw ApiError.unknownException(e);
    }
  }

  static dynamic _maybeThrowResponseError(http.Response response) {
    // check content type
    final String? contentType = response.headers["content-type"];

    if (contentType == null || contentType.isEmpty) {
      throw ApiError.formatException(
          "Can not decode response body: Unsupported content type");
    }

    if (!contentType.trim().toLowerCase().contains("application/json")) {
      throw ApiError.formatException(
          "Can not decode response body: Unsupported content type $contentType");
    }

    final decodedBody = json.decode(response.body);

    // check response status code
    if (response.statusCode >= 400 && response.statusCode <= 499) {
      final cause =
          decodedBody["message"] ?? response.reasonPhrase ?? response.body;
      throw ApiError.onRequest(cause, response.statusCode);
    }

    if (response.statusCode > 499 && response.statusCode <= 599) {
      throw ApiError.server(response.reasonPhrase as Object);
    }

    return decodedBody;
  }

  static ApiSuccessResponse _convertBodyToApiSuccessResponse(
      dynamic decodedBody,
      {BodyReader? readResponseBody}) {
    String message = 'Operation Successful';

    if (decodedBody["message"] != null) {
      message = decodedBody["message"];
    }

    Object? body;
    if (readResponseBody != null && decodedBody['data'] != null) {
      body = readResponseBody(decodedBody['data']);
    }
    return ApiSuccessResponse(message: message, body: body);
  }

  static _checkNetworkAvailability() async {
    final List<ConnectivityResult> result =
        await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.vpn)) {
      return;
    }
    throw ApiError.noInternetConnectionDetected();
  }

  static Map<String, String> _headers({bool addAuthData = true}) {
    final header = {"Content-Type": "application/json"};
    if (addAuthData) {
      final authToken = AppStorage.authenticationToken;
      header["Authorization"] = "Bearer $authToken";
    }
    return header;
  }
}
