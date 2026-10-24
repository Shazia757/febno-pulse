import 'package:febno_pulse/controllers/home_controller.dart';
import 'package:febno_pulse/widgets/home_screen_widgets.dart';
import 'package:febno_pulse/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({super.key});

  final HomeController c = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final tt = theme.textTheme;

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Attendance Records',
                      style: tt.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: c.fetchEmployeeAttendance,
                    tooltip: 'Refresh attendance',
                    icon: Icon(Icons.refresh_rounded, color: cs.primary),
                  ),

                  const SizedBox(width: 4),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${c.filteredEmployees.length} records',
                      style: tt.labelMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: TextField(
                controller: c.searchTextController,
                onChanged: (value) => c.searchQuery.value = value,
                textInputAction: TextInputAction.search,
                style: TextStyle(fontSize: 14, color: cs.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search employee name or ID...',
                  hintStyle: TextStyle(
                    fontSize: 12.5,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: cs.primary),
                  suffixIcon: Obx(
                    () => c.searchQuery.value.isEmpty
                        ? const SizedBox.shrink()
                        : IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              c.searchTextController.clear();
                              c.searchQuery.value = '';
                            },
                          ),
                  ),
                  filled: true,
                  fillColor: cs.surfaceContainerLow,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: cs.outline.withValues(alpha: 0.12),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: cs.primary, width: 1.4),
                  ),
                ),
              ),
            ),

            if (c.filteredEmployees.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 26),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: cs.outline.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          c.searchQuery.value.isNotEmpty
                              ? Icons.manage_search_rounded
                              : Icons.event_available_rounded,
                          size: 38,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        c.searchQuery.value.isNotEmpty
                            ? 'No matching employees'
                            : 'No records available',
                        textAlign: TextAlign.center,
                        style: tt.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 9),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 290),
                        child: Text(
                          c.searchQuery.value.isNotEmpty
                              ? 'We couldn’t find an employee matching '
                                    '"${c.searchQuery.value}". Try a different name or ID.'
                              : 'No attendance records are available yet. '
                                    'Refresh to check for the latest updates.',
                          textAlign: TextAlign.center,
                          style: tt.bodyMedium?.copyWith(
                            height: 1.5,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      if (c.searchQuery.value.isNotEmpty)
                        OutlinedButton.icon(
                          onPressed: () => c.searchQuery.value = '',
                          icon: const Icon(Icons.close_rounded, size: 18),
                          label: const Text('Clear search'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: cs.primary,
                            side: BorderSide(
                              color: cs.primary.withValues(alpha: 0.35),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                        )
                      else
                        FilledButton.icon(
                          onPressed: c.fetchEmployeeAttendance,
                          icon: const Icon(Icons.refresh_rounded, size: 19),
                          label: const Text('Refresh attendance'),
                          style: FilledButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: cs.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            else
              ...c.filteredEmployees.map(
                (attendance) => attendanceCard(context, attendance),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
