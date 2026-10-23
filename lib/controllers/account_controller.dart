import 'package:febno_pulse/database/local_storage.dart';
import 'package:febno_pulse/models/user_model.dart';
import 'package:febno_pulse/screens/login_screen.dart';
import 'package:febno_pulse/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  var errorMessage = ''.obs;
  var usernameError = ''.obs;
  var passwordError = ''.obs;

  var obscurePassword = true.obs;

  var isLoading = false.obs;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //------------------Login---------------------------//

  Future<void> login() async {
    errorMessage.value = '';
    passwordError.value = '';

    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      if (username.isEmpty) {
        usernameError.value = 'Please enter your username';
      }

      if (password.isEmpty) {
        passwordError.value = 'Please enter your password';
      }

      return;
    }

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await Api().login({
        'username': username,
        'password': password,
      });

      if (isClosed) return;

      if (response is! LoginResponse) {
        errorMessage.value = 'Invalid login response';
        return;
      }

      final accessToken = response.accessToken;

      if (accessToken == null || accessToken.isEmpty) {
        errorMessage.value = 'Access token was not returned';
        return;
      }

      await LocalStorage().writeUser(response.data ?? Users());

      await LocalStorage().writeToken(accessToken, response.refreshToken ?? '');

      if (isClosed) return;

      usernameController.clear();
      passwordController.clear();
      usernameError.value = '';
      passwordError.value = '';

      debugPrint('Login successful');

      // Navigate after successful login:
      // Get.offAll(() => const HomeScreen());
    } catch (e) {
      if (!isClosed) {
        errorMessage.value = 'Login failed. Please try again.';
        debugPrint('Login exception: $e');
      }
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  //------------------Logout---------------------------//

 Future<void> logout() async {
  if (isClosed) return;

  isLoading.value = true;

  try {
    usernameController.clear();
    passwordController.clear();

    await LocalStorage().clearAll();

    if (isClosed) return;

    Get.offAll(() => const LoginScreen());
  } catch (e) {
    debugPrint('Logout error: $e');
  } finally {
    if (!isClosed) {
      isLoading.value = false;
    }
  }
}
}
