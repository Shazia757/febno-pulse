import 'dart:developer';

import 'package:febno_pulse/models/attendance_model.dart';
import 'package:febno_pulse/services/api_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  RxList<Attendance> employees = <Attendance>[].obs;
  final TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeAttendance();
  }

  int get inCount =>
      employees.where((e) => e.punchStatus?.toUpperCase() == 'IN').length;

  int get outCount =>
      employees.where((e) => e.punchStatus?.toUpperCase() == 'OUT').length;

  int get absentCount =>
      employees.where((e) => e.punchStatus?.toUpperCase() == 'ABSENT').length;

  int get uniqueEmployees => employees
      .map((e) => e.employeeId)
      .where((id) => id != null && id.isNotEmpty)
      .toSet()
      .length;


  Future<void> fetchEmployeeAttendance() async {
    if (isClosed) return;

    isLoading.value = true;

    try {
      final List<Attendance>? list = await Api().getTransactions();

      if (isClosed) return;

      employees.assignAll(list ?? []);
    } catch (e) {
      log('Error fetching attendance: $e');
    } finally {
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  List<Attendance> get filteredEmployees {
    final query = searchQuery.value.trim().toLowerCase();

    if (query.isEmpty) return employees.toList();

    return employees.where((employee) {
      final name = employee.personName?.toLowerCase() ?? '';
      final id = employee.employeeId?.toLowerCase() ?? '';
      final status = employee.punchStatus?.toLowerCase() ?? '';

      return name.contains(query) ||
          id.contains(query) ||
          status.contains(query);
    }).toList();
  }
}
