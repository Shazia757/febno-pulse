import 'package:febno_pulse/database/local_storage.dart';
import 'package:febno_pulse/models/user_model.dart';
import 'package:febno_pulse/screens/login_screen.dart';
import 'package:febno_pulse/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  var errorMessage = ''.obs;
  var isLoading = false.obs;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //------------------Login---------------------------//

  Future<void> login() async {
    errorMessage.value = '';

    await LocalStorage().clearToken();

    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;

    try {
      final response = await Api().login({
        'username': username,
        'password': password,
      });
      if (isClosed) return;
      if (response is LoginResponse) {
        await LocalStorage().writeUser(response.data ?? Users());

        await LocalStorage().writeToken(
          response.accessToken ?? '',
          response.refreshToken ?? '',
        );

        usernameController.clear();
        passwordController.clear();

        // CustomWidgets.showSnackBar(
        //   'Welcome',
        //   '${user.name}',
        //   icon: const Icon(Icons.login, color: Color(0xFF1976D2), size: 20),
        // );
        // Get.offAll(() => const HomeScreen());
      } else {
        errorMessage.value = response?.message ?? 'Failed to login!';
        // CustomWidgets.showSnackBar('Error', errorMessage.value);
      }
    } catch (e) {
      if (!isClosed) {
        errorMessage.value = 'Login error: $e';
        // CustomWidgets.showSnackBar('Error', errorMessage.value);
      }
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  //------------------Logout---------------------------//

  void logout() async {
    if (!isClosed) isLoading.value = true;

    usernameController.clear();
    passwordController.clear();

    LocalStorage().clearAll();

   Get.offAll(() => const LoginScreen());
  }
}
