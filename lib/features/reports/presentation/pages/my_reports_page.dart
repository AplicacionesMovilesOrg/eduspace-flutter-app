import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/ui/theme.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/reports/data/report_service.dart';
import 'package:eduspace_flutter_app/features/reports/presentation/blocs/my_reports_cubit.dart';
import 'package:eduspace_flutter_app/features/reports/presentation/widgets/my_report_card.dart';
import 'package:eduspace_flutter_app/features/reports/presentation/pages/report_details_page.dart';
import 'package:eduspace_flutter_app/features/reports/presentation/pages/create_report_flow_page.dart';
import 'package:eduspace_flutter_app/presentation/widgets/side_menu.dart';

class MyReportsPage extends StatelessWidget {
  final String teacherId;

  const MyReportsPage({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => MyReportsCubit(
        service: ReportService(storageService: StorageService()),
      )..loadTeacherReports(teacherId),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        drawer: const SideMenu(currentPage: 'my_reports'),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'My Reports',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: MaterialTheme.createLightGradient(),
          ),
          child: BlocBuilder<MyReportsCubit, MyReportsState>(
            builder: (context, state) {
              if (state is MyReportsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: MaterialTheme.brandPrimary,
                  ),
                );
              }

              if (state is MyReportsError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: MaterialTheme.stateError.withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: MaterialTheme.stateError,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Error loading reports',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.message,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<MyReportsCubit>().loadTeacherReports(
                              teacherId,
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MaterialTheme.brandPrimary,
                            foregroundColor: MaterialTheme.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is MyReportsLoaded) {
                if (state.reports.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              gradient: MaterialTheme.createBrandGradient(),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: MaterialTheme.brandPrimary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.assignment_late_outlined,
                              size: 60,
                              color: MaterialTheme.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No reports yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Create your first report to see it here',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<MyReportsCubit>().loadTeacherReports(
                      teacherId,
                    );
                  },
                  color: MaterialTheme.brandPrimary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.reports.length,
                    itemBuilder: (context, index) {
                      final report = state.reports[index];
                      return MyReportCard(
                        report: report,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportDetailsPage(
                                report: report,
                                teacherId: teacherId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CreateReportFlowPage(accountId: teacherId),
              ),
            );
          },
          backgroundColor: MaterialTheme.brandPrimary,
          child: const Icon(Icons.add, color: MaterialTheme.white),
        ),
      ),
    );
  }
}
