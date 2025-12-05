import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/pages/reservation_create_page.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/presentation/pages/my_reservations_page.dart';

class SideMenu extends StatelessWidget {
  final String currentPage;

  const SideMenu({super.key, this.currentPage = 'home'});

  @override
  Widget build(BuildContext context) {
    // Colores del tema
    final Color primaryBlue = const Color(0xFF4285F4);
    final Color selectedBg = const Color(0xFFE3F2FD);
    final Color logoutRed = const Color(0xFFD32F2F);
    final Color textDark = const Color(0xFF1F1F1F);

    final TextStyle menuTextStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    return Drawer(
      backgroundColor: const Color(0xFFF0F8FF),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            height: 120,
            color: primaryBlue,
            alignment: Alignment.center,
            child: SafeArea(
              bottom: false,
              child: const Text(
                'Eduspace',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildMenuItem(
                  icon: Icons.home_filled,
                  text: 'Home',
                  isSelected: currentPage == 'home',
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
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
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
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
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
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
                  text: 'Breakdown Reports',
                  isSelected: currentPage == 'breakdown_reports',
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
                  textStyle: menuTextStyle,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Column(
              children: [
                const Divider(height: 30, thickness: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.logout, color: logoutRed),
                  title: Text(
                    'Logout',
                    style: menuTextStyle.copyWith(
                      color: logoutRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
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

  // --- Widgets Auxiliares ---
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
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? activeColor : Colors.black87,
          size: 22,
        ),
        title: Text(
          text,
          style: textStyle.copyWith(
            color: isSelected ? activeColor : textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}
