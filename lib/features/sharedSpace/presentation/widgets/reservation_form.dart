import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/ui/theme.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/blocs/reservation_cubit.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/blocs/shared_area_cubit.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/shared_area.dart';
import 'package:intl/intl.dart';

class ReservationForm extends StatefulWidget {
  final String teacherId;

  const ReservationForm({super.key, required this.teacherId});

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  double _durationHours = 1.0;
  SharedArea? _selectedArea;

  @override
  void initState() {
    super.initState();
    context.read<SharedAreaCubit>().loadSharedAreas();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  DateTime _calculateEndTime() {
    final start = _combineDateAndTime(_selectedDate, _startTime);
    final durationMinutes = (_durationHours * 60).round();
    return start.add(Duration(minutes: durationMinutes));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MaterialTheme.brandPrimary,
              onPrimary: MaterialTheme.white,
              surface: MaterialTheme.white,
              onSurface: MaterialTheme.black1,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: MaterialTheme.brandPrimary,
              onPrimary: MaterialTheme.white,
              surface: MaterialTheme.white,
              onSurface: MaterialTheme.black1,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedArea == null) {
        _showErrorSnackBar('Please select an area');
        return;
      }

      final start = _combineDateAndTime(_selectedDate, _startTime);
      final end = _calculateEndTime();

      context.read<ReservationCubit>().createReservation(
        teacherId: widget.teacherId,
        areaId: _selectedArea!.id,
        title: _titleController.text.trim(),
        start: start,
        end: end,
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: MaterialTheme.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: MaterialTheme.stateError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationCubit, ReservationState>(
      listener: (context, state) {
        if (state is ReservationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.check_circle_outline, color: MaterialTheme.white),
                  SizedBox(width: 12),
                  Expanded(child: Text('Reservation created successfully!')),
                ],
              ),
              backgroundColor: MaterialTheme.stateSuccess,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
          Navigator.of(context).pop(state.reservation);
        } else if (state is ReservationError) {
          _showErrorSnackBar(state.message);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: MaterialTheme.createLightGradient(),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: MaterialTheme.createBrandGradient(),
                    borderRadius: BorderRadius.circular(16),
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
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: MaterialTheme.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.event_available,
                          size: 40,
                          color: MaterialTheme.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Book a Space',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MaterialTheme.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill in the details to reserve a shared area',
                        style: TextStyle(
                          fontSize: 14,
                          color: MaterialTheme.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Activity Title
                _buildSectionTitle('Activity Title'),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: MaterialTheme.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: MaterialTheme.black1.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 16,
                      color: MaterialTheme.black1,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter activity name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: MaterialTheme.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an activity title';
                      }
                      if (value.trim().length < 3) {
                        return 'Title must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Select Area
                _buildSectionTitle('Select Area'),
                const SizedBox(height: 12),
                BlocBuilder<SharedAreaCubit, SharedAreaState>(
                  builder: (context, state) {
                    if (state is SharedAreaLoading) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: MaterialTheme.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is SharedAreaError) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: MaterialTheme.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: MaterialTheme.stateError,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Error loading areas',
                              style: TextStyle(color: MaterialTheme.stateError),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => context
                                  .read<SharedAreaCubit>()
                                  .loadSharedAreas(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is SharedAreaLoaded) {
                      if (state.areas.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: MaterialTheme.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'No areas available',
                            style: TextStyle(color: MaterialTheme.gray2),
                          ),
                        );
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: MaterialTheme.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: MaterialTheme.black1.withValues(
                                alpha: 0.05,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<SharedArea>(
                          initialValue: _selectedArea,
                          decoration: InputDecoration(
                            hintText: 'Select an area',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: MaterialTheme.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          items: state.areas.map((area) {
                            return DropdownMenuItem<SharedArea>(
                              value: area,
                              child: Text(area.name),
                            );
                          }).toList(),
                          onChanged: (SharedArea? value) {
                            setState(() {
                              _selectedArea = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select an area';
                            }
                            return null;
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),

                // Date
                _buildSectionTitle('Date'),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: MaterialTheme.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: MaterialTheme.black1.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: MaterialTheme.brandPrimary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('yyyy-MM-dd').format(_selectedDate),
                          style: const TextStyle(
                            fontSize: 16,
                            color: MaterialTheme.black1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MaterialTheme.stateInfo.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: MaterialTheme.stateInfo.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: MaterialTheme.stateInfo,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Reservations are available from 7:00 AM to 8:00 PM (max 2 hours)',
                          style: TextStyle(
                            fontSize: 13,
                            color: MaterialTheme.stateInfo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Start Time
                _buildSectionTitle('Start Time'),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: MaterialTheme.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: MaterialTheme.black1.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: MaterialTheme.brandPrimary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _startTime.format(context),
                          style: const TextStyle(
                            fontSize: 16,
                            color: MaterialTheme.black1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Duration Selector
                _buildSectionTitle('Duration (max 2hrs)'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: MaterialTheme.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: MaterialTheme.black1.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Duration',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: MaterialTheme.black1,
                            ),
                          ),
                          Text(
                            _formatDuration(_durationHours),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MaterialTheme.brandPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Slider(
                        value: _durationHours,
                        min: 0.5,
                        max: 2.0,
                        divisions: 3,
                        activeColor: MaterialTheme.brandPrimary,
                        inactiveColor: MaterialTheme.brandPrimary.withValues(
                          alpha: 0.2,
                        ),
                        label: _formatDuration(_durationHours),
                        onChanged: (value) {
                          setState(() {
                            _durationHours = value;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            '0.5h',
                            style: TextStyle(
                              fontSize: 12,
                              color: MaterialTheme.gray2,
                            ),
                          ),
                          Text(
                            '1h',
                            style: TextStyle(
                              fontSize: 12,
                              color: MaterialTheme.gray2,
                            ),
                          ),
                          Text(
                            '1.5h',
                            style: TextStyle(
                              fontSize: 12,
                              color: MaterialTheme.gray2,
                            ),
                          ),
                          Text(
                            '2h',
                            style: TextStyle(
                              fontSize: 12,
                              color: MaterialTheme.gray2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // End Time Display
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: MaterialTheme.brandPrimary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'End Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: MaterialTheme.gray2,
                        ),
                      ),
                      Text(
                        TimeOfDay.fromDateTime(
                          _calculateEndTime(),
                        ).format(context),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MaterialTheme.brandPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Submit Button
                BlocBuilder<ReservationCubit, ReservationState>(
                  builder: (context, state) {
                    final isLoading = state is ReservationLoading;

                    return Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: MaterialTheme.createBrandGradient(),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: MaterialTheme.brandPrimary.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: MaterialTheme.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 22,
                                    color: MaterialTheme.white,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Create Reservation',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                      color: MaterialTheme.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: MaterialTheme.black1,
      ),
    );
  }

  String _formatDuration(double hours) {
    if (hours == 0.5) return '30 minutes';
    if (hours == 1.0) return '1 hour';
    if (hours < 2.0) return '$hours hours';
    return '${hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 1)} hours';
  }
}
