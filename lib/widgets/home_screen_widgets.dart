import 'package:febno_pulse/models/attendance_model.dart';
import 'package:flutter/material.dart';

Widget attendanceCard(BuildContext context, Attendance attendance) {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;
  final tt = theme.textTheme;

  final status = attendance.punchStatus?.toUpperCase() ?? '';

  final Color statusColor = switch (status) {
    'IN' => Colors.green,
    'OUT' => cs.primary,
    'ABSENT' => cs.error,
    _ => cs.onSurfaceVariant,
  };

  String displayTime(String? value) {
    if (value == null || value.trim().isEmpty) return '--:--';

    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;

    final hour = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
    final minute = parsed.minute.toString().padLeft(2, '0');
    final period = parsed.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  Widget detailRow(IconData icon, String label, String? rawValue) {
    final value = rawValue?.trim().isNotEmpty == true
        ? rawValue!.trim()
        : 'Not available';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
    decoration: BoxDecoration(
      color: cs.surface,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: cs.primary.withValues(alpha: 0.13)),
      boxShadow: [
        BoxShadow(
          color: cs.primary.withValues(alpha: 0.035),
          blurRadius: 20,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Theme(
        data: theme.copyWith(
          dividerColor: Colors.transparent,
          splashColor: cs.primary.withValues(alpha: 0.04),
          highlightColor: cs.primary.withValues(alpha: 0.025),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(15, 12, 14, 12),
          childrenPadding: const EdgeInsets.fromLTRB(15, 0, 15, 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(22)),
          ),
          collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(22)),
          ),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cs.primary.withValues(alpha: 0.16),
                  cs.primary.withValues(alpha: 0.07),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.person_rounded, color: cs.primary, size: 26),
          ),
          title: Text(
            attendance.personName?.trim().isNotEmpty == true
                ? attendance.personName!
                : 'Unknown employee',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: tt.titleMedium,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Text(
              'ID: ${attendance.employeeId ?? '-'}',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),

          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  status.isEmpty ? 'UNKNOWN' : status,
                  style: tt.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: cs.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),

          children: [
            Divider(color: cs.primary.withValues(alpha: 0.12), height: 1),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _punchTimeTile(
                    context,
                    label: 'PUNCH IN',
                    time: status == 'IN'
                        ? displayTime(attendance.punchTime)
                        : '--:--',
                    icon: Icons.login_rounded,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _punchTimeTile(
                    context,
                    label: 'PUNCH OUT',
                    time: status == 'OUT'
                        ? displayTime(attendance.punchTime)
                        : '--:--',
                    icon: Icons.logout_rounded,
                    color: cs.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Employee & Record Details',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 8),

            detailRow(
              Icons.verified_outlined,
              'Punch status',
              status.isEmpty ? 'Unknown' : status,
            ),
            detailRow(
              Icons.access_time_rounded,
              'Punch date & time',
              formatDateTime(DateTime.tryParse(attendance.punchTime ?? '')),
            ),
            detailRow(
              Icons.devices_rounded,
              'Source system',
              attendance.sourceSystem,
            ),
            detailRow(
              Icons.save_outlined,
              'Record created',
              formatDateTime(DateTime.tryParse(attendance.insertedAt ?? '')),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Notifications & Calls',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 8),
            if (status.toLowerCase() != 'absent') ...[
              detailRow(
                Icons.login_rounded,
                'Check-in WhatsApp',
                textLabel(attendance.checkinWhatsappSent),
              ),
              detailRow(
                Icons.logout_rounded,
                'Check-out WhatsApp',
                textLabel(attendance.checkoutWhatsappSent),
              ),
            ],
            if (status.toLowerCase() == 'absent') ...[
              detailRow(
                Icons.person_off_outlined,
                'Absent WhatsApp',
                textLabel(attendance.absentWhatsappSent),
              ),
              detailRow(
                Icons.call_outlined,
                'Call attempted',
                textLabel(attendance.isCalled),
              ),
              detailRow(
                Icons.forum_outlined,
                'Call feedback',
                attendance.callFeedback,
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

Widget _punchTimeTile(
  BuildContext context, {
  required String label,
  required String time,
  required IconData icon,
  required Color color,
}) {
  final cs = Theme.of(context).colorScheme;
  final tt = Theme.of(context).textTheme;

  return Container(
    constraints: const BoxConstraints(minHeight: 88),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: cs.primary.withValues(alpha: 0.045),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: cs.primary.withValues(alpha: 0.10)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: cs.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0.45,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            time,
            style: tt.titleMedium?.copyWith(
              color: cs.onSurface,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    ),
  );
}

String textLabel(bool? value) {
  if (value == null) return 'Not available';
  return value ? 'Yes' : 'No';
}

String formatDateTime(DateTime? date, {bool includeTime = true}) {
  if (date == null) return 'Not available';

  final local = date.toLocal();

  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  if (!includeTime) {
    return '${local.day} ${months[local.month - 1]} ${local.year}';
  }

  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final year = local.year;
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final second = local.second.toString().padLeft(2, '0');
  final period = local.hour >= 12 ? 'PM' : 'AM';

  return '$day/$month/$year, $hour:$minute:$second $period';
}
