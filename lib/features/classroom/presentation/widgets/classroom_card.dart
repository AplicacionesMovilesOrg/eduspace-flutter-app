import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/classroom/domain/models/classroom.dart';
import 'package:eduspace_flutter_app/features/reports/data/report_service.dart';
import 'package:eduspace_flutter_app/features/reports/data/resource_service.dart';
import 'package:eduspace_flutter_app/features/reports/presentation/blocs/report_bloc.dart';
import 'package:eduspace_flutter_app/features/reports/presentation/pages/reports_page.dart';

class ClassroomCard extends StatelessWidget {
  final Classroom classroom;
  const ClassroomCard({super.key, required this.classroom});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => ReportBloc(
                  reportService: ReportService(
                    storageService: StorageService(),
                  ),
                  resourceService: ResourceService(
                    storageService: StorageService(),
                  ),
                ),
                child: ReportsPage(classroomId: classroom.id),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.school,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classroom.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      classroom.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
