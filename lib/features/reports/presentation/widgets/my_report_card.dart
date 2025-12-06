import 'package:flutter/material.dart';
import 'package:eduspace_flutter_app/core/ui/theme.dart';
import 'package:eduspace_flutter_app/features/reports/domain/report_with_context.dart';
import 'package:intl/intl.dart';

class MyReportCard extends StatelessWidget {
  final ReportWithContext report;
  final VoidCallback onTap;

  const MyReportCard({super.key, required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPending = report.status.toLowerCase() == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: MaterialTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: MaterialTheme.black1.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isPending
                    ? MaterialTheme.createBrandGradient()
                    : LinearGradient(
                        colors: [
                          MaterialTheme.gray2.withValues(alpha: 0.3),
                          MaterialTheme.gray2.withValues(alpha: 0.1),
                        ],
                      ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: MaterialTheme.white.withValues(
                        alpha: isPending ? 0.2 : 0.5,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: isPending
                          ? MaterialTheme.white
                          : MaterialTheme.gray2,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.kindOfReport,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isPending
                                ? MaterialTheme.white
                                : MaterialTheme.gray2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isPending
                                ? MaterialTheme.white.withValues(alpha: 0.2)
                                : MaterialTheme.gray2.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            report.status,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isPending
                                  ? MaterialTheme.white
                                  : MaterialTheme.gray2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: MaterialTheme.black1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.class_outlined,
                    label: 'Classroom',
                    value: report.classroomName,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.inventory_2_outlined,
                    label: 'Resource',
                    value: report.resourceName,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.calendar_today,
                    label: 'Created',
                    value: DateFormat('MMM d, yyyy').format(report.createdAt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: MaterialTheme.brandPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: MaterialTheme.brandPrimary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: MaterialTheme.gray2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: MaterialTheme.black1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
