import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:eduspace_flutter_app/features/auth/presentation/blocs/auth_event.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos los colores exactos del diseño "Eduspace"
    final Color primaryBlue = const Color(0xFF4285F4); // Azul principal
    final Color selectedBg = const Color(0xFFE3F2FD);  // Fondo item seleccionado
    final Color logoutRed = const Color(0xFFD32F2F);   // Rojo logout
    final Color textDark = const Color(0xFF1F1F1F);    // Texto general
    
    // Estilo de texto base
    final TextStyle menuTextStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    return Drawer(
      backgroundColor: Colors.white,
      // Quitamos el borde redondeado del drawer para que sea recto
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          // ------------------------------------------------
          // 1. HEADER (Título Azul)
          // ------------------------------------------------
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

          // ------------------------------------------------
          // 2. BODY (Opciones del Menú)
          // ------------------------------------------------
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                // Opción 1: Home (Seleccionada por defecto)
                _buildMenuItem(
                  icon: Icons.home_filled, 
                  text: 'Home',
                  isSelected: true, // Item activo (azul)
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
                  textStyle: menuTextStyle,
                  onTap: () => Navigator.pop(context),
                ),
                
                // Opción 2: Reservations
                _buildMenuItem(
                  icon: Icons.edit_document, 
                  text: 'Reservations',
                  isSelected: false,
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
                  textStyle: menuTextStyle,
                  onTap: () {
                    // Navegación a Reservas
                  },
                ),

                // Opción 3: Breakdown Reports
                _buildMenuItem(
                  icon: Icons.campaign_outlined, 
                  text: 'Breakdown Reports',
                  isSelected: false,
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
                  textStyle: menuTextStyle,
                  onTap: () {
                    // Navegación a Reportes
                  },
                ),
              ],
            ),
          ),

          // ------------------------------------------------
          // 3. FOOTER (Solo Logout)
          // ------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Column(
              children: [
                const Divider(height: 30, thickness: 1),
                
                // Botón Logout (Rojo)
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}