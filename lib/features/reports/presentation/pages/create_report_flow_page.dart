import 'package:flutter/material.dart';
import 'package:eduspace_flutter_app/core/ui/theme.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/classroom/data/classroom_service.dart';
import 'package:eduspace_flutter_app/features/classroom/data/teacher_profile_service.dart';
import 'package:eduspace_flutter_app/features/classroom/domain/models/classroom.dart';
import 'package:eduspace_flutter_app/features/reports/data/resource_service.dart';
import 'package:eduspace_flutter_app/features/reports/data/report_service.dart';
import 'package:eduspace_flutter_app/features/reports/domain/resource_light.dart';

class CreateReportFlowPage extends StatefulWidget {
  final String accountId;

  const CreateReportFlowPage({super.key, required this.accountId});

  @override
  State<CreateReportFlowPage> createState() => _CreateReportFlowPageState();
}

class _CreateReportFlowPageState extends State<CreateReportFlowPage> {
  int _currentStep = 0;
  bool _isLoading = false;

  List<Classroom> _classrooms = [];
  List<ResourceLight> _resources = [];

  String? _selectedClassroomId;
  String? _selectedResourceId;
  String? _teacherId;

  final _kindController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _teacherProfileService = TeacherProfileService(
    storageService: StorageService(),
  );
  final _classroomService = ClassroomService(storageService: StorageService());
  final _resourceService = ResourceService(storageService: StorageService());
  final _reportService = ReportService(storageService: StorageService());

  @override
  void initState() {
    super.initState();
    _loadTeacherProfileAndClassrooms();
  }

  @override
  void dispose() {
    _kindController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadTeacherProfileAndClassrooms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final teacherProfile = await _teacherProfileService.getByAccountId(
        widget.accountId,
      );
      final classrooms = await _classroomService.getByTeacherId(
        teacherProfile.id,
      );
      setState(() {
        _teacherId = teacherProfile.id;
        _classrooms = classrooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: MaterialTheme.stateError,
          ),
        );
      }
    }
  }

  Future<void> _loadResources(String classroomId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final resources = await _resourceService.getResourcesByClassroom(
        classroomId,
      );
      setState(() {
        _resources = resources;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading resources: $e'),
            backgroundColor: MaterialTheme.stateError,
          ),
        );
      }
    }
  }

  Future<void> _createReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _reportService.createReport(
        kindOfReport: _kindController.text.trim(),
        description: _descriptionController.text.trim(),
        resourceId: _selectedResourceId!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report created successfully'),
            backgroundColor: MaterialTheme.stateSuccess,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating report: $e'),
            backgroundColor: MaterialTheme.stateError,
          ),
        );
      }
    }
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedClassroomId != null) {
      _loadResources(_selectedClassroomId!);
      setState(() {
        _currentStep = 1;
        _selectedResourceId = null;
      });
    } else if (_currentStep == 1 && _selectedResourceId != null) {
      setState(() {
        _currentStep = 2;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Create Report',
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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: MaterialTheme.brandPrimary,
                ),
              )
            : Column(
                children: [
                  _buildStepIndicator(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: MaterialTheme.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: MaterialTheme.black1.withValues(
                                alpha: 0.08,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _buildCurrentStep(),
                      ),
                    ),
                  ),
                  _buildNavigationButtons(),
                ],
              ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          _buildStepCircle(0, 'Classroom'),
          _buildStepLine(0),
          _buildStepCircle(1, 'Resource'),
          _buildStepLine(1),
          _buildStepCircle(2, 'Details'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = _currentStep >= step;
    final isCurrent = _currentStep == step;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? MaterialTheme.brandPrimary
                  : MaterialTheme.gray2.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              border: isCurrent
                  ? Border.all(color: MaterialTheme.brandPrimary, width: 3)
                  : null,
            ),
            child: Center(
              child: Text(
                '${step + 1}',
                style: TextStyle(
                  color: isActive ? MaterialTheme.white : MaterialTheme.gray2,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
              color: isActive
                  ? MaterialTheme.brandPrimary
                  : MaterialTheme.gray2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step) {
    final isActive = _currentStep > step;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        color: isActive
            ? MaterialTheme.brandPrimary
            : MaterialTheme.gray2.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildClassroomStep();
      case 1:
        return _buildResourceStep();
      case 2:
        return _buildReportFormStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildClassroomStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Classroom',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MaterialTheme.black1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose the classroom where you want to create a report',
          style: TextStyle(fontSize: 14, color: MaterialTheme.gray2),
        ),
        const SizedBox(height: 24),
        if (_classrooms.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'No classrooms available',
                style: TextStyle(fontSize: 16, color: MaterialTheme.gray2),
              ),
            ),
          )
        else
          RadioGroup<String>(
            groupValue: _selectedClassroomId,
            onChanged: (value) {
              setState(() {
                _selectedClassroomId = value;
              });
            },
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _classrooms.length,
              itemBuilder: (context, index) {
                final classroom = _classrooms[index];
                final isSelected = _selectedClassroomId == classroom.id;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? MaterialTheme.brandPrimary
                          : MaterialTheme.gray2.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: RadioListTile<String>(
                    value: classroom.id,
                    title: Text(
                      classroom.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(classroom.description),
                    activeColor: MaterialTheme.brandPrimary,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildResourceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Resource',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MaterialTheme.black1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose the resource to report an issue with',
          style: TextStyle(fontSize: 14, color: MaterialTheme.gray2),
        ),
        const SizedBox(height: 24),
        if (_resources.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'No resources available in this classroom',
                style: TextStyle(fontSize: 16, color: MaterialTheme.gray2),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          RadioGroup<String>(
            groupValue: _selectedResourceId,
            onChanged: (value) {
              setState(() {
                _selectedResourceId = value;
              });
            },
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _resources.length,
              itemBuilder: (context, index) {
                final resource = _resources[index];
                final isSelected = _selectedResourceId == resource.id;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? MaterialTheme.brandPrimary
                          : MaterialTheme.gray2.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: RadioListTile<String>(
                    value: resource.id,
                    title: Text(
                      resource.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    activeColor: MaterialTheme.brandPrimary,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildReportFormStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MaterialTheme.black1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fill in the report information',
            style: TextStyle(fontSize: 14, color: MaterialTheme.gray2),
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
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MaterialTheme.white,
        boxShadow: [
          BoxShadow(
            color: MaterialTheme.black1.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep == 2
                  ? _createReport
                  : (_currentStep == 0 && _selectedClassroomId != null) ||
                        (_currentStep == 1 && _selectedResourceId != null)
                  ? _nextStep
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: MaterialTheme.brandPrimary,
                foregroundColor: MaterialTheme.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_currentStep == 2 ? 'Create Report' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
