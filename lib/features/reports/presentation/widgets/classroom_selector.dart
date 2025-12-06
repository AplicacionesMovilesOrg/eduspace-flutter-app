import 'package:flutter/material.dart';
import 'package:eduspace_flutter_app/features/classroom/domain/models/classroom.dart';

class ClassroomSelector extends StatelessWidget {
  final List<Classroom> classrooms;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const ClassroomSelector({
    super.key,
    required this.classrooms,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedId,
      decoration: const InputDecoration(
        labelText: 'Select Classroom',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: classrooms.map((classroom) {
        return DropdownMenuItem<String>(
          value: classroom.id,
          child: Text(classroom.name),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a classroom';
        }
        return null;
      },
    );
  }
}
