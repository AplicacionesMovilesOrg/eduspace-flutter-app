import 'package:eduspace_flutter_app/features/sharedSpace/data/reservation_repository_impl.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/data/reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/blocs/reservation_cubit.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/widgets/reservation_form.dart';

class ReservationCreatePage extends StatelessWidget {
  final String teacherId;
  final String areaId;

  const ReservationCreatePage({
    Key? key,
    required this.teacherId,
    required this.areaId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return BlocProvider(
      create: (context) => ReservationCubit(
        repository: ReservationRepositoryImpl(
          service: ReservationService(),
        ),
      ),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: colorScheme.onSurface,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'New Reservation',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: ReservationForm(
          teacherId: teacherId,
          areaId: areaId,
        ),
      ),
    );
  }
}