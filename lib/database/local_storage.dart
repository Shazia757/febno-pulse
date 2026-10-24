import 'dart:convert';
import 'dart:developer';

import 'package:febno_pulse/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  Future<void> writeUser(Users user) async {
    try {
      await _storage.write(
        key: 'user',
        value: jsonEncode(user.toJson()),
      );

      await _storage.write(
        key: 'isLoggedIn',
        value: 'true',
      );
    } catch (e) {
      log('Error saving user: $e');
    }
  }

  Future<void> writeToken(
    String access,
    String refresh,
  ) async {
    try {
      await _storage.write(
        key: 'access',
        value: access,
      );

      await _storage.write(
        key: 'refresh',
        value: refresh,
      );
    } catch (e) {
      log('Error saving tokens: $e');
    }
  }

  Future<Users?> readUser() async {
  try {
    final userData = await _storage.read(key: 'user');

    if (userData == null || userData.isEmpty) {
      return null;
    }

    final Map<String, dynamic> json = jsonDecode(userData);
    return Users.fromJson(json);
  } catch (e) {
    log('Error reading user: $e');
    return null;
  }
}

  Future<String?> readAccessToken() async {
    try {
      return await _storage.read(key: 'access');
    } catch (e) {
      log('Error reading access token: $e');
      return null;
    }
  }

  Future<String?> readRefreshToken() async {
    try {
      return await _storage.read(key: 'refresh');
    } catch (e) {
      log('Error reading refresh token: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      return await _storage.read(key: 'isLoggedIn') == 'true';
    } catch (e) {
      log('Error reading login status: $e');
      return false;
    }
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'access');
    await _storage.delete(key: 'refresh');
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
