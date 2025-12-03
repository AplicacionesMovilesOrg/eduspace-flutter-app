import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/ui/theme.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/blocs/reservation_cubit.dart';
import 'package:intl/intl.dart';

class ReservationForm extends StatefulWidget {
  final String teacherId;
  final String areaId;

  const ReservationForm({
    Key? key,
    required this.teacherId,
    required this.areaId,
  }) : super(key: key);

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = TimeOfDay(
    hour: (TimeOfDay.now().hour + 1) % 24, 
    minute: TimeOfDay.now().minute
  );

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
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
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
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
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final start = _combineDateAndTime(_startDate, _startTime);
      final end = _combineDateAndTime(_endDate, _endTime);

      if (end.isBefore(start) || end.isAtSameMomentAs(start)) {
        _showErrorSnackBar('End time must be after start time');
        return;
      }

      context.read<ReservationCubit>().createReservation(
        teacherId: widget.teacherId,
        areaId: widget.areaId,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                  Expanded(
                    child: Text('Reservation created successfully!'),
                  ),
                ],
              ),
              backgroundColor: MaterialTheme.stateSuccess,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
                // Header Card with Brand Gradient
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: MaterialTheme.createBrandGradient(),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: MaterialTheme.brandPrimary.withOpacity(0.3),
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
                          color: MaterialTheme.white.withOpacity(0.2),
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
                        'Create New Reservation',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MaterialTheme.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill in the details below',
                        style: TextStyle(
                          fontSize: 14,
                          color: MaterialTheme.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Title Input
                Container(
                  decoration: BoxDecoration(
                    color: MaterialTheme.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: MaterialTheme.black1.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _titleController,
                    style: const TextStyle(fontSize: 16, color: MaterialTheme.black1),
                    decoration: InputDecoration(
                      labelText: 'Reservation Title',
                      hintText: 'Enter a descriptive title',
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MaterialTheme.brandPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.title,
                          color: MaterialTheme.brandPrimary,
                          size: 20,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: MaterialTheme.white,
                      labelStyle: const TextStyle(color: MaterialTheme.gray2),
                      floatingLabelStyle: const TextStyle(
                        color: MaterialTheme.brandPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      if (value.trim().length < 3) {
                        return 'Title must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Start Time Section
                _buildDateTimeSection(
                  context: context,
                  title: 'Start Time',
                  icon: Icons.play_circle_outline,
                  date: _startDate,
                  time: _startTime,
                  isStart: true,
                ),
                const SizedBox(height: 24),

                // Duration Badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: MaterialTheme.brandPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 16,
                          color: MaterialTheme.brandPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _calculateDuration(),
                          style: const TextStyle(
                            color: MaterialTheme.brandPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // End Time Section
                _buildDateTimeSection(
                  context: context,
                  title: 'End Time',
                  icon: Icons.stop_circle_outlined,
                  date: _endDate,
                  time: _endTime,
                  isStart: false,
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
                            color: MaterialTheme.brandPrimary.withOpacity(0.4),
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
                                  Icon(Icons.check_circle, 
                                       size: 22, 
                                       color: MaterialTheme.white),
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

  Widget _buildDateTimeSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required DateTime date,
    required TimeOfDay time,
    required bool isStart,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MaterialTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: MaterialTheme.black1.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: MaterialTheme.brandPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: MaterialTheme.brandPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: MaterialTheme.black1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateTimeButton(
                  context: context,
                  icon: Icons.calendar_today,
                  label: DateFormat('MMM dd, yyyy').format(date),
                  onPressed: () => _selectDate(context, isStart),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateTimeButton(
                  context: context,
                  icon: Icons.access_time,
                  label: time.format(context),
                  onPressed: () => _selectTime(context, isStart),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: MaterialTheme.gray5,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: MaterialTheme.gray4,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: MaterialTheme.brandPrimary,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MaterialTheme.gray2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateDuration() {
    final start = _combineDateAndTime(_startDate, _startTime);
    final end = _combineDateAndTime(_endDate, _endTime);
    final duration = end.difference(start);

    if (duration.isNegative) return 'Invalid duration';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours == 0) {
      return '$minutes min${minutes != 1 ? 's' : ''}';
    } else if (minutes == 0) {
      return '$hours hour${hours != 1 ? 's' : ''}';
    } else {
      return '$hours hr${hours != 1 ? 's' : ''} $minutes min';
    }
  }
}