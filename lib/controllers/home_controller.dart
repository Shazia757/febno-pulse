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
    loadDummyData();
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

  void loadDummyData() {
    isLoading.value = true;

    employees.assignAll([
      Attendance(
        id: '1',
        personName: 'Arun Kumar',
        employeeId: 'EMP001',
        punchTime: '2026-10-23T09:00:00+05:30',
        punchStatus: 'IN',
        checkinWhatsappSent: true,
        checkoutWhatsappSent: false,
        absentWhatsappSent: false,
        sourceSystem: 'Biometric',
        companyName: "Technodot Academy of R&D&I",
      ),
      Attendance(
        id: '2',
        personName: 'Rahul Das',
        employeeId: 'EMP002',
        punchTime: '2026-10-23T17:30:00+05:30',
        punchStatus: 'OUT',
        checkinWhatsappSent: true,
        checkoutWhatsappSent: true,
        absentWhatsappSent: false,
        sourceSystem: 'Biometric',
      ),
      Attendance(
        id: '3',
        personName: 'Priya Nair',
        employeeId: 'EMP003',
        punchTime: '2026-10-23T09:15:00+05:30',
        punchStatus: 'IN',
        checkinWhatsappSent: true,
        checkoutWhatsappSent: false,
        absentWhatsappSent: false,
        sourceSystem: 'Manual',
      ),
      Attendance(
        id: '4',
        personName: 'Vishnu Raj',
        employeeId: 'EMP004',
        punchTime: '2026-10-23T08:55:00+05:30',
        punchStatus: 'ABSENT',
        checkinWhatsappSent: false,
        checkoutWhatsappSent: false,
        absentWhatsappSent: true,
        sourceSystem: 'Manual',
      ),
    ]);
    isLoading.value = false;
  }

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
