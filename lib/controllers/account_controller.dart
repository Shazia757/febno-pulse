import 'package:febno_pulse/database/local_storage.dart';
import 'package:febno_pulse/models/user_model.dart';
import 'package:febno_pulse/screens/home_screen.dart';
import 'package:febno_pulse/screens/login_screen.dart';
import 'package:febno_pulse/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  var errorMessage = ''.obs;
  var usernameError = ''.obs;
  var passwordError = ''.obs;
  final Rxn<Users> user = Rxn<Users>();

  var obscurePassword = true.obs;

  var isLoading = false.obs;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //------------------Login---------------------------//

  Future<void> login() async {
    errorMessage.value = '';
    usernameError.value = '';
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
      Get.snackbar(
        'Validation Error',
        username.isEmpty && password.isEmpty
            ? 'Please enter your username and password.'
            : username.isEmpty
            ? 'Please enter your username.'
            : 'Please enter your password.',
      );
      return;
    }

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      debugPrint('LOGIN 1: Sending login request');

      final response = await Api().login({
        'username': username,
        'password': password,
      });

      debugPrint('LOGIN 2: API request completed');
      debugPrint('LOGIN 2: Response type = ${response.runtimeType}');
      debugPrint('LOGIN 2: Controller closed = $isClosed');

      if (isClosed) {
        debugPrint('LOGIN STOPPED: Login controller is closed');
        return;
      }

      if (response is! LoginResponse) {
        debugPrint('LOGIN STOPPED: Response is not LoginResponse');
        errorMessage.value = 'Invalid username or password';
        Get.snackbar('Login Failed', errorMessage.value);
        return;
      }

      debugPrint('LOGIN 3: LoginResponse validated');

      final accessToken = response.accessToken;
      final loggedInUser = response.data;

      debugPrint(
        'LOGIN 4: Token exists = '
        '${accessToken != null && accessToken.isNotEmpty}',
      );
      debugPrint('LOGIN 4: User exists = ${loggedInUser != null}');

      if (accessToken == null || accessToken.isEmpty) {
        errorMessage.value = 'Invalid username or password';
        Get.snackbar('Login Failed', errorMessage.value);
        return;
      }

      if (loggedInUser == null) {
        errorMessage.value = 'Unable to retrieve user details.';
        Get.snackbar('Login Failed', errorMessage.value);
        return;
      }

      debugPrint('LOGIN 5: Saving user');

      await LocalStorage().writeUser(loggedInUser);

      debugPrint('LOGIN 6: User saved');

      if (Get.isRegistered<AccountController>()) {
        Get.find<AccountController>().user.value = loggedInUser;
      }

      debugPrint('LOGIN 7: Saving tokens');

      await LocalStorage().writeToken(accessToken, response.refreshToken ?? '');

      debugPrint('LOGIN 8: Tokens saved');
      debugPrint('LOGIN 8: Controller closed = $isClosed');

      if (isClosed) {
        debugPrint('LOGIN STOPPED: Controller closed before navigation');
        return;
      }

      usernameController.clear();
      passwordController.clear();

      usernameError.value = '';
      passwordError.value = '';
      errorMessage.value = '';

      debugPrint('LOGIN 9: Navigating to HomeScreen');

      Get.offAll(() => HomeScreen());

      debugPrint('LOGIN 10: Navigation requested');
    } catch (e, stackTrace) {
      debugPrint('LOGIN ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!isClosed) {
        errorMessage.value = 'Login failed. Please try again.';
        Get.snackbar('Login Failed', errorMessage.value);
      }
    } finally {
      debugPrint('LOGIN FINALLY: isClosed = $isClosed');

      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadUser() async {
    user.value = await LocalStorage().readUser();
  }
  //------------------Logout---------------------------//

  Future<void> logout() async {
     if (isLoading.value) return;

    isLoading.value = true;

    try {
      usernameController.clear();
      passwordController.clear();

      await LocalStorage().clearAll();

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
