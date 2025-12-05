import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/ui/theme.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/data/reservation_service.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/blocs/reservation_list_cubit.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/reservation.dart';
import 'package:intl/intl.dart';
import 'package:eduspace_flutter_app/presentation/widgets/side_menu.dart';

class MyReservationsPage extends StatelessWidget {
  final String teacherId;

  const MyReservationsPage({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => ReservationListCubit(
        service: ReservationService(storageService: StorageService()),
      )..loadTeacherReservations(teacherId),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        drawer: const SideMenu(currentPage: 'my_reservations'),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'My Reservations',
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
          child: BlocBuilder<ReservationListCubit, ReservationListState>(
            builder: (context, state) {
              if (state is ReservationListLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: MaterialTheme.brandPrimary,
                  ),
                );
              }

              if (state is ReservationListError) {
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
                          'Error loading reservations',
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
                            context
                                .read<ReservationListCubit>()
                                .loadTeacherReservations(teacherId);
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

              if (state is ReservationListLoaded) {
                if (state.reservations.isEmpty) {
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
                              Icons.event_busy,
                              size: 60,
                              color: MaterialTheme.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No reservations yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Create your first reservation to see it here',
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
                    context
                        .read<ReservationListCubit>()
                        .loadTeacherReservations(teacherId);
                  },
                  color: MaterialTheme.brandPrimary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.reservations.length,
                    itemBuilder: (context, index) {
                      final reservation = state.reservations[index];
                      return _ReservationCard(reservation: reservation);
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const _ReservationCard({required this.reservation});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isPast = reservation.end.isBefore(now);
    final isOngoing =
        reservation.start.isBefore(now) && reservation.end.isAfter(now);

    final duration = reservation.end.difference(reservation.start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isPast
                  ? LinearGradient(
                      colors: [
                        MaterialTheme.gray2.withValues(alpha: 0.3),
                        MaterialTheme.gray2.withValues(alpha: 0.1),
                      ],
                    )
                  : isOngoing
                  ? LinearGradient(
                      colors: [
                        MaterialTheme.stateSuccess.withValues(alpha: 0.2),
                        MaterialTheme.stateSuccess.withValues(alpha: 0.05),
                      ],
                    )
                  : MaterialTheme.createBrandGradient(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MaterialTheme.white.withValues(
                      alpha: isPast ? 0.5 : 0.2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPast
                        ? Icons.event_busy
                        : isOngoing
                        ? Icons.event_available
                        : Icons.event,
                    color: isPast
                        ? MaterialTheme.gray2
                        : isOngoing
                        ? MaterialTheme.stateSuccess
                        : MaterialTheme.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isPast
                              ? MaterialTheme.gray2
                              : MaterialTheme.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isOngoing)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: MaterialTheme.stateSuccess,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Ongoing',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: MaterialTheme.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: DateFormat(
                    'EEEE, MMM d, yyyy',
                  ).format(reservation.start),
                  isPast: isPast,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.access_time,
                  label: 'Time',
                  value:
                      '${DateFormat('h:mm a').format(reservation.start)} - ${DateFormat('h:mm a').format(reservation.end)}',
                  isPast: isPast,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.timelapse,
                  label: 'Duration',
                  value: hours > 0
                      ? '$hours hour${hours > 1 ? 's' : ''}${minutes > 0 ? ' $minutes min' : ''}'
                      : '$minutes minutes',
                  isPast: isPast,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isPast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isPast
                ? MaterialTheme.gray2.withValues(alpha: 0.1)
                : MaterialTheme.brandPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isPast ? MaterialTheme.gray2 : MaterialTheme.brandPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: MaterialTheme.gray2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isPast ? MaterialTheme.gray2 : MaterialTheme.black1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
