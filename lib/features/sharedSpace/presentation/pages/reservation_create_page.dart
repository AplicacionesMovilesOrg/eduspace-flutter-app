import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/data/reservation_repository_impl.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/data/reservation_service.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/data/shared_area_service.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/blocs/shared_area_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/blocs/reservation_cubit.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/widgets/reservation_form.dart';
import 'package:eduspace_flutter_app/presentation/widgets/side_menu.dart';

class ReservationCreatePage extends StatelessWidget {
  final String teacherId;

  const ReservationCreatePage({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ReservationCubit(
            repository: ReservationRepositoryImpl(
              service: ReservationService(storageService: StorageService()),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => SharedAreaCubit(
            service: SharedAreaService(storageService: StorageService()),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        drawer: const SideMenu(currentPage: 'reservations'),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
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
        body: ReservationForm(teacherId: teacherId),
      ),
    );
  }
}
