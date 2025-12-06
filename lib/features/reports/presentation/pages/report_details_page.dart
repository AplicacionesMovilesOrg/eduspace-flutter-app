import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/ui/theme.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/reports/data/report_service.dart';
import 'package:eduspace_flutter_app/features/reports/domain/report_with_context.dart';
import 'package:eduspace_flutter_app/features/reports/presentation/blocs/report_details_cubit.dart';
import 'package:intl/intl.dart';

class ReportDetailsPage extends StatefulWidget {
  final ReportWithContext report;
  final String teacherId;

  const ReportDetailsPage({
    super.key,
    required this.report,
    required this.teacherId,
  });

  @override
  State<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  bool _isEditMode = false;
  late TextEditingController _kindController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _kindController = TextEditingController(text: widget.report.kindOfReport);
    _descriptionController = TextEditingController(
      text: widget.report.description,
    );
  }

  @override
  void dispose() {
    _kindController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text(
          'Are you sure you want to delete this report? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ReportDetailsCubit>().deleteReport(widget.report.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: MaterialTheme.stateError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => ReportDetailsCubit(
        service: ReportService(storageService: StorageService()),
      )..loadReport(widget.report),
      child: BlocListener<ReportDetailsCubit, ReportDetailsState>(
        listener: (context, state) {
          if (state is ReportDetailsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Operation completed successfully'),
                backgroundColor: MaterialTheme.stateSuccess,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is ReportDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: MaterialTheme.stateError,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Report Details',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              if (!_isEditMode)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditMode = true;
                    });
                  },
                ),
              if (!_isEditMode)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _showDeleteConfirmation(context),
                ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: MaterialTheme.createLightGradient(),
            ),
            child: BlocBuilder<ReportDetailsCubit, ReportDetailsState>(
              builder: (context, state) {
                if (state is ReportDetailsUpdating ||
                    state is ReportDetailsDeleting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: MaterialTheme.brandPrimary,
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
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
                    child: _isEditMode
                        ? _buildEditMode(context)
                        : _buildViewMode(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewMode() {
    final isPending = widget.report.status.toLowerCase() == 'pending';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: MaterialTheme.createBrandGradient(),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: MaterialTheme.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.report.kindOfReport,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: MaterialTheme.black1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isPending
                          ? MaterialTheme.brandPrimary.withValues(alpha: 0.1)
                          : MaterialTheme.gray2.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.report.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isPending
                            ? MaterialTheme.brandPrimary
                            : MaterialTheme.gray2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        _buildInfoSection('Description', widget.report.description),
        const SizedBox(height: 16),
        _buildInfoSection('Classroom', widget.report.classroomName),
        const SizedBox(height: 16),
        _buildInfoSection('Resource', widget.report.resourceName),
        const SizedBox(height: 16),
        _buildInfoSection(
          'Created At',
          DateFormat(
            'EEEE, MMM d, yyyy - h:mm a',
          ).format(widget.report.createdAt),
        ),
      ],
    );
  }

  Widget _buildEditMode(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Report',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MaterialTheme.black1,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _kindController,
            decoration: const InputDecoration(
              labelText: 'Kind of Report',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the kind of report';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            minLines: 3,
            maxLines: 5,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isEditMode = false;
                      _kindController.text = widget.report.kindOfReport;
                      _descriptionController.text = widget.report.description;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ReportDetailsCubit>().updateReport(
                        reportId: widget.report.id,
                        kindOfReport: _kindController.text.trim(),
                        description: _descriptionController.text.trim(),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MaterialTheme.brandPrimary,
                    foregroundColor: MaterialTheme.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: MaterialTheme.gray2,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: MaterialTheme.black1,
          ),
        ),
      ],
    );
  }
}
