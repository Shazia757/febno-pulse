import 'dart:convert';
import 'dart:developer';

import 'package:febno_pulse/config/urls.dart';
import 'package:febno_pulse/config/utils.dart';
import 'package:febno_pulse/database/local_storage.dart';
import 'package:febno_pulse/models/user_model.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<http.Response> safeRequest(
    Future<http.Response> Function(Map<String, String> headers) request,
  ) async {
    final accessToken = await LocalStorage().readAccessToken();

    final response = await request(await getHeader(accessToken));

    if (response.statusCode == 401) {
      await LocalStorage().clearToken();
    }

    return response;
  }

  //------------------Login---------------------------//

  Future<dynamic> login(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(Uri.parse(Urls.login), body: jsonEncode(data))
          .timeout(const Duration(seconds: 60));

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(responseJson);
        final accessToken = loginResponse.accessToken;
        final refreshToken = loginResponse.refreshToken;

        if (accessToken != null && refreshToken != null) {
          await LocalStorage().writeToken(accessToken, refreshToken);
        }
        return loginResponse;
      }
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during login: $e');
    }

    return null;
  }
}
