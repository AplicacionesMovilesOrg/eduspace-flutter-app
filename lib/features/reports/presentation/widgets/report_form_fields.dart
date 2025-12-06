import 'package:flutter/material.dart';

class ReportFormFields extends StatelessWidget {
  final TextEditingController kindController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey;

  const ReportFormFields({
    super.key,
    required this.kindController,
    required this.descriptionController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: kindController,
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
            controller: descriptionController,
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
}
