import 'package:flutter/material.dart';

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
          // 2. BODY (Nuevas Opciones del Menú)
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
                  icon: Icons.edit_document, // Icono de lista con lápiz
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
                  icon: Icons.campaign_outlined, // Icono de megáfono
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
          // 3. FOOTER (Logout y Lenguaje - Se mantienen igual)
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
                  onTap: () {},
                ),
                
                const SizedBox(height: 10),

                // Selector de Idioma (Caja Gris Redondeada)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F5), 
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Texto "Language"
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Icon(Icons.language, color: Colors.blueGrey[700], size: 22),
                          const SizedBox(width: 10),
                          Text(
                            'Language', 
                            style: menuTextStyle.copyWith(
                              color: Colors.blueGrey[800], 
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                      
                      // Toggle Switch
                      Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLanguageOption('EN', '🇬🇧', true),
                            Container(width: 1, height: 16, color: Colors.grey.shade300),
                            _buildLanguageOption('ES', '🇪🇸', false),
                          ],
                        ),
                      )
                    ],
                  ),
                )
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

  Widget _buildLanguageOption(String code, String flag, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          if (isSelected) ...[
            const Icon(Icons.check, size: 12, color: Colors.black),
            const SizedBox(width: 4),
          ],
          Text(
            '$code $flag',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}