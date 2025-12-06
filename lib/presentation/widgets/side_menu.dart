import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/core/ui/theme.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/pages/reservation_create_page.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/pages/my_reservations_page.dart';
import 'package:eduspace_flutter_app/features/reports/presentation/pages/my_reports_page.dart';

class SideMenu extends StatelessWidget {
  final String currentPage;

  const SideMenu({super.key, this.currentPage = 'home'});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final TextStyle menuTextStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    return Drawer(
      backgroundColor: MaterialTheme.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              gradient: MaterialTheme.createBrandGradient(),
            ),
            alignment: Alignment.center,
            child: SafeArea(
              bottom: false,
              child: const Text(
                'Eduspace',
                style: TextStyle(
                  color: MaterialTheme.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildMenuItem(
                  icon: Icons.home_filled,
                  text: 'Home',
                  isSelected: currentPage == 'home',
                  activeColor: MaterialTheme.brandPrimary,
                  activeBg: MaterialTheme.brandPrimary.withValues(alpha: 0.1),
                  textColor: colorScheme.onSurface,
                  textStyle: menuTextStyle,
                  onTap: () {
                    if (currentPage != 'home') {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),

                _buildMenuItem(
                  icon: Icons.edit,
                  text: 'Reservations',
                  isSelected: currentPage == 'reservations',
                  activeColor: MaterialTheme.brandPrimary,
                  activeBg: MaterialTheme.brandPrimary.withValues(alpha: 0.1),
                  textColor: colorScheme.onSurface,
                  textStyle: menuTextStyle,
                  onTap: () {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is Authenticated) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationCreatePage(
                            teacherId: authState.user.id,
                          ),
                        ),
                      );
                    }
                  },
                ),

                _buildMenuItem(
                  icon: Icons.calendar_today,
                  text: 'My Reservations',
                  isSelected: currentPage == 'my_reservations',
                  activeColor: MaterialTheme.brandPrimary,
                  activeBg: MaterialTheme.brandPrimary.withValues(alpha: 0.1),
                  textColor: colorScheme.onSurface,
                  textStyle: menuTextStyle,
                  onTap: () {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is Authenticated) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyReservationsPage(teacherId: authState.user.id),
                        ),
                      );
                    }
                  },
                ),

                _buildMenuItem(
                  icon: Icons.campaign_outlined,
                  text: 'My Reports',
                  isSelected: currentPage == 'my_reports',
                  activeColor: MaterialTheme.brandPrimary,
                  activeBg: MaterialTheme.brandPrimary.withValues(alpha: 0.1),
                  textColor: colorScheme.onSurface,
                  textStyle: menuTextStyle,
                  onTap: () {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is Authenticated) {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyReportsPage(teacherId: authState.user.id),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Column(
              children: [
                Divider(
                  height: 30,
                  thickness: 1,
                  color: MaterialTheme.gray2.withValues(alpha: 0.2),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout, color: MaterialTheme.stateError),
                  title: Text(
                    'Logout',
                    style: menuTextStyle.copyWith(
                      color: MaterialTheme.stateError,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    context.read<AuthBloc>().add(LoggedOut());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required bool isSelected,
    required Color activeColor,
    required Color activeBg,
    required Color textColor,
    required TextStyle textStyle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? activeColor : textColor.withValues(alpha: 0.6),
          size: 22,
        ),
        title: Text(
          text,
          style: textStyle.copyWith(
            color: isSelected ? activeColor : textColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
