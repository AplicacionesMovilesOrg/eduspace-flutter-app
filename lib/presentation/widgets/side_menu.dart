import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF4285F4); // Azul encabezado
    final Color selectedBg = const Color(0xFFE3F2FD);  // Fondo item seleccionado
    final Color logoutRed = const Color(0xFFD32F2F);   // Rojo logout
    final Color textDark = const Color(0xFF1F1F1F);    // Texto normal
    
    // Estilo de texto común
    final TextStyle menuTextStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0), 
          bottomRight: Radius.circular(0)
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 120, 
            color: primaryBlue,
            alignment: Alignment.center, // Centrado vertical y horizontal
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
          // 2. BODY (Lista de opciones)
          // ------------------------------------------------
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                // Item Seleccionado: HOME
                _buildMenuItem(
                  icon: Icons.home_filled,
                  text: 'Home',
                  isSelected: true,
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
                  textStyle: menuTextStyle,
                  onTap: () => Navigator.pop(context),
                ),
                
                // Items Inactivos
                _buildMenuItem(
                  icon: Icons.door_front_door_outlined,
                  text: 'Classrooms',
                  isSelected: false,
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
                  textStyle: menuTextStyle,
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.groups_outlined,
                  text: 'Shared Spaces',
                  isSelected: false,
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
                  textStyle: menuTextStyle,
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.calendar_today_outlined,
                  text: 'Meetings',
                  isSelected: false,
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
                  textStyle: menuTextStyle,
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.person_outline,
                  text: 'Teachers',
                  isSelected: false,
                  activeColor: primaryBlue,
                  activeBg: selectedBg,
                  textColor: textDark,
                  textStyle: menuTextStyle,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // ------------------------------------------------
          // 3. FOOTER (Logout y Selector de Idioma)
          // ------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Column(
              children: [
                const Divider(height: 30, thickness: 1),
                
                // Opción Logout
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.logout, color: logoutRed),
                  title: Text(
                    'Logout',
                    style: menuTextStyle.copyWith(color: logoutRed),
                  ),
                  onTap: () {},
                ),
                
                const SizedBox(height: 10),

                // Selector de Idioma (Caja Gris)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F5), // Gris claro del fondo
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Etiqueta Izquierda
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
                      
                      // Toggle Switch (Caja blanca con borde)
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Opción Seleccionada (EN)
                            _buildLanguageItem('EN', '🇬🇧', true),
                            
                            // Separador vertical
                            Container(width: 1, height: 20, color: Colors.grey.shade300),
                            
                            // Opción Inactiva (ES)
                            _buildLanguageItem('ES', '🇪🇸', false),
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

  // ------------------------------------------------
  // WIDGETS AUXILIARES
  // ------------------------------------------------

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
        borderRadius: BorderRadius.circular(30), // Bordes muy redondeados (Pill shape)
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
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildLanguageItem(String code, String flag, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // Checkmark solo si está seleccionado
          if (isSelected) ...[
            const Icon(Icons.check, size: 14, color: Colors.black87),
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