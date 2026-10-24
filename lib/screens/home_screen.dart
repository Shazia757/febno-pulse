import 'package:febno_pulse/controllers/account_controller.dart';
import 'package:febno_pulse/controllers/home_controller.dart';
import 'package:febno_pulse/widgets/home_screen_widgets.dart';
import 'package:febno_pulse/widgets/navbar.dart';
import 'package:febno_pulse/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController c = Get.put(HomeController());
  final AccountController accountController =
      Get.isRegistered<AccountController>()
      ? Get.find<AccountController>()
      : Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Scaffold(
      extendBody: true,

      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),

      backgroundColor: cs.surface,
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: c.fetchEmployeeAttendance,
          color: cs.primary,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).padding.top + 16,
                  20,
                  28,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cs.primary,
                      Color.lerp(cs.primary, cs.surface, 0.22)!,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final companyName = c.employees.isNotEmpty
                        ? (c.employees.first.companyName ?? 'Company')
                        : 'Company';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: cs.onPrimary.withValues(alpha: 0.13),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: cs.onPrimary.withValues(alpha: 0.16),
                                ),
                              ),
                              child: Icon(
                                Icons.graphic_eq_rounded,
                                color: cs.onPrimary,
                                size: 27,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FebnoPulse',
                                    style: tt.titleLarge?.copyWith(
                                      color: cs.onPrimary,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Attendance management',
                                    style: tt.bodySmall?.copyWith(
                                      color: cs.onPrimary.withValues(
                                        alpha: 0.72,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Material(
                              color: cs.onPrimary.withValues(alpha: 0.12),
                              shape: CircleBorder(
                                side: BorderSide(
                                  color: cs.onPrimary.withValues(alpha: 0.20),
                                ),
                              ),
                              child: IconButton(
                                tooltip: 'Logout',
                                onPressed: () => _logoutConfirm(context),
                                icon: Icon(
                                  Icons.logout_rounded,
                                  color: cs.onPrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back!,',
                              style: tt.bodyMedium?.copyWith(
                                color: cs.onPrimary.withValues(alpha: 0.75),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(() {
                              final name =
                                  accountController.user.value?.name?.trim() ??
                                  '';
                              final displayName = name.isEmpty ? 'User' : name;

                              return Row(
                                children: [
                                  Icon(
                                    Icons.person_rounded,
                                    color: cs.onPrimary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      displayName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: tt.titleMedium?.copyWith(
                                        color: cs.onPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),

                        const SizedBox(height: 26),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: cs.onPrimary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: cs.onPrimary.withValues(alpha: 0.16),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: cs.onPrimary.withValues(
                                        alpha: 0.13,
                                      ),
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Icon(
                                      Icons.business_rounded,
                                      color: cs.onPrimary,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'YOUR ORGANIZATION',
                                          style: tt.labelSmall?.copyWith(
                                            color: cs.onPrimary.withValues(
                                              alpha: 0.70,
                                            ),
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          companyName,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: tt.titleMedium?.copyWith(
                                            color: cs.onPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 17,
                                ),
                                child: Divider(
                                  height: 1,
                                  color: cs.onPrimary.withValues(alpha: 0.18),
                                ),
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: cs.onPrimary.withValues(
                                        alpha: 0.13,
                                      ),
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: Icon(
                                      Icons.schedule_rounded,
                                      color: cs.onPrimary,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "TODAY'S OVERVIEW",
                                          style: tt.labelSmall?.copyWith(
                                            color: cs.onPrimary.withValues(
                                              alpha: 0.70,
                                            ),
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: [
                                            Text(
                                              formatDateTime(DateTime.now()),
                                              style: tt.bodySmall?.copyWith(
                                                color: cs.onPrimary.withValues(
                                                  alpha: 0.82,
                                                ),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              if (c.isLoading.value && c.employees.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Text(
                    'Overview',
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 650 ? 4 : 2;

                      return GridView.count(
                        crossAxisCount: columns,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: constraints.maxWidth < 360
                            ? 1.4
                            : 1.65,
                        children: [
                          SummaryCard(
                            context: context,
                            title: 'Total Employees',
                            value: '${c.uniqueEmployees}',
                            icon: Icons.people_outline_rounded,
                            color: cs.primary,
                          ),
                          SummaryCard(
                            context: context,
                            title: 'Check-ins',
                            value: '${c.inCount}',
                            icon: Icons.login_rounded,
                            color: Colors.green,
                          ),
                          SummaryCard(
                            context: context,
                            title: 'Check-outs',
                            value: '${c.outCount}',
                            icon: Icons.logout_rounded,
                            color: Colors.blue,
                          ),
                          SummaryCard(
                            context: context,
                            title: 'Absent',
                            value: '${c.absentCount}',
                            icon: Icons.person_off_outlined,
                            color: Colors.red,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Future<void> _logoutConfirm(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out of FebnoPulse?'),

        actions: [
          TextButton(
            onPressed: accountController.isLoading.value
                ? null
                : () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          Obx(() {
            final isLoading = accountController.isLoading.value;

            return FilledButton(
              onPressed: isLoading
                  ? null
                  : () => Navigator.pop(dialogContext, true),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(dialogContext).colorScheme.onPrimary,
                      ),
                    )
                  : const Text('Log out'),
            );
          }),
        ],
      ),
    );

    if (shouldLogout == true) {
      await accountController.logout();
    }
  }
}
