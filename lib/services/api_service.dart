import 'dart:convert';
import 'dart:developer';

import 'package:habit_app/models/auth_token_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();
  static final ApiService _instance = ApiService._();

  factory ApiService() {
    return _instance;
  }

  final String baseUrl =
      'http://ec2-44-221-192-71.compute-1.amazonaws.com:8080/';

  Future<http.Response> get(String url) async {
    try {
      final response = await http.get(Uri.parse(baseUrl + url));
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<http.Response> post(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + url),
        body: body != null ? jsonEncode(body) : null,
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<http.Response> postWithAuth(
    String url,
    String authToken, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + url),
        body: body != null ? jsonEncode(body) : null,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<AuthToken> postAuthLoginApple({
    required String authorizationCode,
    required String snsUserId,
    required String deviceToken,
  }) async {
    final response = await post('api/auth/login/apple', body: {
      'authorizationCode': authorizationCode,
      'userId': snsUserId,
      'deviceToken': deviceToken,
    });

    if (response.statusCode == 200) {
      return AuthToken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  Future<AuthToken> postAuthLoginGoogle({
    required String authorizationCode,
    required String deviceToken,
  }) async {
    final response = await post('api/auth/login/google', body: {
      'authorizationCode': authorizationCode,
      'deviceToken': deviceToken,
    });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return AuthToken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.statusCode.toString() + response.body);
    }
  }

  Future<void> postAuthLogout(String authToken) async {
    final response = await postWithAuth('api/auth/logout', authToken);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Logout successful
    } else {
      throw Exception(response.statusCode.toString() + response.body);
    }
  }
}
