import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:febno_pulse/database/local_storage.dart';

Future<Map<String, String>> getHeader([String? token]) async {
  final accessToken = token ?? await LocalStorage().readAccessToken();

  return {
    "Content-Type": "application/json",
    "Accept": "application/json",
    if (accessToken != null && accessToken.isNotEmpty)
      "Authorization": "Bearer $accessToken",
  };
}

Future<void> checkConnectivity() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.none)) {
    // Get.to(() => NoInternetScreen());
  }
}

String parseError(Map<String, dynamic> json) {
  if (json['detail'] != null) {
    return json['detail'].toString();
  }

  if (json['message'] != null) {
    return json['message'].toString();
  }

  if (json['errors'] is Map) {
    final errors = json['errors'] as Map<String, dynamic>;

    for (final value in errors.values) {
      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      }

      if (value is String) {
        return value;
      }
    }
  }

  for (final value in json.values) {
    if (value is List && value.isNotEmpty) {
      return value.first.toString();
    }

    if (value is String) {
      return value;
    }
  }

  return 'Something went wrong';
}
